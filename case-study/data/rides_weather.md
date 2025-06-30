### Creation

REATE VIEW rides_weather AS
SELECT
  w.epoch                          AS epoch,        -- seconds since 1970‑01‑01 UTC
  r.user_type,
  COALESCE(r.rides, 0)             AS rides,        -- 0 if no trips that hour
  w.temp,
  w.dwpt,
  w.rhum,
  w.prcp,
  w.wdir,
  w.wspd,
  w.coco
FROM hourly_weather AS w
LEFT JOIN rides_per_hour AS r
       ON r.epoch = w.epoch

