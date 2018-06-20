#!/bin/bash

aria2c \
    "https://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest" \
    -o "source.txt"


