#### `loop_rides_non_tourist`

**Type:** R Data Frame

**Description**

This data frame was created by filtering `non_tourist_customer_rides_df` to include only rides that started and ended at the same station.  

Specifically, records were retained where:

```
start_station_id == end_station_id
```

This subset isolates non-tourist customer rides that form a complete loop, supporting analysis of short trips returning to the origin station.

