#!/bin/bash
#
# Author: sas
# Purpose: This script loads ride data into the rides table.
#          It uses the `sqlite3` command to execute SQL commands.
#          It assumes that the database file is located at `caseStudy.db`.
#          It also assumes that the names of the data files in S3 is in the file files.
#          It extracts the csv file from the zip file extracted from the stream downloaded
#          from S3 (thus avoiding storing the zip file).
#
# Notes: This script uses bsdtar so if it's not already installed ...

# constants
RIDES_FIELDS="ride_id, bike_type, start_time, end_time, start_station_id, end_station_id, user_type, gender, birth_year"
# gender: 0 = male, 1 = female, NULL = unknown
# user_type: 0 = customer, 1 = member, NULL = unknown
DB=/home/sas/classes/Google/data-analytics/data/caseStudy.db
declare -a new_columns
file="/home/sas/classes/Google/data-analytics/data/rideFiles"

#Functions

sql_val() {
  [[ -z "$1" || "$1" == "NULL" ]] && echo "NULL" || echo "'$1'"
}

isInt() {
  if [[ $1 == ?(-)+([0-9]) ]]
  then 
    return 0
  else
    return 1
  fi
}

map_gender() {
#echo "map_gender($1)" >&2	
  case "${1,,}" in
    male) echo 0 ;;
    female) echo 1 ;;
    *) echo "NULL" ;;
  esac
}

map_userType() {
#echo "map_userType($1)" >&2
  case "${1,,}" in
    customer) echo 1;;
    subscriber) echo 0 ;;
    casual) echo 1 ;;
    member) echo 0 ;;
    *) echo "NULL" ;;
  esac    
}

dateToEpoch() {
#echo "dateToEpoch($1)">&2	
  epoch=$(date --date="$1" "+%s")
#echo "epoch=$epoch">&2	
  if isInt $epoch
  then
    echo $epoch	  
  else	    
    echo "$epoch is not an int, date=$1" >> date.err
    echo "NULL"
  fi
}

find_station_id() {
  local name="$1"
  local lat="$2"
  local lon="$3"
  local epsilon=0.001
  local sid
  local log_file="find_station_id.err"
#echo "in find_station_id" >&2
  # Initial query (tight bounding box)
  sid=$(sqlite3 "$DB" <<EOF
SELECT station_id
FROM stations
WHERE name like '$name%'
  AND lat BETWEEN ($lat - $epsilon) AND ($lat + $epsilon)
  AND long BETWEEN ($lon - $epsilon) AND ($lon + $epsilon)
ORDER BY ((lat - $lat)*(lat - $lat) + (long - $lon)*(long - $lon)) ASC,
         station_id ASC
LIMIT 1;
EOF
)
#echo "on to stripped" >&2
  # If no result, retry without anything in parentheses
  if [[ -z "$sid" ]]; then
    local stripped_name
    stripped_name=$(sed 's/([^)]*)//g; s/  */ /g; s/^ *//; s/ *$//' <<< "$name")

    sid=$(sqlite3 "$DB" <<EOF
SELECT station_id
FROM stations
WHERE name like '$stripped_name%'
  AND lat BETWEEN ($lat - $epsilon) AND ($lat + $epsilon)
  AND long BETWEEN ($lon - $epsilon) AND ($lon + $epsilon)
ORDER BY ((lat - $lat)*(lat - $lat) + (long - $lon)*(long - $lon)) ASC,
         station_id ASC
LIMIT 1;
EOF
)
  fi

  if [[ -z "$sid" ]]; then
#echo "in closest" >&2	  
    # Log closest match regardless of match success
    local closest
    closest=$(sqlite3 "$DB" <<EOF
SELECT station_id || ' (' || name || ' @ ' || lat || ',' || long || ')'
FROM stations
WHERE lat BETWEEN ($lat - 0.01) AND ($lat + 0.01)
  AND long BETWEEN ($long - 0.01) AND ($long + 0.01)
ORDER BY ((lat - $lat)*(lat - $lat) + (long - $lon)*(long - $lon)) ASC, station_id ASC
LIMIT 1;
EOF
)
    echo "Input: $name @ $lat,$long -> Match: ${sid:-NONE}, Closest: $closest" >> "$log_file"
  fi

  echo "$sid"
#echo "leaving closest" >&2 
}

name_only_station_match() {
  local station=$1
  local sid=''
  local stripped_name
#echo "in name_only_station_match"  >&2
    stripped_name=$(sed 's/([^)]*)//g; s/  */ /g; s/^ *//; s/ *$//' <<< "$station")
    sid=$(sqlite3 "$DB" <<EOF
SELECT station_id
FROM stations
WHERE name like '$stripped_name%'
ORDER BY station_id ASC
LIMIT 1;
EOF
)
  if [[ -z "$sid" ]] 
  then
    echo "$station = no match found " >> discards
  else
    echo $sid
  fi      
#echo "leaving name_only_station_match" >&2
}

