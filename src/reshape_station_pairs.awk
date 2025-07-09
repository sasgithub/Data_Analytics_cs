#!/usr/bin/awk -f
#
# reshape_station_pairs.awk
#
# Converts station_pairs.csv into reshaped_pairs.csv by splitting each row
# into two rows—one per station—with ride counts preserved.
#
# USAGE:
#   awk -f reshape_station_pairs.awk station_pairs.csv > reshaped_pairs.csv
#
# INPUT CSV COLUMNS (station_pairs.csv):
#   1  station_a_name
#   2  station_a_lat
#   3  station_a_lon
#   4  station_b_name
#   5  station_b_lat
#   6  station_b_lon
#   7  total_rides
#   8  subscriber_rides
#   9  customer_rides
#
# OUTPUT CSV COLUMNS (reshaped_pairs.csv):
#   station_name,lat,lon,total_rides,subscriber_rides,customer_rides,path_id
#
BEGIN {
    FS = ",";
    OFS = ",";
    print "station_name,lat,lon,total_rides,subscriber_rides,customer_rides,path_id";
}
NR > 1 {
    print $1, $2, $3, $7, $8, $9, 1;
    print $4, $5, $6, $7, $8, $9, 2;
}

