#!/usr/bin/env ruby
#
#

def get_p(n)
    n = n.to_i
    m = 0
    while (n = n / 2) > 1 do
        m += 1
    end
    m
end

File.open "cn.txt", "r" do |f|
File.open "cn.routes", "w" do |f1|
    while l = f.gets do
        ip, count = l.split
        mask = 31 - get_p(count)
        f1 << "#{ip}/#{mask}\n"
    end
end
end


File.open "forin.txt", "r" do |f|
File.open "forin.routes", "w" do |f1|
    while l = f.gets do
        ip, count = l.split
        mask = 31 - get_p(count)
        f1 << "#{ip}/#{mask}\n"
    end
end
end

