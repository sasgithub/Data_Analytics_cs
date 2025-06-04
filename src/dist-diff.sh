#!/bin/bash
# 
# Author: sas
# Purpose: Calculate the distance between pairs of GPS coordinates
#          This uses the Haversine formula which caculates the distance
#          along the great arc between the two points. 
## 
isNum() {
  [[ $1 =~ ^-?[0-9]+([.][0-9]+)?$ ]]
}
# note to self: when you get time, convert this to use getopt instead
# this is ugly
PROGNAME="$(basename "$0")"
lat1=$1
long1=$2
lat2=$3
long2=$4

if isNum "$lat1" && isNum "$lat2" && isNum "$long1" && isNum "$long2"
then
  awk -v lat1="$lat1" -v long1="$long1" -v lat2="$lat2" -v long2="$long2" '
  BEGIN {
    pi = atan2(0, -1)
    R = 6371  # Earth radius in kilometers

    # convert degrees to radians
    lat1 *= pi / 180
    long1 *= pi / 180
    lat2 *= pi / 180
    long2 *= pi / 180

    dlat = lat2 - lat1
    dlong = long2 - long1

    a = sin(dlat / 2)^2 + cos(lat1) * cos(lat2) * sin(dlong / 2)^2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))
    d = R * c

    print d " km"
  }'
else
  echo "$PROGNAME: requires 4 numeric arguments" >&2
  exit 1  
fi
