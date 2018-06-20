#!/usr/bin/env ruby
#

VPN_GW = "192.168.42.1"


def get_p(n)
    (Math.log(n.to_i) / Math.log(2)).to_i
end

cnRoutes = []
fRoutes = []

File.open "cn.txt", "r" do |f|
#File.open "cn.routes.txt", "w" do |f1|
    while l = f.gets do
        ip, count = l.split
        mask = 31 - get_p(count)
#        f1 << "#{ip}/#{mask}\n"
        cnRoutes << "#{ip}/#{mask}"
    end
#end
end


File.open "forin.txt", "r" do |f|
#File.open "forin.routes.txt", "w" do |f1|
    while l = f.gets do
        ip, count = l.split
        mask = 31 - get_p(count)
#        f1 << "#{ip}/#{mask}\n"
        fRoutes << "#{ip}/#{mask}"
    end
#end
end


routes = fRoutes.map do |r|
"route add #{r} ${VPN_GW}"
end.join("\n")

ip_up = <<EOF
#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

VPN_GW=#{VPN_GW}

#{routes}

EOF

File.open("ip-up", "w") do |f|
    f.write(ip_up)
end



routes = fRoutes.map do |r|
"route delete #{r} ${VPN_GW}"
end.join("\n")

ip_down = <<EOF
#!/bin/sh
export PATH="/bin:/sbin:/usr/sbin:/usr/bin"

VPN_GW=#{VPN_GW}

#{routes}

EOF

File.open("ip-down", "w") do |f|
    f.write(ip_down)
end





