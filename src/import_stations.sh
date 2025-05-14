#!/bin/bash
#
# Author: sas
# Purpose: This script loads station data into the stations table.
#          It uses the `sqlite3` command to execute SQL commands.
#          It assumes that the database file is located at `./stations.db` and the statioins
#          table exist.
#

# Constants
STATION_FIELDS="station_id, name, short_name, lat, long, dbcap, online_date"
DB=caseStudy.db
STATION_FILES="stfiles"
declare -a new_columns

read files < $STATION_FILES
for i in $files
do
  exec 3< "$i"
  read -r RAW <&3
  columns=$( tr ' ,' '_\n' <<< "$RAW")
  columns=${columns,,}

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

    # Start SQLite with a transaction
    exec 4> >(sqlite3 "$DB")
    echo "BEGIN TRANSACTION;" >&4
    while IFS=',' read -r ${new_columns[*]} <&3
    do
      echo "INSERT or IGNORE INTO stations (name, short_name, lat, long, dbcap, online_date) VALUES ('$name', '$short_name', '$lat', '$long', '$dbcap', '$online_date');" >&4	    
    done
    echo "COMMIT;" >&4
    exec 4>&-
  done  
done