# main
cnt=0
interval=10000
while read files
do
  for i in $files
  do
    aws s3 cp s3://divvy-tripdata/$i - --no-sign-request --quiet \
      2>/dev/null   | bsdtar -x -f - ${i%%zip}csv
    if [[ $? -ne 0 ]]; then
      echo "Error extracting $i"
      exit 1
    fi
  echo "${i%%zip}csv"
    # open the csv file for reading
    # and read the first line to get the column names
    # and convert them to lowercase
    # and replace spaces and commas with underscores
    dos2unix "${i%%zip}csv"
    sed -i 's/"//g' "${i%%zip}csv"
    exec 3< "${i%%zip}csv"
    read -r RAW <&3
    columns=$( tr ' ,' '_\n' <<< "$RAW")
    columns=${columns,,}
    declare -a new_columns
    new_columns=()
    for column in $columns
    do
  #echo "column=$column"
      case "$column" in
        bike_type|rideable_type)
  	new_columns+=("bike_type")
          ;;
        bike_id|bikeid)
          new_columns+=("bike_id")
          ;;	
        start_time|started_at|starttime)
  	new_columns+=("start_time")
          ;;
        end_time|ended_at|stop_time|stoptime)
          new_columns+=("end_time")
          ;;
        user_type|usertype|member_casual)
          new_columns+=("user_type")
          ;;
        gender)
          new_columns+=("gender")
          ;;
        birth_year|birthday|birthyear)
          new_columns+=("birth_year")
          ;;
        start_station_name|from_station_name)
          new_columns+=("start_station_name")
          ;;
        end_station_name|to_station_name)
          new_columns+=("end_station_name")
          ;;	      
        start_lat|from_latitude)
          new_columns+=("start_lat")
          ;;	  
        start_lng|from_longitude)
          new_columns+=("start_long")
          ;;
        end_lat|to_latitude) 
          new_columns+=("end_lat")
          ;;
        end_lng|to_longitude)
          new_columns+=("end_long")
          ;;
        *)
  #echo "unknown column: $column"      
          new_columns+=("skip")
          ;;
      esac
    done
  #echo 'new_columns[*] =' "${new_columns[*]}" 
    # Start SQLite with a transaction
    exec 4> >(sqlite3 "$DB")
    echo "BEGIN TRANSACTION;" >&4
    while IFS=',' read -r ${new_columns[*]} <&3
    do 
      if [[ -n "$start_time" && -n "$end_time" ]]
      then
        start_time=$(dateToEpoch "$start_time")
        end_time=$(dateToEpoch "$end_time")
      else # if we only have one what good is it?
        start_time=''
        end_time=''
      fi
      gender=$(map_gender "$gender")
  #echo "gender=$gender"    
      user_type=$(map_userType "$user_type")    
      if [[ "$start_lat" && "$start_long" && "$end_lat" && "$end_long" ]] #none empty
      then	    
        start_station=$(find_station_id "$start_station_name" $start_lat $start_long)
        end_station=$(find_station_id "$end_station_name" $end_lat $end_long)
        if [[ "$start_station" && "$end_station" ]]
        then
          start_station_id="$start_station"
          end_station_id="$end_station"
  #echo "INSERT INTO rides (bike_type, start_time, end_time, start_station_id, end_station_id, user_type, gender, birth_year) VALUES ('$bike_type', '$start_time', '$end_time', '$start_station_id', '$end_station_id', $(sql_val "$user_type"), '$gender', '$birth_year');"
          echo "INSERT INTO rides (bike_type, bike_id, start_time, end_time, start_station_id, end_station_id, user_type, gender, birth_year) VALUES ('$bike_type', '$bike_id', '$start_time', '$end_time', '$start_station_id', '$end_station_id', $(sql_val "$user_type"), $(sql_val "$gender"), '$birth_year');" >&4
        else
  	: noop  # these will be logged for later processing
        fi	
      else
         # inadequate GPS, name only match
         start_station_id=''
         end_station_id=''
         start_station_id=$(name_only_station_match "$start_station_name")
         end_station_id=$(name_only_station_match "$end_station_name")
         if [[ "$start_station_id" && "$end_station_id" ]]
         then
  	       echo "INSERT INTO rides (bike_type, bike_id, start_time, end_time, start_station_id, end_station_id, user_type, gender, birth_year) VALUES ('$bike_type', '$bike_id', '$start_time', '$end_time', '$start_station_id', '$end_station_id', $(sql_val "$user_type"), $(sql_val "$gender"), '$birth_year');" >&4
         else
           # discards
  	 echo "$bike_type, $start_time, $end_time, $start_station_id, $end_station_id, $user_type, $gender, $birth_year" >> discards
         fi	       
      fi
      ((cnt++))
      if (( cnt % interval == 0 ))
      then
        echo -ne "Imported $cnt records...\r"
        echo "COMMIT;" >&4
        sleep 1
        echo "BEGIN TRANSACTION;" >&4
      fi      
    done  
    echo "COMMIT;" >&4
    exec 4>&-
  
  done
done < $file

