#!/usr/bin/env ruby
#
# create route file
# ip-up ip-down
#

require "fileutils"
require "csv"

names = CSV.read("name.csv")

cn = names.find do |r|
    r[4] == "CN" 
end

cnCode = cn[0]

data = CSV.read("data.csv")
routes = []
cnRoutes = []

data.slice(1, data.length).each do |r|
    if r.include?(cnCode)
        cnRoutes << r[0]
    else
        routes << r[0]
    end
end

=begin
File.open "foreign.txt", "w" do |f|
    f.write(routes.join("\n"))
end


File.open "cn.txt", "w" do |f|
    f.write(cnRoutes.join("\n"))
end
=end

FileUtils.rm_rf("mode1")
FileUtils.mkdir("mode1")

rt = routes.map do |r|
    "route add -net #{r} -iface ${DEV}"
end.join("\n")

ip_up = <<-EOF
#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

DEV=$1
ip=$4
vip=$5
route=$6

#{rt}

EOF

File.open "mode1/ip-up", "w" do |f|
    f.write(ip_up)
end



FileUtils.rm_rf("mode2")
FileUtils.mkdir("mode2")

rt = cnRoutes.map do |r|
    "route add -net #{r} ${LGW}"
end.join("\n")

ip_up = <<-EOF
#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

dev=$1
ip=$4
vip=$5
LGW=$6

route add -net 10/8 ${LGW}
route add -net 172.16/12 ${LGW}
route add -net 192.168/16 ${LGW}

#{rt}

EOF


rt = cnRoutes.map do |r|
    "route delete -net #{r} ${LGW}"
end.join("\n")


ip_down = <<-EOF
#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

dev=$1
ip=$4
vip=$5
LGW=$6

route delete -net 10/8 ${LGW}
route delete -net 172.16/12 ${LGW}
route delete -net 192.168/16 ${LGW}

#{rt}

EOF

File.open "mode2/ip-up", "w" do |f|
    f.write(ip_up)
end


File.open "mode2/ip-down", "w" do |f|
    f.write(ip_down)
end



