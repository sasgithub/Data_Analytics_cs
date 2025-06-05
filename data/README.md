# Data Overview

This project uses multiple datasets related to Divvy bike share rides and historical weather in Chicago. Due to size constraints and licensing, raw data is not stored in this repository. This document explains how to acquire, clean, and load the data.

## Stations Data

**Sources**
- [Divvy S3 Archive](https://divvy-tripdata.s3.amazonaws.com/index.html)
  -  Divvy_Stations_Trips_2013.zip
 
- [City of Chicago Data Portal](https://data.cityofchicago.org/Transportation/Divvy-Bicycle-Stations/bbyy-e7gq/data_preview)
  -  Divvy_Bicycle_Stations_20250501.csv

## Processing Steps



## Divvy Rides Data

**Sources:**

- [Divvy S3 Archive](https://divvy-tripdata.s3.amazonaws.com/index.html)
  - 202306-divvy-tripdata.zip through 202306-divvy-tripdata.zip trip data
  
- [City of Chicago Data Portal](https://data.cityofchicago.org/Transportation/Divvy-Trips/fg6s-gzvg/about_data)
  - `Divvy_Trips_20250501.csv`
Although the name would imply it has data up to 2025 the data ends 09/30/2019

### Processing Steps



Due to inconsistencies across formats and years, rides and stations data are imported and cleaned using a multi-step process:

1. **Shell Script** [load_rides.sh] (../src/load_rides.sh) performs:
   - Download of zip files from S3
   - Validation and filtering of raw CSVs
   - Normalization of station names and coordinates
   - Data transformation before loading

2. **SQLite Schema**:
   - Stations and rides are loaded into a normalized schema (see [schema.sql] (../schema/schema.sql))
   - Further cleaning (e.g., deduplication, null handling, date normalization) is done directly in SQLite

3. **Data Matching**:
   - During import, station names and GPS coordinates are matched against the `stations` table
   - Station IDs are resolved at load time

4. **Optimizations**:
   - Transactions are batched (10,000 rows at a time) for large file imports
   - Indexing on composite fields helps prevent duplicates

---

## Weather Data

**Source:** [Meteostat Bulk Hourly Data](https://bulk.meteostat.net/v2/hourly/72534.csv.gz)  
**Station:** Chicago Midway Airport (WMO ID: 72534)
 The weather data start in 1973 and runs to a date close to when it was downloaded (in my case it was the day before it was downloaded)  One anaomaly I found with the data is that it appears to switch to only being every six hours at 2025-05-11 18:00 but since we'll only using data up to 2025-04-30 that won't be an issue.  Times before 2013-06-27 were manually deleted prior to import.

### Script

Use the R script, [load_weather.R] (../src/load_weather.R) to:

- Load the hourly weather data CSV
- Clean and normalize the data
- Write the cleaned version to a format usable in analysis

CSV files provided through the Meteostat bulk data interface use commas as separators. Each file provides the following columns:

|Order|Parameter|Description|Type|
|-:|:--|:-----------------------|--:|
|1|date|The date string (format: YYYY-MM-DD)|String|
|2|hour|The hour (UTC)|Integer|
|3|temp|The air temperature in °C|Float|
|4|dwpt|The dew point in °C|Float|
|5|rhum|The relative humidity in percent (%)|Integer|
|6|prcp|The one hour precipitation total in mm|Float|
|7|snow|The snow depth in mm|Integer|
|8|wdir|The wind direction in degrees (°)|Integer|
|9|wspd|The average wind speed in km/h|Float|
|10|wpgt|The peak wind gust in km/h|Float|
|11|pres|The sea-level air pressure in hPa|Float|
|12|tsun|The one hour sunshine total in minutes (m)|Integer|
|13|coco|The weather condition code|Integer|

More information on the data formats and weather condition codes (COCO) is available here and included below;.
Weather conditions are indicated by an integer value between 1 and 27 according to this list:
|Code|Weather Condition|
|-:|:----:|
|1|Clear|
|2|Fair|
|3|Cloudy|
|4|Overcast|
|5|Fog|
|6|Freezing Fog|
|7|Light Rain|
|8|Rain|
|9|Heavy Rain|
|10|Freezing Rain|
|11|Heavy Freezing Rain|
|12|Sleet|
|13|Heavy Sleet|
|14|Light Snowfall|
|15|Snowfall|
|16|Heavy Snowfall|
|17|Rain Shower|
|18|Heavy Rain Shower|
|19|Sleet Shower|
|20|Heavy Sleet Shower|
|21|Snow Shower|
|22|Heavy Snow Shower|
|23|Lightning|
|24|Hail|
|25|Thunderstorm|
|26|Heavy Thunderstorm|
|27|Storm|

The data from Midway contains no entries for snow, peak wind gust or total sunsine (minutes).  So we can drop those columns.  Also most peop

---

## Notes

- Only cleaned and derived datasets are used in visualizations.
- See `/views/` for SQL views used in analysis (e.g., `rider_readable`).







## Download Instructions

1. Visit the [Divvy S3 Trip Data Archive](https://divvy-tripdata.s3.amazonaws.com/index.html) Download files from `202306-divvy-tripdata.csv` to `202504-divvy-tripdata.csv` and place them in `data/`.

## Cleaning Steps


