```r
stations_df <- dbGetQuery(con, "SELECT station_id, name, latitude AS lat, longitude AS long FROM stations")
```
