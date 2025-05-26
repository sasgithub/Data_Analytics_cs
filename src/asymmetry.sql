.headers on
WITH ride_directions AS (
  SELECT
    start_station_id,
    end_station_id,
    user_type
  FROM rides
  WHERE start_station_id != end_station_id
),
normalized_pairs AS (
  SELECT
    CASE WHEN start_station_id < end_station_id THEN start_station_id ELSE end_station_id END AS station_low,
    CASE WHEN start_station_id > end_station_id THEN start_station_id ELSE end_station_id END AS station_high,
    user_type,
    COUNT(*) FILTER (WHERE start_station_id < end_station_id) AS count_ab,
    COUNT(*) FILTER (WHERE start_station_id > end_station_id) AS count_ba
  FROM ride_directions
  GROUP BY station_low, station_high, user_type
),
asymmetry_score AS (
  SELECT
    station_low AS station_a,
    station_high AS station_b,
    user_type,
    COALESCE(count_ab, 0) AS count_ab,
    COALESCE(count_ba, 0) AS count_ba,
    ABS(COALESCE(count_ab, 0) - COALESCE(count_ba, 0)) AS diff,
    (COALESCE(count_ab, 0) + COALESCE(count_ba, 0)) AS total,
    ROUND(1.0 * ABS(COALESCE(count_ab, 0) - COALESCE(count_ba, 0)) / NULLIF((COALESCE(count_ab, 0) + COALESCE(count_ba, 0)), 0), 2) AS asymmetry_ratio
  FROM normalized_pairs
  WHERE (COALESCE(count_ab, 0) + COALESCE(count_ba, 0)) >= 2000  -- Filter out low-volume routes
)
SELECT
  CASE user_type
    WHEN 0 THEN 'Customer'
    WHEN 1 THEN 'Subscriber'
    ELSE 'Unknown'
  END AS user_type_label,
  s1.name AS station_a_name,
  s2.name AS station_b_name,
  count_ab,
  count_ba,
  diff,
  total,
  asymmetry_ratio
FROM asymmetry_score
JOIN stations s1 ON s1.station_id = station_a
JOIN stations s2 ON s2.station_id = station_b
ORDER BY user_type_label, asymmetry_ratio DESC, total DESC;

