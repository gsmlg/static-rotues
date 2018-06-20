#!/usr/bin/env ruby
#
#

def get_p(n)
    Math.log(n.to_i) / Math.log(2)
end

File.open "cn.txt", "r" do |f|
File.open "cn.routes.txt", "w" do |f1|
    while l = f.gets do
        ip, count = l.split
        mask = 31 - get_p(count)
        f1 << "#{ip}/#{mask}\n"
    end
end
end


File.open "forin.txt", "r" do |f|
File.open "forin.routes.txt", "w" do |f1|
    while l = f.gets do
        ip, count = l.split
        mask = 31 - get_p(count)
        f1 << "#{ip}/#{mask}\n"
    end
end
end

