Work Log

I started off by looking at
<https://divvy-tripdata.s3.amazonaws.com/index.html>.

A lot of data there, at least to store on my laptop. I started off just
downloading and examining the first file. An unzip -l let me see it's
just a CSV file and what I assume is the resource fork. I'm using Linux
so I don't care about the resource fork so I extracted it with unzip.

Examining the file I see the first line list the field names, they are
adequately descriptive which is good so I don't see anything else that
describes the data like a data dictionary or any file layout
documentation.

Looking at the data I see a good chunk of it's is the repeated station
names (start_station_name and end_station_name). Let's see how many
there are;

```bash
$ tail +2 202004-divvy-tripdata.csv | cut -f6 -d, | sort -u | wc -l
```
```text
602
```

So 602 unique station IDs

Let check the unique station names while were at it.

```bash
$ tail +2 202004-divvy-tripdata.csv | cut -f5 -d, | sort -u | wc -l
```
```text
602
```
Good 602 for each. Looks like there is are GPS coordinates (start_lat,
start_lng, end_lat, end_lng) which appear to match up perfectly with the
start and end station (what? Every start_station_id always has the same
start lat/long and likewise for the end_station_id and the end
lat/long).

My current plan is to dump all these tripdata.csv files into a database
with a rides table

```SQL
CREATE TABLE rides (
 ride_id CHAR(16) PRIMARY KEY,
 rideable_type INTEGER NOT NULL,
 start_time DATETIME NOT NULL,
 end_time DATETIME NOT NULL,
 start_station_id INTEGER NOT NULL,
 end_station_id INTEGER NOT NULL,
 member_type BOOLEAN NOT NULL
);
```

and a stations table

```SQL
CREATE TABLE stations (*
 station_id INTEGER PRIMARY KEY,*
 name TEXT NOT NULL,*
 latitude REAL NOT NULL CHECK(latitude BETWEEN -90 AND 90),*
 longitude REAL NOT NULL CHECK(longitude BETWEEN -180 AND 180)*
);
```

I'm still up in the air about the not nulls as I know there are rows
missing data, but I think some of it may be when the ride starts and
stops at the same station. So I either have to fix the nulls before
populating the table or write the code that inserts the data to fix
them. More investigation is necessary.

Let's grab a second file from the tripdata series and see if it's
consistent with the first, but let's skip saving the zip file since we
really only need the csv

aws s3 cp s3://divvy-tripdata/202005-divvy-tripdata.zip -
\--no-sign-request \--quiet 2\>/dev/null \| bsdtar -x -f --
202005-divvy-tripdata.csv

Well the good news is it appears to have the same format.

Now let's take a look at one of the the Stations_Trips series, namely
Divvy_Stations_Trips_2013.zip

```bash
aws s3 cp s3://divvy-tripdata/Divvy_Stations_Trips_2013.zip . --no-sign-request --quiet 2>/dev/null

$ unzip -l Divvy_Stations_Trips_2013.zip 
```
```text
Archive:  Divvy_Stations_Trips_2013.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
    20111  2014-02-21 11:52   Divvy_Stations_Trips_2013/Divvy_Stations_2013.csv
    16010  2014-02-19 14:27   Divvy_Stations_Trips_2013/Divvy_Stations_2013.shp.zip
 93389990  2014-02-19 14:27   Divvy_Stations_Trips_2013/Divvy_Trips_2013.csv
     1321  2014-02-21 11:57   Divvy_Stations_Trips_2013/README.txt
---------                     -------
 93427432                     4 files
 ```

Not the same at all, let's have a look at the [README.txt](../data/Divvy_Stations_Trips_2013_README.txt).

