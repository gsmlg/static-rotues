#!/bin/bash

file=source.txt

grep ipv4 $file |awk -F'|' '{if($2 == "CN") { print $4" "$5 }}' > cn.txt

grep ipv4 $file |awk -F'|' '{if($2 != "CN") { print $4" "$5 }}' |grep -v '*' > forin.txt

