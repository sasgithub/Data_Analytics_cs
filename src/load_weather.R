#!/usr/bin/env Rscript

# Load libraries
library(dplyr)
library(readr)
library(lubridate)
library(DBI)
library(RSQLite)

# Paths (modify as needed)
csv_file <- "data/midway_weather.csv"
sqlite_db <- "data/caseStudy.db"

# Manually assign column names (Meteostat bulk CSV lacks header row)
col_names <- c(
  "date", "hour", "temp", "dwpt", "rhum", "prcp", "snow",
  "wdir", "wspd", "wpgt", "pres", "tsun", "coco"
)

# Load data
df <- read_csv(csv_file, col_names = col_names)

# Drop unused columns
df_clean <- df %>%
  select(date, hour, temp, dwpt, rhum, prcp, wdir, wspd, coco)

# Combine date and hour into a proper datetime, then convert to epoch (UTC)
df_clean <- df_clean %>%
  mutate(
    datetime = ymd_h(paste(date, hour)),
    epoch = as.integer(as.POSIXct(datetime, tz = "UTC"))
  ) %>%
  select(epoch, temp, dwpt, rhum, prcp, wdir, wspd, coco) %>%
  arrange(epoch)

# Connect to SQLite and write table
con <- dbConnect(RSQLite::SQLite(), sqlite_db)

# Create schema if needed
dbExecute(con, "
  CREATE TABLE IF NOT EXISTS hourly_weather (
    epoch INTEGER PRIMARY KEY,
    temp REAL,
    dwpt REAL,
    rhum INTEGER,
    prcp REAL,
    wdir INTEGER,
    wspd REAL,
    coco INTEGER
  )
")

# Insert data
dbWriteTable(con, "hourly_weather", df_clean, append = TRUE, row.names = FALSE)

# Clean up
dbDisconnect(con)
cat("Weather data loaded and written to SQLite.\n")


