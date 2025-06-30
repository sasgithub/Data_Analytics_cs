### Import
```r
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
> df <- df %>% select(-tsun)
> df$datetime <- as.POSIXct(paste(df$Date, sprintf("%02d:00:00", df$Hour)), format="%Y-%m-%d %H:
%M:%S", tz="UTC")
> df$epoch <- as.integer(df$datetime)
> 
> df <- df[, c("epoch", setdiff(names(df), "epoch"))]
> df <- df %>% select(-Date)
> df <- df %>% select(-Hour)
> df <- df %>% select(-datetime)
 head(df)
       epoch Temp dwpt rhum prcp wdir wspd coco
1 1372291200 27.2 19.3   62    0  270 18.4   NA
2 1372294800 24.4 18.8   71    0   10 16.6   NA
3 1372298400 23.3 18.4   74    0   20 11.2   NA
4 1372302000 23.3 18.4   74    0   30  9.4   NA
5 1372305600 22.8 17.7   73    0   10  5.4   NA
6 1372309200 22.2 18.4   79    0  350  9.4   NA

con <- dbConnect(RSQLite::SQLite(), "/home/sas/classes/Google/data-analytics/data/caseStudy.db")
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
> dbWriteTable(con, "hourly_weather", df, append = TRUE)
```

### Cleaning