So the rides (now called trips) table format is a little different and
there is some additional data. There is now a separate station table,
but for some reason both the station name and station id are still in
with the trips, at least the lat/long are only in the station table. The
additional data in the trips table is bike_id, it seems to have replaced
the rideable_type but there is no bikes table to find that out :-( Also
the ride_id, now trip_id, has changed from a 16 digit hex number to an
integer. The member_type is now called usertype and the values have
changed from (member, casual) to (Subscriber, Customer) still only two
values though. There is a new field called tripduration (I wonder if
it's just end time - start time, redundant data to store). Two other new
fields, gender and birthday, but it claims they are only populated for
Subscribers.

In the station table we have

id: station id
name: station name
latitude: station latitude
longitude: station longitude
dpcapacity: number of total docks at each station as of 2/7/2014
online date: date the station went live in the system

So dpcapacity and online date are new (or maybe we should say old since
it's from 2014)

Now for this Divvy_Stations_Trips_2013/Divvy_Stations_2013.shp.zip file

```bash
unzip -l Divvy_Stations_2013.shp.zip
```
```text
Archive:  Divvy_Stations_2013.shp.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2014-02-08 19:07   Divvy_Stations_2013.shp/
    95894  2014-02-06 13:09   Divvy_Stations_2013.shp/Divvy_Stations_2013.dbf
      145  2014-02-06 13:09   Divvy_Stations_2013.shp/Divvy_Stations_2013.prj
     3196  2014-02-06 13:09   Divvy_Stations_2013.shp/Divvy_Stations_2013.sbn
      340  2014-02-06 13:09   Divvy_Stations_2013.shp/Divvy_Stations_2013.sbx
     8500  2014-02-06 13:09   Divvy_Stations_2013.shp/Divvy_Stations_2013.shp
     2500  2014-02-06 13:09   Divvy_Stations_2013.shp/Divvy_Stations_2013.shx
---------                     -------
   110575                     7 files
```   

I don't really recognize those file extensions let's see what the Linux
file command says;

```bash
$ file *
```
```text
Divvy_Stations_2013.dbf: FoxBase+/dBase III DBF, 300 records * 319, update-date 114-2-6, codepage ID=0x57, at offset 193 1st record "        5.000000State St & Harrison St                                                                                         "
Divvy_Stations_2013.prj: ASCII text, with no line terminators
Divvy_Stations_2013.sbn: ESRI Shapefile version 738263040 length 1598
Divvy_Stations_2013.sbx: ESRI Shapefile version 738263040 length 170
Divvy_Stations_2013.shp: ESRI Shapefile version 1000 length 4250 type Point
Divvy_Stations_2013.shx: ESRI Shapefile version 1000 length 1250 type Point
```

Was someone really using database software from the late 80s in 2013?
(on a total tangent I re-watched Office Space the other day and noticed
**Understanding dBASE III Plus** by Alan Simpson (Sybex Computer Books,
1st Ed. Jan 1986) on the shelf behind Peter.)

Looks like **file** didn't recognize the .prj file, it's small let's take a
look at it;

```bash
$ ls -l Divvy_Stations_2013.prj 
```
```text
-rw-rw-r-- 1 sas sas 145 Feb  6  2014 Divvy_Stations_2013.prj
```

It's small so ...

```bash
$ cat Divvy_Stations_2013.prj
```
```text 
GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",SPHEROID["WGS_1984",6378137.0,298.257223563]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]]
```

Turns out it's a

> "... Well-Known Text (WKT) definition of the dataset's coordinate
> reference system. In this case it tells you that everything is in plain
> latitude/longitude on the WGS 84 datum..."
> 
> -- ChatGPT (OpenAI)

I dug in a little further and it's really interesting (I don't' know
much about GIS stuff) but I resisted the urge to explore it further.
However what I did not resist was the [side quest](../docs/side-quest/prj-quest.html) to fix **file** so that it would recognize .prj files.

```bash
$ file Divvy_Stations_2013.prj
```
```text 
Divvy_Stations_2013.prj: ESRI WKT projection (.prj) file
```

Another urge I couldn't resist was figuring out what those other files
were for, here's the breakdown;

Divvy_Stations_2013.dbf - essentially one table’s worth of data, rows and columns
Divvy_Stations_2013.prj  - the coordinate reference system and projection information
Divvy_Stations_2013.sbn - spatial index files used to speed up spatial queries
Divvy_Stations_2013.sbx - spatial index files used to speed up spatial queries
Divvy_Stations_2013.shp - stores the actual geometry (points, lines, or polygons)
Divvy_Stations_2013.shx - the index file, linking geometry to attributes

Turns out, strangely enough, that modern GIS tools still use the old
dBase III .dbf format when working with ERSI (Environmental Systems
Research Institute) shape files. Which means we can actually open this
stuff up and have a look at it.

[Divvy_Stations_in_QGIS.png](../images/Divvy_Stations_in_QGIS.png)

The above shows all the Divvy Stations from 2013, it's the only layer,
so not too interesting but if we right click on Divvy_Stations_2013 in
the Layers pane and select Open Attribute Table we get

[Divvy_Stations_table.png](../images/Divvy_Stations_table.png)

and there is the station data we already had, except now we get the
additional dpcapacity field.

It sure would be nice if we had a layer with Chicago city streets to go
with our layer of the stations. Looks like we should be able to get one
so a quick search turned up the Chicago Data Portal and after a few
404's I found the [Divvy Bicycle Stations Map](<https://data.cityofchicago.org/Transportation/Divvy-Bicycle-Stations-Map/bk89-9dk7>)

[2025_Divvy_Stations.png](images/2025_Divvy_Stations.png)

Turns out we can download the current Stations data in CSV format from
this site and a review of the [terms of use](https://www.chicago.gov/city/en/narr/foia/data_disclaimer.html) confirms what's required to be able to use it.

Not only that, but they also have Divvy_Trips_20250501.csv available for
download...

```bash
$ ls -hl Divvy_Trips_20250501.csv 
```
```text
-rw-rw-r-- 1 sas sas 4.8G May  1 13:28 Divvy_Trips_20250501.csv
```
That's a big'un

```bash
$ head -1 Divvy_Trips_20250501.csv
```
```text
TRIP ID,START TIME,STOP TIME,BIKE ID,TRIP DURATION,FROM STATION ID,FROM
STATION NAME,TO STATION ID,TO STATION NAME,USER TYPE,GENDER,BIRTH
YEAR,FROM LATITUDE,FROM LONGITUDE,FROM LOCATION,TO LATITUDE,TO
LONGITUDE,TO LOCATION
```

What a lovely caps-lock-a-ram-a that is. I like the new fields
(compared to Divvy_Trips_2013.csv) and their description's for brevity,
but I'm going to stick with the pervious convention of all lower case
(no need to shout).

gender 
:   Only populated for Subscribers

birth_year
:   I wonder if it's only populated for Subscribers

from_location 
:   this appears to be the from_latitude and from_longitude stuck in parentheses seperated by a space and in the reverse order and in front of that opening parenthesis is the string "POINT " , so something like "POINT (-87.745261 41.886841)"

to_location
:   this appears to be like from_location only with

to_latitude 
:   as above.

to_longitude
:   as above.

So we'll update the planned rides table

```SQL
CREATE TABLE rides (
 ride_id INTEGER PRIMARY KEY,
 bike\_type INTEGER,
 bike_id INTEGER,
 start_time INTEGER NOT NULL,
 end_time INTEGER NOT NULL,
 start_station_id INTEGER NOT NULL,
 end_station_id INTEGER NOT NULL,
 user\_type BOOLEAN CHECK (user_type IN (0, 1) OR user_type IS NULL),
 gender BOOLEAN CHECK (gender IN (0, 1) OR gender IS NULL),
 birth_year INTEGER *
);
```

Now I'm curious how far back this data goes, so let's create something
to efficiently find out before we spend any time wrangling this data. If
you listen carefully you can almost hear this big'ol 4.8GB file
whispering the word "awk"

We create the file [speed_dating.awk](../src/speed_dating.awk)

```bash
$ awk -f speed_dating.awk Divvy_Trips_20250501.csv
```
```text
Earliest: 06/27/2013
Latest:   //STOP
```

Well, I guess I forgot to skip the first line, that STOP is from "STOP
TIME".

OK fixed that;

```bash
$ awk -f ~/git/Data_Analytics_cs/src/speed_dating.awk  Divvy_Trips_20250501.csv 
```
```text
Earliest: 06/27/2013
Latest:   01/06/2020
```

That was kind of slow, around 20 seconds, so I tried a bunch of things
even tried a python version ([speed_dating.py](../src/speed_dating.py)), but nothing was really better until I tried a go version ([speed_dating.go](../src/speed_dating.go)),

```bash
$ speed_dating 
```
```text
Earliest: 06/27/2013
Latest:   01/21/2020
```

Down to 7.5 seconds. I could make it multi-threaded and it'd be even
fast, but don't fall into that trap. I'd already spent an hour to save
13 seconds. Don't waste time optimizing something your only going to use
once.

So we've got data from the middle of 2013 to the beginning of 2020,
let's go ahead and create a database and the two tables with updated
rows.

```R
CREATE TABLE stations (
 station_id INTEGER PRIMARY KEY,
 name TEXT NOT NULL,
 short_name TEXT,
 lat REAL NOT NULL CHECK(lat BETWEEN -90 AND 90),
 long REAL NOT NULL CHECK(long BETWEEN -180 AND 180),
 dbcap INTEGER,
 online_date TEXT
);
```

Since there is no consistent station ID between the various version of
the rides/trips tables, so we'll create an index on the name field so
that we can validate the stations as they are imported.

Create unique index idx_name on stations(name);

We'll start off with the station files.

Divvy_Bicycle_Stations_20250501.csv
Divvy_Stations_Trips_2013.zip
Divvy_Stations_Trips_2014_Q1Q2.zip
Divvy_Stations_Trips_2014_Q3Q4.zip

Ran into some duplicate stations names after importing stations from
Divvy_Stations_Trips_2013.zip

```text
  ---------------------------- -----------------------
  Station Name                 Number of Occurrences
  Burling St & Diversey Pkwy   2
  Clark St & Newport St        2
  Indiana Ave & 133rd St       2
  Western Ave & Lake St        2
  ---------------------------- -----------------------
```

So I added a " II" to the end of the name for the station with the
highest (most were numbers) short name. It looked like these might have
multiple areas with docks.

Even more problem with Divvy_Stations_Trips_2014_Q1Q2.zip as there was
no CSV file with stations only an Excel spreadsheet so I had to export
that to CSV. Also the naming convention was different so I gave up the
idea of having a single script that could import both the rides and stations in sequence as there were just too many exceptions to handle. I went with this streamlined script to import
stations.

I ended up dropping the unique index on station name in favor of

```SQL
CREATE UNIQUE INDEX uniq_vector ON stations(name, lat, long);
CREATE INDEX idx_name on stations(name);
```

That allowed me to insert duplicate station names if their lat and long
were different and ignore them if they were the same

```bash
"INSERT or IGNORE INTO stations (name, short_name, lat, long, dbcap,
online_date) VALUES ('$name', '$short_name', '$lat',
'$long', '$dbcap', '$online_date');"
```

That however led to another issue, the same station with multiple GPS
coordinates. It appears that the old entries had lower precision
entries. One assumes they were taken with less precise hardware by
different people and from slightly different spots. Are you interested
in a side quest about calculating the distance between two pair of GPS
coordinates? If not, just cut to the chase and use [dist-diff.sh](../src/dist-diff.sh).

Anyway, since we don't want to have to store the GPS coordinates in the
rides table (to keep it's size under control) and we don't want to keep
the station name either (same reason). So we need to be able to match up
rides with the right stations.

We'll do most of this matching as we insert rides. Have a look at
[load_rides.sh](../src/load_rides.sh), it handles selecting the station_id for start_stations and end_station, based on the stations_name and the GPS coordinates. It also converts gender and
user_type to boolean and converts dates and date/times to UNIX epoch for
storage as an integer.

Had a bit of an issue right off, I was trying to use a single
transaction for each imported CSV file for efficiency, but ran into an
issue with locks at about 20,000 records in to the import. So I ended up
doing transactions of 10,000 at a time. Still reasonably efficient, but
less problematic.

While Divvy_Trips_20250501.csv is importing, we'll go ahead and create a
view

```SQL
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
```

If one wanted they could create triggers to allow inserts and updates
via rider_readable and allow the use of the more friendly text version
(male/female, subscriber/customer), but I don't think I'll do that as 0
and 1 are faster to type. If I get some time after I've published this
I'll add a link (if this isn't a hyperlink then I'm lazy) that shows
the steps to add the triggers.

One thing I discovered was the SQLite doesn't handle time zones. Since
all the time are stored in UNIX epoch and thus UTC all the times
returned by SQLite will be UTC so we'll have to remember to adjust
manually (I really hate daylight savings time).

After a very long time loading Divvy_Trips_20250501.csv I went a head
and verified the time period covered

```bash
sqlite> SELECT
 MIN(start_time) AS earliest_start_time,
 MAX(end_time) AS latest_end_time
FROM rider_readable;
```

```text
earliest_start_time   latest_end_time 
-------------------  -------------------
2013-06-27 06:06:00  2020-04-26 23:12:03
```

```bash
sqlite\> select count(\*) from rides ;
```
20080914

Well that explains why it took so long.

****In Chicago**** the COVID-19 pandemic followed a timeline similar to
global and national trends with the first case in Chicago January 24,
2020, a woman returning from Wuhan China. Community spread in Chicago
was confirmed by early March 2020 and the lockdown began March 21, 2020.
I'd guess that's the reason the data end shortly after. I think it's
safest to avoid the pandemic in our analyses as that's just another
variable to try and control for.

We can use the UNIX date command to deal with the time zone issues and
find the epoch time we need

```bash
$ date --date="Jan 24, 2020 00:00 CST" "+%s"
```
1579845600

Let's see how many records are effected

```bash
sqlite > select count(*) from rides where start_time > 1579845600;
```
```text
*count(\*)*
--------
1 
```

That's a little strange.

```bash
sqlite > select start_time, end_time from rides where start_time > 1579845600 ;
```
```text
start_time end_time 
---------- ----------
1587941114 1587942723
```

So, Sun Apr 26 05:45:14 PM CDT 2020 to Sun Apr 26 06:12:03 PM CDT 2020.
Well, how many records are there in 2020?

```bash
$ date \--date=\"Jan 1, 2020 00:00 CST\" \"+%s\"
```
1577858400

```SQL
sqlite > select count(*) from rides where start_time > 1577858400;
```
```text
count(*)
--------
1 
```

So it's an outlier, we'll delete it since we were deleting all the stuff
during the pandemic anyway.

```bash
sqlite > delete from rides where start_time > 1577858400;
```

Let's look at December 31^st^ just to make sure we've got rides

```bash
sqlite > select count(*) from rides where start_time > 1577772000;
```
```text
count(*)
--------
2134 
```

Seems like a lot for New Years eve in Chicago, but maybe the weather was
nice, either way we've got data through the end of 2019. I don't see any
data earlier than what we have in S3, so we just need to load the post
pandemic data now. The "Emergency" officially ended May 11, 2023, we'll
grab the data starting in June of 2023.

With these "smaller" files it was nice to just add the following zip
file names to rideFiles and then let [load_rides.sh](../src/load_rides.sh) do all the work

202306-divvy-tripdata.zip
202307-divvy-tripdata.zip
202308-divvy-tripdata.zip
202309-divvy-tripdata.zip
202310-divvy-tripdata.zip
202311-divvy-tripdata.zip
202312-divvy-tripdata.zip
202401-divvy-tripdata.zip
202402-divvy-tripdata.zip
202403-divvy-tripdata.zip
202404-divvy-tripdata.zip
202405-divvy-tripdata.zip
202406-divvy-tripdata.zip
202407-divvy-tripdata.zip
202408-divvy-tripdata.zip
202409-divvy-tripdata.zip
202410-divvy-tripdata.zip
202411-divvy-tripdata.zip
202412-divvy-tripdata.zip
202501-divvy-tripdata.zip
202502-divvy-tripdata.zip
202503-divvy-tripdata.zip
202504-divvy-tripdata.zip

While this was cranking away I started looking at weather data. Seems to
me that weather may be a big differentiator between casual users and
subscribers. I found Meteostat which provides historical weather data
under the distributed under the terms of the [CC BY-NC 4.0
license](https://dev.meteostat.net/terms). I signed up for their free
plan to get an API key and searched for the nearby stations using the
lat/long from a randomly selected Divvy bike stations.

```bash
$ curl --request GET --url
'https://meteostat.p.rapidapi.com/stations/nearby?lat=41.8759&lon=-87.6305'
--header 'x-rapidapi-host: meteostat.p.rapidapi.com' --header
"x-rapidapi-key: $MYAPIKEY"*
```
```text
{"meta":{"generated":"2025-05-14 14:49:48"},"data":[{"id":"KCGX0","name":{"en":"Chicago / Central Station"},"distance":2724.9},{"id":"72534","name":{"en":"Chicago Midway Airport"},"distance":14284.9},{"id":"72530","name":{"en":"Chicago O’hare Airport"},"distance":26517.5},{"id":"KGYY0","name":{"en":"Gary / Clarke Junction"},"distance":34050.7},{"id":"KPWK0","name":{"en":"Chicago / Wood Oaks Glen"},"distance":34702.5},{"id":"KIGQ0","name":{"en":"Chicago / Lynwood"},"distance":38833.3},{"id":"N5DTT","name":{"en":"Schaumburg Regional Airport"},"distance":40927.5},{"id":"KLOT0","name":{"en":"Joliet / Lockport / Nottingham Ridge"},"distance":48781.3},{"id":"KDPA0","name":{"en":"Chicago / Surrey Woods"},"distance":51245.9},{"id":"7XHBS","name":{"en":"Joliet Regional Airport"},"distance":60507.7}
```

You don't actually need an API key to get bulk downloads

```bash
$ curl \"https://bulk.meteostat.net/v2/hourly/KCGX0.csv.gz" --output "KCGX0.csv.gz"
```

It would have been nice to have data from Central Station but after
downloading it I discovered it started in 1971 and ended in 1999. Midway
Airport may have to do

```bash
$ curl "https://bulk.meteostat.net/v2/hourly/72534.csv.gz" --output "72534.csv.gz"
```

Midway Airports data runs from 1973 to present so I'll drop the stuff
before our earliest time 2013-06-27 06:06:00 and then import what's left
into the database, throwing away any fields we don't want to use.

CSV files provided through the Meteostat bulk data interface use commas
as separators. Each file provides the following columns:

  ---- ------ -------------------------------------------- ---------
  1    date   The date string (format: YYYY-MM-DD)         String
  2    hour   The hour (UTC)                               Integer
  3    temp   The air temperature in °C                    Float
  4    dwpt   The dew point in °C                          Float
  5    rhum   The relative humidity in percent (%)         Integer
  6    prcp   The one hour precipitation total in mm       Float
  7    snow   The snow depth in mm                         Integer
  8    wdir   The wind direction in degrees (°)            Integer
  9    wspd   The average wind speed in km/h               Float
  10   wpgt   The peak wind gust in km/h                   Float
  11   pres   The sea-level air pressure in hPa            Float
  12   tsun   The one hour sunshine total in minutes (m)   Integer
  13   coco   The weather condition code                   Integer
  ---- ------ -------------------------------------------- ---------

More information on the data formats and weather condition codes (COCO)
is available [here](https://dev.meteostat.net/formats.html) and included
below;.

Weather conditions are indicated by an integer value between 1 and 27
according to this list:

  ---- ---------------------
  1    Clear
  2    Fair
  3    Cloudy
  4    Overcast
  5    Fog
  6    Freezing Fog
  7    Light Rain
  8    Rain
  9    Heavy Rain
  10   Freezing Rain
  11   Heavy Freezing Rain
  12   Sleet
  13   Heavy Sleet
  14   Light Snowfall
  15   Snowfall
  16   Heavy Snowfall
  17   Rain Shower
  18   Heavy Rain Shower
  19   Sleet Shower
  20   Heavy Sleet Shower
  21   Snow Shower
  22   Heavy Snow Shower
  23   Lightning
  24   Hail
  25   Thunderstorm
  26   Heavy Thunderstorm
  27   Storm
  ---- ---------------------

The data from Midway contains no entries for snow, peak wind gust or
total sunsine (minutes). So we can drop those columns. Also most people
do not consciously notice changes in air pressure, unless it\'s extreme.
Factors like precipitation, temperature and wind speed, have a far
stronger and more direct influence on bike usage. While air pressure
might correlate with some weather conditions (e.g., low pressure with
storms), it\'s not the pressure itself that influences behavior---it\'s
the weather phenomena that accompany it. So we'll be dropping air
pressure as well.

We'll go ahead and load this in to R and drop the columns and convert
the date and hour column to a datetime column and then convert that into
UNIX epoch format since the rides datetime is already in that format and
it will allow for easy joins and faster comparisons. Also the Midway
data did not contain any column headings, so we'll add them since it's
easier than adding them later in R.

```R
> df <- read.csv("/home/sas/classes/Google/data-analytics/data/midway_weather.csv", stringsAsFac
tors = FALSE)
> head(df)
        Date Hour Temp dwpt rhum prcp snow wdir wspd wpgt   pres tsun coco
1 2013-06-27    0 27.2 19.3   62    0   NA  270 18.4   NA 1005.7   NA   NA
2 2013-06-27    1 24.4 18.8   71    0   NA   10 16.6   NA 1005.7   NA   NA
3 2013-06-27    2 23.3 18.4   74    0   NA   20 11.2   NA 1006.5   NA   NA
4 2013-06-27    3 23.3 18.4   74    0   NA   30  9.4   NA 1006.7   NA   NA
5 2013-06-27    4 22.8 17.7   73    0   NA   10  5.4   NA 1007.0   NA   NA
6 2013-06-27    5 22.2 18.4   79    0   NA  350  9.4   NA 1007.8   NA   NA
> library(dplyr)
> df <- df %>% select(-snow)
> df <- df %>% select(-wpgt, -pres)
> head(df)
        Date Hour Temp dwpt rhum prcp wdir wspd tsun coco
1 2013-06-27    0 27.2 19.3   62    0  270 18.4   NA   NA
2 2013-06-27    1 24.4 18.8   71    0   10 16.6   NA   NA
3 2013-06-27    2 23.3 18.4   74    0   20 11.2   NA   NA
4 2013-06-27    3 23.3 18.4   74    0   30  9.4   NA   NA
5 2013-06-27    4 22.8 17.7   73    0   10  5.4   NA   NA
6 2013-06-27    5 22.2 18.4   79    0  350  9.4   NA   NA
> df <- df %>% select(-tsun)
> df$datetime <- as.POSIXct(paste(df$Date, sprintf("%02d:00:00", df$Hour)), format="%Y-%m-%d %H:
%M:%S", tz="UTC")
> df$epoch <- as.integer(df$datetime)
> 
> head(df)
        Date Hour Temp dwpt rhum prcp wdir wspd coco            datetime
1 2013-06-27    0 27.2 19.3   62    0  270 18.4   NA 2013-06-27 00:00:00
2 2013-06-27    1 24.4 18.8   71    0   10 16.6   NA 2013-06-27 01:00:00
3 2013-06-27    2 23.3 18.4   74    0   20 11.2   NA 2013-06-27 02:00:00
4 2013-06-27    3 23.3 18.4   74    0   30  9.4   NA 2013-06-27 03:00:00
5 2013-06-27    4 22.8 17.7   73    0   10  5.4   NA 2013-06-27 04:00:00
6 2013-06-27    5 22.2 18.4   79    0  350  9.4   NA 2013-06-27 05:00:00
       epoch
1 1372291200
2 1372294800
3 1372298400
4 1372302000
5 1372305600
6 1372309200
> df <- df[, c("epoch", setdiff(names(df), "epoch"))]
> 
> head(df)
       epoch       Date Hour Temp dwpt rhum prcp wdir wspd coco
1 1372291200 2013-06-27    0 27.2 19.3   62    0  270 18.4   NA
2 1372294800 2013-06-27    1 24.4 18.8   71    0   10 16.6   NA
3 1372298400 2013-06-27    2 23.3 18.4   74    0   20 11.2   NA
4 1372302000 2013-06-27    3 23.3 18.4   74    0   30  9.4   NA
5 1372305600 2013-06-27    4 22.8 17.7   73    0   10  5.4   NA
6 1372309200 2013-06-27    5 22.2 18.4   79    0  350  9.4   NA
             datetime
1 2013-06-27 00:00:00
2 2013-06-27 01:00:00
3 2013-06-27 02:00:00
4 2013-06-27 03:00:00
5 2013-06-27 04:00:00
```
Now we'll create a table for this data in SQLite

```R
> install.packages("RSQLite")
> con <- dbConnect(RSQLite::SQLite(), "/home/sas/classes/Google/data-analytics/data/caseStudy.db")
> dbExecute(con, "
+    CREATE TABLE hourly_weather (
+      epoch INTEGER PRIMARY KEY,
+      temp REAL,
+      dwpt REAL,
+      rhum INTEGER,
+      prcp REAL,
+      wdir INTEGER,
+      wspd REAL,
+      coco INTEGER
+   )
+ ")
[1] 0
>
>
> dbWriteTable(con, "hourly_weather", df, append = TRUE)
```
Warning message:
Column names will be matched ignoring character case

Now it's time for some weather. First off it would be nice if the rides
were broken down by hour like the weather data. So let's create a view
that does that.

```SQL
CREATE VIEW rides_per_hour AS
SELECT
  CAST((start_time / 3600) * 3600 AS INTEGER) AS epoch, -- start of hour 
  CASE user_type
       WHEN 0 THEN 'subscriber'
       WHEN 1 THEN 'customer'
  END AS user_type,
  COUNT(*) AS rides
FROM rides
GROUP BY epoch, user_type;
```


Now we can create a table with one entry per hour that joins rides and
weather

```SQL
CREATE TABLE rides_per_hour_tbl AS
SELECT
  CAST((start_time / 3600) * 3600 AS INTEGER) AS epoch,
  CASE user_type WHEN 0 THEN 'subscriber'
                 WHEN 1 THEN 'customer'
                 ELSE 'unknown' END          AS user_type,
  COUNT(*) AS rides
FROM rides
GROUP BY epoch, user_type;
```

Let's create an index so we don't have divide by 3600 for every row
every time

```SQL
CREATE INDEX idx_rides_per_hour_epoch
  ON rides_per_hour_tbl(epoch, user_type);
```

Now we'll add a view that joins with the weather data

```SQL
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
```       

Now we'll do some **data integrity checks **first we'll look for time
travelers

```SQL
select count(\*) from rides where start_time \> end_time;
```
190

Cyclistic has a strict no time travel policy to avoid any paradoxes that
might arise, so we'll drop those rows

```SQL
delete from riders where start_time > end_time;
```

Next up those zero length rides

```SQL
select count(*) from rides where start_time = end_time and
start_station_id = end_station_id;
```
624

If they took no time and went nowhere that shouldn't count as a ride...
so

```SQL
delete from rides where start_time = end_time and start_station_id =
end_station_id;
```

Where there any that took no time, but did go somewhere?

```SQL
select count(*) from rides where start_time = end_time and
start_station_id <> end_station_id;
```
100

To go somewhere in zero time implies teleportation and Cyclistic has a
rule against using it's bikes for teleportation. In any event
teleportation does not count as a ride

```SQL
delete from rides where start_time = end_time and start_station_id \<\>
end_station_id;
```

We could look at conflicts where a bike is in use on more than one ride
at the same time, but that query is harry, given there are more than 28
million rows with a non null bike_id and 6526 unique bike_id's.

```SQL
select count(*) from rides where bike_id <> '';
```
20080691

```SQL
SELECT COUNT(DISTINCT bike_id) AS unique_bikes FROM rides;
```
6526

So I think as a compromise we'll grab a small sample of bikes and check
them for conflicts. I think doing just one should let us get an idea of
how long this will take and how big a sample we can use.

```SQL
select bike_id from rides where bike_id <> '' order by random() limit 1;
```
2311

Yea, yea, it's not random but good enough for a test.

```SQL
SELECT a.ride_id AS ride_a,
       b.ride_id AS ride_b,
       a.start_time AS start_a,
       a.end_time AS end_a,
       b.start_time AS start_b,
       b.end_time AS end_b
FROM rides a
JOIN rides b
  ON a.bike_id = b.bike_id
 AND a.ride_id < b.ride_id  -- avoid duplicate and self-pairs
 AND a.end_time > b.start_time
 AND a.start_time < b.end_time
WHERE a.bike_id = '2311' limit 10;
```
```text
rride_a  ride_b  start_a     end_a       start_b     end_b     
------  ------  ----------  ----------  ----------  ----------
19178   20842   1385590980  1385591220  1385590980  1385591220
```

Well that looks suspiciously like a duplicate

```SQL
select \* from rides where ride_id = 19178 or ride_id = 20842;
```
```text
ride_id  bike_type  bike_id  start_time  end_time    start_station_id  end_station_id  user_type  gender  birth_year
-------  ---------  -------  ----------  ----------  ----------------  --------------  ---------  ------  ----------
19178               2311     1385590980  1385591220  1247              1074            0          0       1982      
20842               2311     1385590980  1385591220  1247              1074            0          0       1982 
```

I had hoped we wouldn't have a lot of duplicates as my cursory
examination of the CSV files showed they were sorted by start_time and I
didn't see any duplicates, but of course I only looked at a tiny amount
of the data. So we'll have to clean up the duplicates. Let's make a
backup copy of the database first. With SQLite it as simple as making a
copy of the database, as long as nothing is writing to the database.

cp caseStudy.db caseStudy_backup.db

Now let's take a look at just how many duplicates there are

```SQL
SELECT count(\*) FROM rides WHERE rowid NOT IN (
SELECT MIN(rowid) FROM rides GROUP BY bike_id, start_time, end_time
) ;
```
```text
count(*)
--------
2767
```

Well that's not too bad out of more than 28 million rows.

```SQL
delete
FROM rides
WHERE rowid NOT IN (
SELECT MIN(rowid)
FROM rides
GROUP BY bike_id, start_time, end_time
) ;
```
```bash
sqlite > select count(*) from rides;
```
```text
count(*)
--------
28386573
```

So now back to looking at rides on a bike that have overlapping times

```SQL
SELECT a.ride_id AS ride_a,
       b.ride_id AS ride_b,
       a.start_time AS start_a,
       a.end_time AS end_a,
       b.start_time AS start_b,
       b.end_time AS end_b
FROM rides a
JOIN rides b
  ON a.bike_id = b.bike_id
 AND a.ride_id < b.ride_id  -- avoid duplicate and self-pairs
 AND a.end_time > b.start_time
 AND a.start_time < b.end_time limit 10;
```
```text
ride_a  ride_b  start_a     end_a       start_b     end_b     
------  ------  ----------  ----------  ----------  ----------
38307   38341   1374774420  1374774480  1374774360  1374774480
70772   71240   1374875580  1374876840  1374875580  1374875700
72510   72511   1389395220  1389395820  1389395280  1389395820
96565   96570   1391209080  1391209500  1391209140  1391209500
96565   96571   1391209080  1391209500  1391209200  1391209500
96565   96573   1391209080  1391209500  1391209200  1391209560
96565   96574   1391209080  1391209500  1391209260  1391209560
96570   96571   1391209140  1391209500  1391209200  1391209500
96570   96573   1391209140  1391209500  1391209200  1391209560
96570   96574   1391209140  1391209500  1391209260  1391209560
```

Cleaning that up a bit

```SQL
select ride_id, bike_id as bike, start_time, end_time, start_station_id as start, end_station_id as end from rider_readable where ride_id in (38307, 38341, 70772, 71240, 72510, 72511, 96565, 96570, 96571, 96573, 96574);
```
```text
ride_id  bike  start_time           end_time             start  end 
-------  ----  -------------------  -------------------  -----  ----
38307    819   2013-07-25 17:47:00  2013-07-25 17:48:00  159    159 
38341    819   2013-07-25 17:46:00  2013-07-25 17:48:00  159    159 
70772    428   2013-07-26 21:53:00  2013-07-26 22:14:00  152    1257
71240    428   2013-07-26 21:53:00  2013-07-26 21:55:00  152    152 
72510    1026  2014-01-10 23:07:00  2014-01-10 23:17:00  1073   1141
72511    1026  2014-01-10 23:08:00  2014-01-10 23:17:00  1073   1141
96565    2912  2014-01-31 22:58:00  2014-01-31 23:05:00  1115   1199
96570    2912  2014-01-31 22:59:00  2014-01-31 23:05:00  1115   1199
96571    2912  2014-01-31 23:00:00  2014-01-31 23:05:00  1115   1199
96573    2912  2014-01-31 23:00:00  2014-01-31 23:06:00  1115   1199
96574    2912  2014-01-31 23:01:00  2014-01-31 23:06:00  1115   1199
```

We've got a couple of 1 minute rides that didn't go anywhere and a 2
minute ride that didn't go anywhere. Those don't sound like successful
rides, so off then go

```SQL
delete from rides where ride_id in (38307, 38341, 71240);
```

We've got a 10 minute and an 11 minute ride with the same bike between
the same stations. We'll keep the one with the smallest ride_id

```SQL
delete from rides where ride_id = 72511;
```

Now we have 5 rides that start within 4 minutes and end within 2 minutes
of each other and use the same bike between the same stations. So again
we keep the one with the smallest ride_id

```SQL
delete from rides where ride_id in (96570, 96571, 96573, 96574);
```

Let's take a look at the breakdown of rides between subscribers and
casual riders

```SQL
SELECT user_type, COUNT(*) AS Rides
FROM rides
GROUP BY user_type;
```
```text
user_type  Rides   
---------  --------
           194     
0          20519211
1          7867354 
```

We need to investigate those 194 who aren't subscribers or causal
riders.

```SQL
select count(*) from rides where user_type IS NULL;
```
```text
count(*)
--------
194 
```

So they are all NULL. They won't be any use in determining how
subscribers and casual riders differ, so we'll go ahead and drop these.

```SQL
delete from rides where user_type IS NULL;
```

*Now we can finally start doing some real analyses.*

We'll start by looking at record counts of all the tables. First we'll
run a query to generate the SQL statement for all that tables.

```SQL
SELECT 
  'SELECT ''' || name || ''' AS table_name, COUNT(*) AS row_count FROM "' || name || '"' || 
  ' UNION ALL '
FROM 
  sqlite_master
WHERE 
  type='table' AND name NOT LIKE 'sqlite_%';
SELECT 'stations' AS table_name, COUNT(*) AS row_count FROM "stations" UNION ALL 
SELECT 'rides' AS table_name, COUNT(*) AS row_count FROM "rides" UNION ALL 
SELECT 'hourly_weather' AS table_name, COUNT(*) AS row_count FROM "hourly_weather" UNION ALL 
SELECT 'rides_per_hour_tbl' AS table_name, COUNT(*) AS row_count FROM "rides_per_hour_tbl" UNION ALL
```

We need to trim that "UNION ALL" off the last line. Then we just run the
query

```SQL
SELECT 'stations' AS table_name, COUNT(*) AS row_count FROM "stations" UNION ALL 
SELECT 'rides' AS table_name, COUNT(*) AS row_count FROM "rides" UNION ALL 
SELECT 'hourly_weather' AS table_name, COUNT(*) AS row_count FROM "hourly_weather" UNION ALL 
SELECT 'rides_per_hour_tbl' AS table_name, COUNT(*) AS row_count FROM "rides_per_hour_tbl" ;
```
```text
table_name          row_count
------------------  ---------
stations            1276     
rides               28386565 
hourly_weather      104099   
rides_per_hour_tbl  139994   
```

Getting the MAX ride times for subscribers and customers

```SQL
select ride_id, max(end_time-start_time), user_type from rides group by user_type; 
```
```text
ride_id   max(end_time-start_time)  user_type
--------  ------------------------  ---------
16712679  11469071                  0        
16149308  11635045                  1
```

That's a long time, I hope those bikes have comfortable seats. I wonder
how many of these long rides there are?

```SQL
select count(*) as longer_than_a_month, user_type from rides where end_time-start_time > 2592000 group by user_type; 
```
```text
longer_than_a_month  user_type
-------------------  ---------
27                   0        
124                  1
```

OK, it wasn't a month it was 30 days ... how about a week

```SQL
select count(*) as longer_than_a_week, user_type from rides where
end_time-start_time > 604800 group by user_type; 
```
```text
longer_than_a_week  user_type
------------------  ---------
126                 0        
703                 1  
```

Longer than a day

```SQL
select count(*) as longer_than_a_day, user_type from rides where end_time-start_time > 604800 group by user_type; 
```
```text
longer_than_a_day  user_type
-----------------  ---------
126                0        
703                1 
```

That's good news, so we have less than 1000 of these "long rides". The
question is what to do about them. I'd love to delete them but I think
it's better to just make sure we exclude them from any queries where
they may skew the results. Like what we're looking at next, the average
ride length

```SQL
SELECT
  CASE user_type
       WHEN 0 THEN 'subscriber'
       WHEN 1 THEN 'customer'
  END                           AS user_type,
  ROUND(AVG(end_time - start_time), 1)          AS avg_seconds,
  ROUND(AVG((end_time - start_time) / 60.0), 1) AS avg_minutes
FROM rides where end_time - start_time < 86400                                                  
GROUP BY user_type
ORDER BY user_type; 
```
```text
user_type   avg_seconds  avg_minutes
----------  -----------  -----------
customer    1753.1       29.2       
subscriber  730.9        12.2     
```

So customer's rides are a little less than 3 times longer than
subscriber's rides. I wonder what that looks like broken out by weekdays

```SQL
SELECT
  /* translate user_type codes just like in rider_readable */
  CASE user_type
       WHEN 0 THEN 'subscriber'
       WHEN 1 THEN 'customer'
  END                                         AS user_type,
  /* weekday number 0–6 */
  strftime('%w', start_time, 'unixepoch')     AS weekday_num,
  /* nicer label: Sun, Mon, … */
  CASE strftime('%w', start_time, 'unixepoch')
       WHEN '0' THEN 'Sun'
       WHEN '1' THEN 'Mon'
       WHEN '2' THEN 'Tue'
       WHEN '3' THEN 'Wed'
       WHEN '4' THEN 'Thu'
       WHEN '5' THEN 'Fri'
       WHEN '6' THEN 'Sat'
  END                                         AS weekday,
  /* average ride length */
  ROUND(AVG(end_time - start_time), 1)        AS avg_seconds,
  ROUND(AVG((end_time - start_time) / 60.0),1) AS avg_minutes
FROM rides  where end_time - start_time < 86400
GROUP BY user_type, weekday
ORDER BY user_type, weekday_num; 
```
```text
user_type   weekday_num  weekday  avg_seconds  avg_minutes
----------  -----------  -------  -----------  -----------
customer    0            Sun      1886.5       31.4       
customer    1            Mon      1737.7       29.0       
customer    2            Tue      1625.0       27.1       
customer    3            Wed      1587.3       26.5       
customer    4            Thu      1604.1       26.7       
customer    5            Fri      1684.1       28.1       
customer    6            Sat      1873.4       31.2       
subscriber  0            Sun      811.4        13.5       
subscriber  1            Mon      716.0        11.9       
subscriber  2            Tue      708.3        11.8       
subscriber  3            Wed      708.7        11.8       
subscriber  4            Thu      708.5        11.8       
subscriber  5            Fri      713.5        11.9       
subscriber  6            Sat      800.3        13.3 
```

Well, rides are longer on the weekends as I expected, but not by much
and the same holds true for both subscribers and customers. Not what I
was expecting, I kind of expected to see much longer rides for customers
on the weekends. Oh well, follow the data.

Now let's see who's taking those midnight rides

```SQL
SELECT
  /* translate the user‑type codes */
  CASE user_type
       WHEN 0 THEN 'subscriber'
       WHEN 1 THEN 'customer'
  END                                   AS user_type,

  /* two‑digit hour in local time 00‑23 */
  strftime('%H', start_time, 'unixepoch', 'localtime') AS hour_of_day,

  COUNT(*)                              AS ride_count
FROM rides
GROUP BY user_type, hour_of_day
ORDER BY user_type, hour_of_day;        -- keeps 00→23 order
```
```text
user_type   hour_of_day  ride_count
----------  -----------  ----------
customer    00           95556     
customer    01           61643     
customer    02           37569     
customer    03           20729     
customer    04           14311     
customer    05           26066     
customer    06           64858     
customer    07           127569    
customer    08           204566    
customer    09           264064    
customer    10           391852    
customer    11           525643    
customer    12           612446    
customer    13           654789    
customer    14           681764    
customer    15           711001    
customer    16           733826    
customer    17           721591    
customer    18           587568    
customer    19           433260    
customer    20           308978    
customer    21           240055    
customer    22           206270    
customer    23           142318    
subscriber  00           137696    
subscriber  01           81055     
subscriber  02           46515     
subscriber  03           29905     
subscriber  04           41487     
subscriber  05           199489    
subscriber  06           662530    
subscriber  07           1434237   
subscriber  08           1823702   
subscriber  09           958285    
subscriber  10           748541    
subscriber  11           899550    
subscriber  12           1033223   
subscriber  13           1004424   
subscriber  14           972086    
subscriber  15           1207970   
subscriber  16           1928876   
subscriber  17           2533920   
subscriber  18           1719965   
subscriber  19           1134089   
subscriber  20           751849    
subscriber  21           551697    
subscriber  22           387627    
subscriber  23           233249    
```

Is it just me or does it seem odd to have that many rides starting in
the middle of the night. Don't forget these times of UTC.

Let's look at the breakdown of the number of rides by weekday

```SQL
SELECT 
  CASE strftime('%w', start_time, 'unixepoch')
    WHEN '0' THEN 'Sun'
    WHEN '1' THEN 'Mon'
    WHEN '2' THEN 'Tue'
    WHEN '3' THEN 'Wed'
    WHEN '4' THEN 'Thu'
    WHEN '5' THEN 'Fri'
    WHEN '6' THEN 'Sat'
  END AS weekday,
  COUNT(*) AS ride_count
FROM 
  rides
GROUP BY 
  weekday
ORDER BY 
  strftime('%w', start_time, 'unixepoch'); --ensures proper weekday order
```  
```text
weekday  ride_count
-------  ----------
Sun      3747953   
Mon      3935207   
Tue      4128171   
Wed      4151033   
Thu      4135719   
Fri      4239732   
Sat      4052638
```

Then we should also have a look the number of rides by months

```SQL
SELECT 
  CASE strftime('%m', start_time, 'unixepoch')
    WHEN '01' THEN 'Jan'
    WHEN '02' THEN 'Feb'
    WHEN '03' THEN 'Mar'
    WHEN '04' THEN 'Apr'
    WHEN '05' THEN 'May'
    WHEN '06' THEN 'Jun'
    WHEN '07' THEN 'Jul'
    WHEN '08' THEN 'Aug'
    WHEN '09' THEN 'Sep'
    WHEN '10' THEN 'Oct'
    WHEN '11' THEN 'Nov'
    WHEN '12' THEN 'Dec'
  END AS weekday,
  COUNT(*) AS ride_count
FROM 
  rides
GROUP BY 
  weekday
ORDER BY 
  strftime('%m', start_time, 'unixepoch'); --ensures proper month order
```  
```text
weekday  ride_count
-------  ----------
Jan      700026    
Feb      820035    
Mar      1279694   
Apr      1820100   
May      2379623   
Jun      3576901   
Jul      4167419   
Aug      4226322   
Sep      3759818   
Oct      2948301   
Nov      1666732   
Dec      1045482
```

```awk
awk -F',' 'NR==1 {
  print "station_name,lat,lon,total_rides,subscriber_rides,customer_rides,path_id";
  next
}
{
  path_id = NR - 1;
  print $1 "," $2 "," $3 "," $7 "," $8 "," $9 "," path_id;
  print $4 "," $5 "," $6 "," $7 "," $8 "," $9 "," path_id;
}' station_pairs.csv > reshaped_pairs.csv
```
```bash
sqlite3 caseStudy.db < asymmetry.sql > asymmetry.out
```
```R
> library(ggplot2)
> library(dplyr)

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:

    filter, lag

The following objects are masked from ‘package:base’:

    intersect, setdiff, setequal, union

> library(readr)
> asym_data <- read_csv("/home/sas/classes/Google/data-analytics/data/asymmetry.csv")
Rows: 1789 Columns: 8                                                         
── Column specification ──────────────────────────────────────────────────────
Delimiter: ","
chr (3): user_type_label, station_a_name, station_b_name
dbl (5): count_ab, count_ba, diff, total, asymmetry_ratio

ℹ Use `spec()` to retrieve the full column specification for this data.
ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

> top_n <- 20
> asym_top <- asym_data %>%
+     group_by(user_type_label) %>%
+     slice_max(order_by = asymmetry_ratio, n = top_n, with_ties = FALSE) %>%
+     ungroup()
> asym_top <- asym_top %>%
+     mutate(path_label = paste(station_a_name, "→", station_b_name))
> 
> 
> ggplot(asym_top, aes(x = asymmetry_ratio, y = reorder(path_label, asymmetry_ratio))) +
+     geom_col(fill = "darkblue") +
+     geom_text(
+         aes(label = path_label),
+         x = 0.01,                   # Start labels just inside the bar
+         hjust = 0,                  # Left-align text
+         color = "white",
+         size = 2.7,
+         fontface = "plain"
+     ) +
+     facet_wrap(~ user_type_label, scales = "free_y") +
+     labs(
+         title = paste("Top", top_n, "Most Asymmetric Paths by User Type"),
+         x = "Asymmetry Ratio", 
+         y = NULL
+     ) +
+     coord_cartesian(xlim = c(0, max(asym_top$asymmetry_ratio) + 0.10)) +  # Allow space for labels
+     theme_minimal(base_size = 11) +
+     theme(
+         plot.title = element_text(hjust = 0.1),
+         axis.text.y = element_blank(),
+         axis.ticks.y = element_blank(),
+         panel.grid.major.y = element_blank()
+     )
```

```R
> library(DBI)
> library(RSQLite)
> library(dplyr)
> library(scales)

Attaching package: ‘scales’

The following object is masked from ‘package:readr’:

    col_factor

>   
>
> con <- dbConnect(RSQLite::SQLite(), "/home/sas/classes/Google/data-analytics/data/caseStudy.db")
> # get rides less than 4 hours long
> ride_durations <- dbGetQuery(con, "
+   SELECT
+     CASE user_type
+       WHEN 0 THEN 'subscriber'
+       WHEN 1 THEN 'customer'
+     END AS user_type,
+     (end_time - start_time) / 60.0 AS duration_min
+   FROM rides
+   WHERE user_type IN (0, 1)
+ AND (end_time - start_time) < 14400
+ ")

> ggplot(ride_durations, aes(x = duration_min, fill = user_type)) +
+     geom_histogram(binwidth = 2, position = "identity", alpha = 0.6) +
+     labs(title = "Ride Duration Distribution", x = "Duration (minutes)", y = "Ride Count") +
+     scale_fill_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
+     scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) + theme_minimal()

> ggplot(ride_durations, aes(x = duration_min, color = user_type, fill = user_type)) +
+     geom_density(alpha = 0.3) +
+     labs(title = "Ride Duration Density", x = "Duration (minutes)", y = "Density") +
+     scale_color_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
+     scale_fill_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
+     theme_minimal()
> 
> ggplot(ride_durations, aes(x = user_type, y = duration_min, fill = user_type)) +
+     geom_boxplot(outlier.alpha = 0.1) +
+     labs(title = "Ride Duration by User Type", x = "", y = "Duration (minutes)") +
+     scale_fill_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
+     theme_minimal()
> 
> ride_durations %>%
+     group_by(user_type) %>%
+     summarise(
+         count = n(),
+         mean_duration = mean(duration_min),
+         median_duration = median(duration_min),
+         sd_duration = sd(duration_min),
+     )
# A tibble: 2 × 5
  user_type     count mean_duration median_duration sd_duration
  <chr>         <int>         <dbl>           <dbl>       <dbl>
1 customer    7805995          26.4           19.3        25.8  
2 subscriber 20500317          11.8            9.17        9.39 
> 

> # Plotting total + lines for each user type
> ggplot(binned_rides, aes(x = temp_bin)) +
+     geom_line(aes(y = total, color = "Total")) +
+     geom_line(aes(y = subscriber, color = "Subscriber")) +
+     geom_line(aes(y = customer, color = "Customer")) +
+     scale_color_manual(values = c("Total" = "black", "Subscriber" = "blue", "Customer" = "red")) +
+     labs(
+         title = "Ride Volume by Temperature (2°C Bins)",
+         x = "Temperature (°C, binned)",
+         y = "Total Rides",
+         color = "User Type"
+     ) +
+     scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
+     theme_minimal()
Warning messages:
1: Removed 1 row containing missing values or values outside the scale range (`geom_line()`). 
2: Removed 1 row containing missing values or values outside the scale range (`geom_line()`). 
3: Removed 1 row containing missing values or values outside the scale range (`geom_line()`). 
> 
> rides_weather_df %>%
+     mutate(temp_bin = floor(temp / 2) * 2) %>%
+     count(temp_bin) %>%
+     ggplot(aes(x = temp_bin, y = n)) +
+     geom_col(fill = "gray") +

+     labs(title = "Frequency of Temperature Bins", x = "Temp (°C)", y = "Hours Observed")
Warning message:
Removed 1 row containing missing values or values outside the scale range (`geom_col()`). 
> 
> rides_weather_df %>%
+     mutate(
+         temp_bin = floor(temp / 2) * 2,
+         precip_label = case_when(
+             is.na(prcp)      ~ "No data",
+             prcp == 0        ~ "Dry",
+             prcp > 0         ~ "Wet"
+         )
+     ) %>%
+     group_by(temp_bin, user_type, precip_label) %>%
+     summarise(rides = sum(rides), .groups = "drop") %>%
+     ggplot(aes(x = temp_bin, y = rides, color = user_type)) +
+     geom_line(size = 1) +
+     facet_wrap(~ precip_label, nrow = 1) +
+     labs(
+         title = "Ride Volume by Temperature and Precipitation",
+         subtitle = "2°C temperature bins grouped by rain condition",
+         x = "Temperature Bin (°C)",
+         y = "Total Rides",
+         color = "User Type"
+     ) +
+     scale_x_continuous(breaks = seq(-30, 40, by = 10)) +
+     theme_minimal(base_size = 14)

> ggplot(rides_weather_df, aes(x = temp, y = rides)) +
+     geom_smooth(method = "loess", se = FALSE, color = "darkgreen") +
+     scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
+     facet_wrap(~ user_type) +
+     labs(
+         title = "Temperature vs Ride Volume by User Type",
+         x = "Temperature (°C)",
+         y = "Hourly Ride Volume"
+     ) +
+     theme_minimal()
`geom_smooth()` using formula = 'y ~ x'
Warning message:
Removed 2 rows containing non-finite outside the scale range
(`stat_smooth()`). 
> 


# Query top 50 stations per user_type
> query <- "
+ WITH ranked_stations AS (
+   SELECT
+     s.station_id,
+     s.name,
+     s.lat,
+     s.long,
+     CASE user_type
+       WHEN 0 THEN 'subscriber'
+       WHEN 1 THEN 'customer'
+     END AS user_type,
+     COUNT(*) AS ride_count,
+     ROW_NUMBER() OVER (PARTITION BY user_type ORDER BY COUNT(*) DESC) AS rn
+   FROM rides
+   JOIN stations AS s ON rides.start_station_id = s.station_id
+   GROUP BY s.station_id, user_type
+ )
+ SELECT * FROM ranked_stations WHERE rn <= 50;
+ "
> 
> top_stations_df <- dbGetQuery(con, query)
> 
> head(top_stations_df)  

  station_id                         name      lat      long  user_type ride_count rn
1        666 Clinton St & Washington Blvd 41.88338 -87.64117 subscriber     312299  1
2         73          Canal St & Adams St 41.87926 -87.63990 subscriber     300498  2
3        751      Clinton St & Madison St 41.88275 -87.64119 subscriber     250116  3
4        144     Kingsbury St & Kinzie St 41.88918 -87.63851 subscriber     191005  4
5       1141        Canal St & Madison St 41.88209 -87.63983 subscriber     189285  5
6        802    Columbus Dr & Randolph St 41.88473 -87.61952 subscriber     172803  6
>

> top_stations_df_offset <- top_stations_df %>%
+     mutate(
+         long_offset = ifelse(user_type == "subscriber", long - 0.0001, long + 0.0001)
+     )
> 
> leaflet(top_stations_df_offset) %>%
+     addTiles() %>%
+     addCircleMarkers(
+         lng = ~long_offset,
+         lat = ~lat,
+         color = ~pal(user_type),
+         radius = ~pmax(sqrt(ride_count) / 50, 4),
+         stroke = FALSE,
+         fillOpacity = 0.8,
+         popup = ~paste0(
+             "<b>", name, "</b><br>", "Rank: #", rn, "<br>",
+             "User Type: ", user_type, "<br>",
+             "Ride Count: ", format(ride_count, big.mark = ",")
+         )
+     ) %>%
+     addLegend(
+         position = "bottomright",
+         pal = pal,
+         values = ~user_type,
+         title = "User Type",

+         opacity = 1
+     )
> 

We’ll take a look at how e-bikes have affected ride duration.

> post_electric_rides_df <- dbGetQuery(con, "SELECT
+   DATE(start_time, 'unixepoch') AS ride_date,
+   user_type,
+   bike_type,
+   COUNT(*) AS ride_count,
+   AVG((end_time - start_time) / 60.0) AS avg_duration_minutes
+ FROM rides
+ WHERE start_time >= strftime('%s', '2023-01-01') --first e-bike appeared
+ GROUP BY ride_date, user_type, bike_type;
+ ")
>
> daily_avg_df <- post_electric_rides_df %>%
+     group_by(user_type, bike_type) %>%
+     summarise(
+         avg_rides_per_day = mean(ride_count),
+         .groups = "drop"
+     )
> 
> library(forcats)
> 
> ggplot(daily_avg_df, aes(
+     x = bike_type,
+     y = avg_rides_per_day,
+     fill = fct_recode(as.factor(user_type),
+                       "Subscriber" = "0",
+                       "Customer" = "1")
+ )) +
+     geom_bar(stat = "identity", position = "dodge") +
+     labs(
+         title = "Average Daily Rides by Bike Type and User Type (Post-Electric Launch)",
+         x = "Bike Type",
+         y = "Average Rides per Day",
+         fill = "User Type"
+     ) +
+     theme_minimal()

> duration_by_type <- post_electric_rides_df %>%
+     group_by(user_type, bike_type) %>%
+     summarise(
+         avg_duration = mean(avg_duration_minutes, na.rm = TRUE),
+         sd_duration = sd(avg_duration_minutes, na.rm = TRUE),
+         .groups = "drop"
+     )
> 
> duration_by_type$user_type <- fct_recode(as.factor(duration_by_type$user_type),
+                                          "Subscriber" = "0",
+                                          "Customer" = "1")
> 
> ggplot(duration_by_type, aes(
+     x = bike_type,
+     y = avg_duration,
+     fill = user_type
+ )) +
+     geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
+     geom_errorbar(aes(
+         ymin = avg_duration - sd_duration,
+         ymax = avg_duration + sd_duration
+     ), position = position_dodge(width = 0.9), width = 0.3) +
+     labs(
+         title = "Average Ride Duration by Bike Type and User Type",
+         x = "Bike Type",
+         y = "Avg Duration (minutes)",
+         fill = "User Type"
+     ) +
+     theme_minimal()
>
```

Thinking about how customers use bikes and how they might be converted
to subscribers, it seems that one class of customer is very unlikely to
be converted, and that is tourist. The vast majority of them won't be
local and thus would never consider a subscription. So if we look at
only the stations not near tourist attractions, we'll likely see a lower
percentage of tourist rides.

So I manually collected 24 tourist attractions GPS coordinate from
Google Maps and we'll use those to cull the stations for the next steps
in the analysis.

```R
> library(geosphere)
> stations_df <- dbGetQuery(con, "SELECT station_id, name, latitude AS lat, longitude AS long FROM stations")
> attractions_df <- read.csv("/home/sas/classes/Google/data-analytics/data/tourist_attractions.csv", stringsAsFactors = FALSE)
>
> find_nearby_stations <- function(attraction, stations, radius = 200) {
+     print(attraction)  # or print(attraction[c("long", "lat")])
+     
+     coords <- as.numeric(unlist(attraction[c("long", "lat")]))
+     
+     distances <- distHaversine(
+         matrix(c(stations$long, stations$lat), ncol = 2),
+         coords
+     )
+     
+     nearby <- stations[distances <= radius, ]
+     nearby$distance_m <- distances[distances <= radius]
+     nearby$attraction <- attraction$name
+     return(nearby)
+ }
```

Combine the nearby stations into a dataframe

```R
> nearby_stations_df <- bind_rows(nearby_stations_list)
```

Exclude These from the Full Stations List

```R
> 
> stations_non_tourist_df <- stations_df %>%
+     filter(!(name %in% nearby_stations_df$name))
>
```

Now we'll create an SQL statement to select rides between non-tourist
stations for customers, but let's get a count first to see if R can
handle that much data.

```R
> station_ids_sql <- paste(sprintf("%s", stations_non_tourist_df$station_id), collapse = ", ")
> 
> count_query <- sprintf("
+   SELECT COUNT(*) AS n
+   FROM rides
+   WHERE user_type = 1
+     AND start_station_id IN (%s)
+     AND end_station_id IN (%s)
+ ", station_ids_sql, station_ids_sql)
> 
> ride_count <- dbGetQuery(con, count_query)$n
> print(ride_count)
[1] 6014004
```

That's probably at the limit for R Studio on my laptop, so we'll take
the safe route and try just rides after the introduction of e-bikes

```R
> 
> station_ids_sql <- paste(sprintf("%s", stations_non_tourist_df$station_id), collapse = ", ")
> 
> count_query <- sprintf("
+   SELECT COUNT(*) AS n
+   FROM rides
+   WHERE user_type = 1
+     AND start_station_id IN (%s)
+     AND end_station_id IN (%s)
+     AND start_time >= strftime('%%s', '2023-01-01')
+ ", station_ids_sql, station_ids_sql)
> 
> ride_count <- dbGetQuery(con, count_query)$n
> print(ride_count)
[1] 2476187
```

That's manageable.

```R
> ride_query <- sprintf("
+   SELECT
+     ride_id,
+     start_time,
+     end_time,
+     start_station_id,
+     end_station_id,
+     bike_type
+   FROM rides
+   WHERE user_type = 1
+     AND start_station_id IN (%s)
+     AND end_station_id IN (%s)
+     AND start_time >= strftime('%%s', '2023-01-01')
+ ", station_ids_sql, station_ids_sql)
> 
> non_tourist_customer_rides_df <- dbGetQuery(con, ride_query)
> 
```

```R
> library(tidyr)
> 
> # Combine start and end stations into one column and count
> top_non_tourist_stations <- non_tourist_customer_rides_df %>%
+     select(start_station_id, end_station_id) %>%
+     pivot_longer(cols = everything(), values_to = "station_id") %>%
+     group_by(station_id) %>%
+     summarise(customer_ride_count = n(), .groups = "drop") %>%
+     arrange(desc(customer_ride_count)) %>%
+     slice_head(n = 25)
> 
> print(top_non_tourist_stations)
# A tibble: 25 × 2
   station_id customer_ride_count
        <int>               <int>
 1        936              142856
 2        967               90518
 3        577               51554
 4        579               47154
 5        752               40662
 6        307               40629
 7        434               37243
 8        942               36976
 9        292               36122
10        656               34665
# ℹ 15 more rows
# ℹ Use `print(n = ...)` to see more rows
>
```

We'll need some names for these stations

```R
> station_counts <- bind_rows(
+     non_tourist_customer_rides_df %>% select(station_id = start_station_id),
+     non_tourist_customer_rides_df %>% select(station_id = end_station_id)
+ ) %>%
+     group_by(station_id) %>%
+     summarise(customer_ride_count = n(), .groups = "drop") %>%
+     arrange(desc(customer_ride_count)) %>%
+     slice_head(n = 25)

> top_non_tourist_stations_named <- top_non_tourist_stations %>%
+     inner_join(stations_df, by = c("station_id" = "station_id")) %>%
+     arrange(desc(customer_ride_count))
> 
> print(n=25, top_non_tourist_stations_named)
# A tibble: 25 × 5
   station_id customer_ride_count name                                    lat  long
        <int>               <int> <chr>                                 <dbl> <dbl>
 1        936              142856 Streeter Dr & Grand Ave                41.9 -87.6
 2        967               90518 DuSable Lake Shore Dr & Monroe St      41.9 -87.6
 3        577               51554 Theater on the Lake                    41.9 -87.6
 4        579               47154 Dusable Harbor                         41.9 -87.6
 5        752               40662 DuSable Lake Shore Dr & Belmont Ave    41.9 -87.6
 6        307               40629 Clark St & Grace St                    42.0 -87.7
 7        434               37243 Halsted St & Wrightwood Ave            41.9 -87.6
 8        942               36976 Montrose Harbor                        42.0 -87.6
 9        292               36122 Wells St & Concord Ln                  41.9 -87.6
10        656               34665 Clark St & Lincoln Ave                 41.9 -87.6
11        800               34484 Adler Planetarium                      41.9 -87.6
12       1041               34114 Michigan Ave & 8th St                  41.9 -87.6
13        866               33640 Clark St & Armitage Ave                41.9 -87.6
14         73               33288 Canal St & Adams St                    41.9 -87.6
15        437               33218 Indiana Ave & Roosevelt Rd             41.9 -87.6
16       1143               32566 Clark St & Elm St                      41.9 -87.6
17        370               31599 Wells St & Elm St                      41.9 -87.6
18        811               31107 Wabash Ave & Grand Ave                 41.9 -87.6
19        144               29736 Kingsbury St & Kinzie St               41.9 -87.6
20        871               28378 LaSalle St & Illinois St               41.9 -87.6
21        971               27989 New St & Illinois St                   41.9 -87.6
22        162               27064 Sheffield Ave & Waveland Ave           41.9 -87.7
23        960               26798 Clark St & Newport St                  41.9 -87.7
24        301               26567 DuSable Lake Shore Dr & Diversey Pkwy  41.9 -87.6
25        949               26412 McClurg Ct & Ohio St                   41.9 -87.6
```

I was a little concerned when I saw the lat and long with only 3
significant digits, but I checked, that's just R deciding to be too
smart for it's own good. There is a real problem though, Streeter Dr &
Grand Ave is a big tourist area near Navy Pier. Unfortunately not near
enough.

```R
> 
> library(geosphere)
> distances <- distHaversine(
+     matrix(c(streeter_coords$long, streeter_coords$lat), nrow=1),
+     matrix(c(attractions_df$long, attractions_df$lat), ncol=2)
+ )
> 
> closest_idx <- which.min(distances)
> closest_attraction <- attractions_df[closest_idx, ]
> 
> closest_attraction
       Name      lat      long
1 Navy Pier 41.89198 -87.60512
> 
> # Distance in meters to the closest attraction
> closest_distance_meters <- distances[closest_idx]
> 
> closest_distance_meters
[1] 574.9555
```

Since the aim is to exclude tourist we'll have to recalculate the
non-tourist stations with a bigger radius, say 600.

```R
> find_nearby_stations <- function(attraction, stations, radius = 600) {
+     print(attraction)  # or print(attraction[c("long", "lat")])
+     
+     coords <- as.numeric(unlist(attraction[c("long", "lat")]))
+     
+     distances <- distHaversine(
+         matrix(c(stations$long, stations$lat), ncol = 2),
+         coords
+     )
+     
+     nearby <- stations[distances <= radius, ]
+     nearby$distance_m <- distances[distances <= radius]
+     nearby$attraction <- attraction$name
+     return(nearby)
+ }
> 

> nearby_stations_df <- bind_rows(nearby_stations_list)
> View(nearby_stations_df)
> # Add a unique attraction ID column if it doesn't exist
> attractions_df <- attractions_df %>%
+     mutate(attraction_id = row_number())
> 
```

Well that didn't seem to work

```R
> nearby_stations_df <- bind_rows(nearby_stations_list)
> attractions_df <- attractions_df %>%
+     mutate(attraction_id = row_number())
> 
> all_station_attraction_pairs <- expand.grid(
+     station_id = stations_df$station_id,
+     attraction_id = attractions_df$attraction_id
+ ) %>%
+     left_join(stations_df, by = "station_id") %>%
+     left_join(attractions_df, by = "attraction_id") %>%
+     rowwise() %>%
+     mutate(
+         distance = distHaversine(
+             c(long.x, lat.x),  # station longitude and latitude
+             c(long.y, lat.y)   # attraction longitude and latitude
+         )
+     ) %>%
+     ungroup()
> 

> stations_near_attractions <- all_station_attraction_pairs %>%
+     filter(distance <= 600) %>%
+     distinct(station_id)
> 

> non_tourist_stations_df <- stations_df %>%
+     filter(!station_id %in% stations_near_attractions$station_id)
> 
> non_tourist_station_ids <- non_tourist_stations_df$station_id

> station_ids_sql <- paste0("'", non_tourist_station_ids, "'", collapse = ",")
> 
> ride_query <- sprintf("
+   SELECT
+     start_station_id AS station_id,
+     COUNT(*) AS customer_ride_count
+   FROM rides
+   WHERE user_type = 1
+     AND (start_station_id IN (%s) OR end_station_id IN (%s))
+     AND start_time >= strftime('%%s', '2023-01-01')
+   GROUP BY station_id
+ ", station_ids_sql, station_ids_sql)
> 
> top_non_tourist_stations <- dbGetQuery(con, ride_query)
> 
> top_non_tourist_stations_named <- top_non_tourist_stations %>%
+     inner_join(stations_df, by = c("station_id" = "station_id")) %>%
+     arrange(desc(customer_ride_count)) %>%
+     slice(1:25)
> 

> ggplot(top_non_tourist_stations_named, aes(
+     x = reorder(name, customer_ride_count),
+     y = customer_ride_count
+ )) +
+     geom_col(fill = "steelblue") +
+     coord_flip() +
+     labs(
+         title = "Top 25 Non-Tourist Stations by Customer Ride Count",
+         x = "Station",
+         y = "Customer Rides"
+     ) +
+     theme_minimal()
> 

> library(broom)

> 
> rides_by_hour_weekpart <- non_tourist_customer_rides_df %>%
+     mutate(hour = lubridate::hour(start_localtime),
+            week_part = ifelse(lubridate::wday(start_localtime) %in% c(1, 7), "Weekend", "Weekday")) %>%
+     group_by(week_part, hour) %>%
+     summarise(ride_count = n(), .groups = "drop")
> 
> # Reshape to wide format
> ride_matrix <- rides_by_hour_weekpart %>%
+     tidyr::pivot_wider(names_from = week_part, values_from = ride_count, values_fill = 0) %>%
+     dplyr::select(-hour) %>%
+     as.matrix()
> 
> # Chi-squared test
> chisq.test(ride_matrix)

        Pearson's Chi-squared test

data:  ride_matrix
X-squared = 60205, df = 23, p-value < 0.00000000000000022

> 
> 
> test_result <- chisq.test(ride_matrix)
> test_result$stdres  # > 2 or < -2 = significant
         Weekday    Weekend
 [1,] -71.844546  71.844546
 [2,] -73.291835  73.291835
 [3,] -56.593753  56.593753
 [4,] -34.191684  34.191684
 [5,] -11.738460  11.738460
 [6,]  22.900259 -22.900259
 [7,]  53.279627 -53.279627
 [8,]  70.228256 -70.228256
 [9,]  51.817942 -51.817942
[10,] -21.645537  21.645537
[11,] -61.023978  61.023978
[12,] -66.175146  66.175146
[13,] -59.810369  59.810369
[14,] -61.011944  61.011944
[15,] -55.878725  55.878725
[16,] -32.507914  32.507914
[17,]  14.188421 -14.188421
[18,]  78.648946 -78.648946
[19,]  71.621491 -71.621491
[20,]  49.857611 -49.857611
[21,]  35.174389 -35.174389
[22,]  33.444644 -33.444644
[23,]  26.248129 -26.248129
[24,]   6.189778  -6.189778
> 

> ride_props <- rides_by_hour_weekpart %>%
+     group_by(week_part) %>%
+     mutate(prop = ride_count / sum(ride_count))
> 
> ggplot(ride_props, aes(x = hour, y = week_part, fill = prop)) +
+     geom_tile() +
+     scale_fill_gradient(low = "white", high = "darkorange") +
+     labs(
+         title = "Non-Tourist Proportion of Daily Rides by Hour and Day Type",
+         x = "Hour of Day",
+         y = "Day Type",
+         fill = "Ride Proportion"
+     ) +
+     theme_minimal()
> 

> prop_wide <- ride_props %>%
+     select(hour, week_part, prop) %>%
+     tidyr::pivot_wider(names_from = week_part, values_from = prop) %>%
+     mutate(diff = Weekday - Weekend)
> 
> ggplot(prop_wide, aes(x = hour, y = 1, fill = diff)) +
+     geom_tile() +
+     scale_fill_gradient2(low = "orange", high = "blue", mid = "white", midpoint = 0) +
+     labs(
+         title = "Difference in Ride Proportions: Weekday - Weekend",
+         x = "Hour of Day",
+         y = NULL,
+         fill = "Weekday > Weekend"
+     ) +
+     theme_minimal()
> 
> # Pivot wider, then compute difference
> prop_wide <- ride_props %>%
+     select(hour, week_part, prop) %>%
+     tidyr::pivot_wider(names_from = week_part, values_from = prop) %>%
+     mutate(diff = Weekday - Weekend)
> 
> ggplot(prop_wide, aes(x = hour, y = 1, fill = diff)) +
+     geom_tile() +
+     scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
+     labs(
+         title = "Difference in Ride Proportions: Weekday - Weekend",
+         x = "Hour of Day",
+         y = NULL,
+         fill = "Weekday > Weekend"
+     ) +
+     theme_minimal()
> 
```

That was kind of disappointing, expected to see a stronger case for
commuters than we did. Oh well on to take a look at the duration of
these non-tourist rides. But first a little cleanup that data frame is
getting bloated.

```R
> non_tourist_customer_rides_df$hour_utc <- NULL 
> non_tourist_customer_rides_df$start_datetime_utc <- NULL 
> non_tourist_customer_rides_df$start_datetime <- NULL 
> non_tourist_customer_rides_df$month <- NULL 
```

Now let's add the ride duration in minutes.

```R
> non_tourist_customer_rides_df <- non_tourist_customer_rides_df %>%
+     mutate(
+         ride_length_min = (end_time - start_time) / 60
+     )
> 
```

Since we know the only a few outliers rides are longer than 200 minutes
and the 1 minute rides are probably noise

> non_tourist_customer_rides_df <- non_tourist_customer_rides_df %>%
+     filter(ride_length_min > 1, ride_length_min < 200)
> 
> 
> non_tourist_customer_rides_df <- non_tourist_customer_rides_df %>%
+     filter(ride_length_min < 150)
> 
> 
> ggplot(non_tourist_customer_rides_df, aes(x = ride_length_min)) +
+     geom_histogram(binwidth = 5, fill = "darkorange", color = "white") +
+     labs(
+         title = "Non-Tourist Customer Ride Duration Distribution",
+         x = "Ride Length (minutes)",
+         y = "Number of Rides"
+     ) +
+     theme_minimal()
> 
```

We can probably go down to 150 for these

```R
> 
> non_tourist_customer_rides_df <- non_tourist_customer_rides_df %>%
+     filter(ride_length_min < 150)
> 
> 
> ggplot(non_tourist_customer_rides_df, aes(x = ride_length_min)) +
+     geom_histogram(binwidth = 5, fill = "darkorange", color = "white") +
+     labs(
+         title = "Non-Tourist Customer Ride Duration Distribution",
+         x = "Ride Length (minutes)",
+         y = "Number of Rides"
+     ) +
+     theme_minimal()
> 
```

A smoother option

```R
> ggplot(non_tourist_customer_rides_df, aes(x = ride_length_min)) +
+     geom_density(fill = "darkorange") +
+     labs(
+         title = "Non-Tourist Customer Ride Duration Density",
+         x = "Ride Length (minutes)",
+         y = "Density"
+     ) +
+     theme_minimal()
```

Now let's break it down by weekday vs weekend.

```R
> ggplot(non_tourist_customer_rides_df, aes(x = ride_length_min, fill = week_part)) +
+     geom_density(alpha = 0.4) +
+     scale_fill_manual(values = c("Weekday" = "darkblue", "Weekend" = "darkorange")) +
+     labs(
+         title = "Non-Tourist Customer Ride Duration by Weekday vs Weekend",
+         x = "Ride Length (minutes)",
+         fill = "Day Type"
+     ) +
+     theme_minimal()
> 
```


Did we look at the overall rides per year yet?  I think we missed that one.

```SQL
sqlite> select strftime('%Y', start_time, 'unixepoch') as year, count(*) from rides group by year order by year;
```
```text
year  count(*)
----  --------
2013  689166  
2014  2370692 
2015  3000567 
2016  3312541 
2017  3554074 
2018  3448207 
2019  3703245 
2020  340     
2023  3149595 
2024  4428327 
2025  729811  
```
