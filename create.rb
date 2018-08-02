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

FileUtils.rm_rf("mode1")
FileUtils.mkdir("mode1")

rt = routes.map do |r|
    "route add -net #{r} -iface ${PPP_IFACE}"
end.join("\n")

ppp_head=<<-EOF
#!/bin/sh
# The  environment is cleared before executing this script
# so the path must be reset
PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin
export PATH

# This script is called with the following arguments:
#    Arg  Name                          Example
#    $1   Interface name                ppp0
#    $2   The tty                       ttyS1
#    $3   The link speed                38400
#    $4   Local IP number               12.34.56.78
#    $5   Peer  IP number               12.34.56.99
#    $6   Optional ``ipparam'' value    foo

# These variables are for the use of the scripts run by run-parts
PPP_IFACE="$1"
PPP_TTY="$2"
PPP_SPEED="$3"
PPP_LOCAL="$4"
PPP_REMOTE="$5"
PPP_IPPARAM="$6"
export PPP_IFACE PPP_TTY PPP_SPEED PPP_LOCAL PPP_REMOTE PPP_IPPARAM

# as an additional convenience, $PPP_TTYNAME is set to the tty name,
# stripped of /dev/ (if present) for easier matching.
PPP_TTYNAME=`/usr/bin/basename "$2"`
export PPP_TTYNAME

# If /var/log/ppp-ipupdown.log exists use it for logging.
if [ -e /var/log/ppp-ipupdown.log ]; then
  exec > /var/log/ppp-ipupdown.log 2>&1
  echo $0 $@
  echo
fi

# quit if connect to some vpn
[[ $PPP_REMOTE == "192.168.240.1" ]] && exit 0
EOF

ip_up = <<-EOF
#{ppp_head}

#{rt}

EOF

File.open "mode1/ip-up", "w" do |f|
    f.write(ip_up)
end

FileUtils.chmod_R "a+x", "mode1/"


FileUtils.rm_rf("mode2")
FileUtils.mkdir("mode2")

rt = cnRoutes.map do |r|
    "route add -net #{r} ${PPP_IPPARAM}"
end.join("\n")

ip_up = <<-EOF
#{ppp_head}

route add -net 10/8 ${PPP_IPPARAM}
route add -net 172.16/12 ${PPP_IPPARAM}
route add -net 192.168/16 ${PPP_IPPARAM}

#{rt}

EOF


rt = cnRoutes.map do |r|
    "route delete -net #{r} ${PPP_IPPARAM}"
end.join("\n")


ip_down = <<-EOF
#{ppp_head}

route delete -net 10/8 ${PPP_IPPARAM}
route delete -net 172.16/12 ${PPP_IPPARAM}
route delete -net 192.168/16 ${PPP_IPPARAM}

#{rt}

EOF

File.open "mode2/ip-up", "w" do |f|
    f.write(ip_up)
end


File.open "mode2/ip-down", "w" do |f|
    f.write(ip_down)
end


FileUtils.chmod_R "a+x", "mode2/"

