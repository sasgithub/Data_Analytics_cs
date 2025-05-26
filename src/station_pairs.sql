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

