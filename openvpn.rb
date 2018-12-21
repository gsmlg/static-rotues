#!/usr/bin/env ruby
#
# create route file
# ip-up ip-down
#

require "fileutils"
require "csv"
require "ipaddr"

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

rts = []
rtc = []

routes.map do |r|
  network, mask = r.split("/")
  lmask = IPAddr.new('255.255.255.255').mask(mask).to_s
  rtc << %Q(route #{network} #{lmask} vpn_gateway)
  rts << %Q(push "route #{network} #{lmask} vpn_gateway")
end

File.open "mode1/openvpn-client.txt", "w" do |f|
    rtc.each do |l|
        f << "#{l}\n"
    end
end

File.open "mode1/openvpn-server.txt", "w" do |f|
    rts.each do |l|
        f << "#{l}\n"
    end
end


FileUtils.rm_rf("mode2")
FileUtils.mkdir("mode2")

cts = [%Q(push "redirect-gateway def1 bypass-dhcp ipv6")]
ctc = ["redirect-gateway def1 bypass-dhcp ipv6"]

cnRoutes.map do |r|
  network, mask = r.split("/")
  lmask = IPAddr.new('255.255.255.255').mask(mask).to_s
  ctc << %Q(route #{network} #{lmask} net_gateway)
  cts << %Q(push "route #{network} #{lmask} net_gateway")
end

File.open "mode2/openvpn-client.txt", "w" do |f|
    ctc.each do |l|
        f << "#{l}\n"
    end
end

File.open "mode2/openvpn-server.txt", "w" do |f|
    cts.each do |l|
        f << "#{l}\n"
    end
end


