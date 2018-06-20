#!/bin/bash

zipFile=GeoLite2-Country-CSV.zip
dataFile=GeoLite2-Country-Blocks-IPv4.csv
nameFile=GeoLite2-Country-Locations-en.csv

mkdir tmp

unzip ${zipFile} -d tmp

find tmp -name $dataFile -exec mv {} data.csv \;
find tmp -name $nameFile -exec mv {} name.csv \;

rm -rf tmp

