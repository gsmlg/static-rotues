#!/bin/sh

cmd=aria2c
url="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country-CSV&license_key=${GEOIP_LICENSE_KEY}&suffix=zip"

${cmd} $url -o GeoLite2-Country-CSV.zip
${cmd} ${url}.sha256 -o GeoLite2-Country-CSV.zip.sha256

SUMFUNC=$(which sha256sum)

if [ -x "$SUMFUNC" ]
then
CHECKSUM=`${SUMFUNC} GeoLite2-Country-CSV.zip  |awk '{print $1}'`
fi

sum=`cat GeoLite2-Country-CSV.zip.sha256 |awk '{print $1}'`


if [[ $CHECKSUM == $sum ]]
then
    echo "download success"
    rm GeoLite2-Country-CSV.zip.sha256
    exit 0
else
    echo "checksum fail, data is incorrect"
    exit 1
fi


