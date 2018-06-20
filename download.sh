#!/bin/sh

cmd=curl
url=http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip

${cmd} $url -o GeoLite2-Country-CSV.zip
${cmd} ${url}.md5 -o GeoLite2-Country-CSV.zip.md5

