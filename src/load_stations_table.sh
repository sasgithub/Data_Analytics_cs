#!/bin/bash
# This script loads station data into the stations table.
# It uses the `sqlite3` command to execute SQL commands.
# It assumes that the database file is located at `./stations.db`.
# It also assumes that the names of the data files in S3 is in the file files.

# The script creates the stations table if it doesn't exist, and then loads the data from the CSV files
# it extracts from zip files in S3.
# It also creates an index on the station_id column for faster queries.

# Constants
STATION_FIELDS="station_id, name, short_name, lat, long, dbcap, online_date"
RIDES_FIELDS="ride_id, bike_type, start_time, end_time, start_station_id, end_station_id, user_type, gender, birth_year"
DB=/home/sas/classes/Google/data-analytics/data/caseStudy.db
declare -a new_columns
file="/home/sas/classes/Google/data-analytics/data/stfiles"


read files < $file
for i in $files
do
  aws s3 cp s3://divvy-tripdata/$i - --no-sign-request --quiet \
    2>/dev/null   | bsdtar -x -f - ${i%%zip}csv
  if [[ $? -ne 0 ]]; then
    echo "Error extracting $i"
    exit 1
  fi
  # open the csv file for reading
  # and read the first line to get the column names
  # and convert them to lowercase
  # and replace spaces and commas with underscores
  exec 3< "${i%%zip}csv"
  read -r RAW <&3
  columns=$( tr ' ,' '_\n' <<< "$RAW")
  columns=${columns,,}
  if [[ "$i" =~ "*trip.*" ]]
  then
    # Trip data
    declare -a new_columns
    for column in $columns
    do
      case column in 
        ride_id|trip_id)
          new_column+="ride_id"
          ;;
        bike_type)
          new_column+="bike_type"
          ;;
        start_time|started_at)
          new_column+="start_time"
          ;;
        end_time|ended_at)
            new_column+=("end_time")
            ;;
        start_station_id|from_station_id)
            new_column+=("start_station_id")
            ;;
        end_station_id|to_station_id)
            new_column+=("end_station_id")
            ;;  
        user_type|usertype|member_casual)
            new_column+=("user_type")
            ;;  
        gender)
            new_column+=("gender")
            ;;
        birth_year|birthday)
            new_column+=("birth_year")
            ;;
        *)
            new_column+=("skip")
            ;;
        esac
    done

  else
    # Station data
    new_columns=''
    for column in $columns
    do
      case "$column" in
        station_id|id)
            new_columns+=("skip")
            ;;
        name|station_name)
            new_columns+=("name")
            ;;
        short_name)
            new_columns+=("short_name")
            ;;
        lat|latitude)
            new_columns+=("lat")
            ;;
        long|lng|longitude)
            new_columns+=("long")
            ;;
        dbcap|dpcapacity|total_docks)
            new_columns+=("dbcap")
            ;;
        online_date|date_installed)
            new_columns+=("online_date")
            ;;
        *)
            new_columns+=("skip")
            ;;
      esac

    done
    # Start SQLite with a transaction
    exec 4> >(sqlite3 "$DB")
    echo "BEGIN TRANSACTION;" >&4
    while IFS=',' read -r ${new_columns[*]} <&3
    do
	    echo "INSERT or IGNORE INTO stations (name, short_name, lat, long, dbcap, online_date) VALUES ('$name', '$short_name', '$lat', '$long', '$dbcap', '$online_date');" >&4	    
    done
    echo "COMMIT;" >&4
    exec 4>&-

  fi
done
  
