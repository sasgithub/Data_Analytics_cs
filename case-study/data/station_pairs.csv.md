### `station_pairs.csv`

**Description:**  
Top 5,000 most frequent origin-destination station pairs, with ride counts split by user type.

**Provenance Details:**

- **Source Tables:**  
  - `rides` table (trip records)  
  - `stations` table (station metadata)

- **Purpose:**  
  To analyze directional flows between stations, including the relative share of subscribers and customers, while collapsing bidirectional pairs into a single record.

- **Query Details:**

  ```sql
  SELECT 
    s1.name AS station_a,
    s1.lat AS lat_a,
    s1.long AS lon_a,
    s2.name AS station_b,
    s2.lat AS lat_b,
    s2.long AS lon_b,
    COUNT(*) AS ride_count,
    SUM(CASE WHEN r.user_type = 0 THEN 1 ELSE 0 END) AS subscriber_count,
    SUM(CASE WHEN r.user_type = 1 THEN 1 ELSE 0 END) AS customer_count
  FROM rides r
  JOIN stations s1 ON r.start_station_id = s1.station_id
  JOIN stations s2 ON r.end_station_id = s2.station_id
  WHERE r.start_station_id != r.end_station_id
  GROUP BY
    CASE 
      WHEN r.start_station_id < r.end_station_id THEN r.start_station_id
      ELSE r.end_station_id
    END,
    CASE 
      WHEN r.start_station_id < r.end_station_id THEN r.end_station_id
      ELSE r.start_station_id
    END
  ORDER BY ride_count DESC
  LIMIT 5000;
```

**Notes:**

  -   This query ensures each pair is counted only once regardless of trip direction by always ordering station IDs (start_station_id and end_station_id).
  -   Rides where start and end stations are the same were excluded (WHERE r.start_station_id != r.end_station_id).
  -   Output includes lat/long for both stations to support mapping.

Conveniently available as [station_pairs.csv](station_pairs.csv) for your importing pleasure.

