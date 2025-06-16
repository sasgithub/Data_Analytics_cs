# src Directory

This directory contains scripts and SQL files for processing, analyzing, and loading data for the Data Analytics case study project. Below is a brief overview of each file and its purpose.

---

## File Overview

- **.gitignore**  
  Specifies files that should be ignored by Git version control in this directory.

- **asymmetry.sql**  
  SQL script to calculate directional asymmetry in ride data between station pairs. It analyzes if more users travel in one direction than the other and computes an asymmetry ratio, filtering for high-volume routes only.

- **dist-diff.sh**  
  Bash script that calculates the distance between two pairs of GPS coordinates using the Haversine formula (great-circle distance). Useful for geospatial analysis.

- **import_stations.sh**  
  Bash script to load station data into the `stations` table of an SQLite database. It parses files, matches and maps columns, and inserts records, handling different naming conventions.

- **load_rides.sh**  
  Bash script for loading ride data into the `rides` table of the SQLite database. It handles extracting and transforming CSV files, mapping columns, converting dates to epoch, and matching station IDs, including error handling for unmatched data.

- **load_stations_table.sh**  
  Bash script to read station CSV files and insert their contents into the `stations` table in SQLite. It processes column names and performs insertions within a transaction.

- **load_weather.R**  
  R script that loads weather data from a CSV file, processes and cleans it, combines date and hour into epoch time, and writes the result into an SQLite table called `hourly_weather`.

- **speed_dating.awk**  
  AWK script for processing CSV files of ride data. It extracts and prints the earliest and latest dates found in the data.

- **speed_dating.go**  
  Go program that reads a rides CSV file, parses start and stop dates, and prints the earliest and latest ride dates in the data.

- **speed_dating.py**  
  Python script to process a rides CSV file and print the earliest and latest dates from the data, parsing date fields and finding min/max.

- **speed_dating2.py**  
  Python script using pandas to read a rides CSV file and print the earliest and latest dates in the dataset, focusing on the date columns.

- **station_pairs.sql**
  SQL script is to analyze and summarize the most frequent origin-destination pairs of stations, based on ride data. 

- **unUUIDv1.py**
  Python scrit that extracts and displays information from a version 1 UUID (Universally Unique Identifier v1). 

---

