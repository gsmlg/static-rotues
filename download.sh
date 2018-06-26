#!/bin/sh

cmd=aria2c
url=http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip

${cmd} $url -o GeoLite2-Country-CSV.zip
${cmd} ${url}.md5 -o GeoLite2-Country-CSV.zip.md5


check=`md5 GeoLite2-Country-CSV.zip  |awk '{print $4}'`
sum=`cat GeoLite2-Country-CSV.zip.md5`

if [[ $check == $sum ]]
then
    echo "download success"
    rm GeoLite2-Country-CSV.zip.md5
    exit 0
else
    echo "checksum fail, data is incorrect"
    exit 1
fi


