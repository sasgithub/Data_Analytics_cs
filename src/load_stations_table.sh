#!/bin/bash
# This script loads station data into the stations table.
# It uses the `sqlite3` command to execute SQL commands.


# Constants
STATION_FIELDS="station_id, name, short_name, lat, long, dbcap, online_date"
RIDES_FIELDS="ride_id, bike_type, start_time, end_time, start_station_id, end_station_id, user_type, gender, birth_year"
DB=/home/sas/classes/Google/data-analytics/data/caseStudy.db
declare -a new_columns
file="/home/sas/classes/Google/data-analytics/data/stfiles"


read files < $file
for i in $files
do
  # open the csv file for reading
  # and read the first line to get the column names
  # and convert them to lowercase
  # and replace spaces and commas with underscores
  exec 3< "${i}"
  read -r RAW <&3
  columns=$( tr ' ,' '_\n' <<< "$RAW")
  columns=${columns,,}

  if [[ $i =~ [Ss]tation ]]
  then
    # Station data
    decalre -a new_columns
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

  else
	echo "station file not found"  
  fi

done
  
