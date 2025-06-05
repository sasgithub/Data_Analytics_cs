CREATE TABLE stations (
  station_id  INTEGER   PRIMARY KEY,
  name        TEXT      NOT NULL,
  short_name TEXT,
  lat    REAL      NOT NULL  CHECK(lat BETWEEN -90 AND 90),
  long   REAL      NOT NULL  CHECK(long BETWEEN -180 AND 180),
  dbcap	       INTEGER,
  online_date TEXT
);
CREATE UNIQUE INDEX uniq_vector ON stations(name,lat, long);
CREATE INDEX idx_name on stations(name);
CREATE TABLE rides (
  ride_id          INTEGER     PRIMARY KEY,
  bike_type     INTEGER,
  bike_id         INTEGER,
  start_time        INTEGER     NOT NULL,
  end_time          INTEGER     NOT NULL,
  start_station_id  INTEGER      NOT NULL,
  end_station_id    INTEGER      NOT NULL,
  user_type       BOOLEAN    CHECK (user_type IN (0, 1) OR user_type IS NULL),
  gender         BOOLEAN      CHECK (gender IN (0, 1) OR gender IS NULL),
  birth_year        INTEGER	
);
CREATE VIEW rider_readable AS
SELECT
  ride_id,
  bike_type,
  bike_id,
  datetime(start_time, 'unixepoch') AS start_time,
  datetime(end_time, 'unixepoch') AS end_time,
  start_station_id,
  end_station_id,
  CASE user_type
    WHEN 0 THEN 'subscriber'
    WHEN 1 THEN 'customer'
    ELSE 'unknown'
  END AS user_type,
  CASE gender
    WHEN 0 THEN 'male'
    WHEN 1 THEN 'female'
    ELSE 'unknown'
  END AS gender,
  birth_year
FROM rides
/* rider_readable(ride_id,bike_type,bike_id,start_time,end_time,start_station_id,end_station_id,user_type,gender,birth_year) */;
CREATE TABLE hourly_weather (
     epoch INTEGER PRIMARY KEY,
     temp REAL,
     dwpt REAL,
     rhum INTEGER,
     prcp REAL,
     wdir INTEGER,
     wspd REAL,
     coco INTEGER
  );
CREATE VIEW rides_per_hour AS
SELECT
  CAST((start_time / 3600) * 3600 AS INTEGER) AS epoch,   -- start of the hour in seconds
  CASE user_type
       WHEN 0 THEN 'subscriber'
       WHEN 1 THEN 'customer'
       ELSE 'unknown'
  END AS user_type,
  COUNT(*) AS rides
FROM rides
GROUP BY epoch, user_type
/* rides_per_hour(epoch,user_type,rides) */;
CREATE VIEW rides_weather AS
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
/* rides_weather(epoch,user_type,rides,"temp",dwpt,rhum,prcp,wdir,wspd,coco) */;
CREATE TABLE rides_per_hour_tbl(
  epoch INT,
  user_type,
  rides
);
CREATE INDEX idx_rides_per_hour_epoch
  ON rides_per_hour_tbl(epoch, user_type);
CREATE INDEX epoch_idx on hourly_weather(epoch);
CREATE INDEX start_time_idx on rides(start_time);
