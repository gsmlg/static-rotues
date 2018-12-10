#!/bin/sh

cmd=aria2c
url=http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip

${cmd} $url -o GeoLite2-Country-CSV.zip
${cmd} ${url}.md5 -o GeoLite2-Country-CSV.zip.md5

MD5=$(which md5)
MD5SUM=$(which md5sum)

if [ -x "$MD5" ]
do
CHECKSUM=`md5 GeoLite2-Country-CSV.zip  |awk '{print $4}'`
done

if [ -x "$MD5SUM" ]
do
CHECKSUM=`md5sum GeoLite2-Country-CSV.zip  |awk '{print $1}'`
done

sum=`cat GeoLite2-Country-CSV.zip.md5`

if [[ $CHECKSUM == $sum ]]
then
    echo "download success"
    rm GeoLite2-Country-CSV.zip.md5
    exit 0
else
    echo "checksum fail, data is incorrect"
    exit 1
fi


