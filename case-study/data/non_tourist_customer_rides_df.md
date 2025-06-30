## Provenance for non_tourist_customer_rides_df

### Data Origin

** Source Table:**
rides table in SQLite database 

### Query Details

Query selects:

- ride_id
- start_time
- end_time
- start_station_id
- end_station_id
- bike_type

With these filters:

-  user_type = 1
  -  Meaning: customer (casual rider)
-  start_station_id and end_station_id both in your non-tourist stations list (station_ids_sql)
-  start_time >= '2023-01-01'
  -  Meaning: rides starting on or after Jan 1, 2023


### How this fits into the flow

This dataset forms the foundational rides subset from which many other frames were derived:

-  non_loop_rides_df

**List others**

** Full Query Text **

```r
rides_query <- sprintf(" 
   SELECT
     ride_id,
     start_time,
     end_time,
     start_station_id,
     end_station_id,
     bike_type
   FROM rides
   WHERE user_type = 1
     AND start_station_id IN (%s)
     AND end_station_id IN (%s)
     AND start_time >= strftime('%%s', '2023-01-01')
", station_ids_sql, station_ids_sql)

non_tourist_customer_rides_df <- dbGetQuery(con, ride_query)
``` 

