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

rt = routes.map do |r|
  network, mask = r.split("/")
  lmask = IPAddr.new('255.255.255.255').mask(mask).to_s
  %Q(push "route #{network} #{lmask}")
end

File.open "openvpn.txt", "w" do |f|
    rt.each do |l|
        f << "#{l}\n"
    end
end

