Provenance for non_loop_rides_df
🟢 1️⃣ Start with non_tourist_customer_rides_df

    This already had:

        Only customer rides

        Only non-tourist stations (presumably filtered upstream)

🟢 2️⃣ Filter out loop rides

non_loop_rides_df <- non_tourist_customer_rides_df %>%
  filter(start_station_id != end_station_id)

✅ Result:

    Only rides starting and ending at different stations

🟢 3️⃣ Attach start and end station coordinates from stations_df

non_loop_rides_df <- non_loop_rides_df %>%
  left_join(
    stations_df %>% rename(
      start_station_id = station_id,
      start_lat = lat,
      start_long = long
    ),
    by = "start_station_id"
  ) %>%
  left_join(
    stations_df %>% rename(
      end_station_id = station_id,
      end_lat = lat,
      end_long = long
    ),
    by = "end_station_id"
  )



✅ Result:

    Added start and end lat/lon

    Computed haversine distance

🟢 4️⃣ (Apparently rejoined different station metadata)




🟢 4️⃣  Recompute distance

non_loop_rides_df <- non_loop_rides_df %>%
  mutate(
    distance_m = distHaversine(
      matrix(c(start_long, start_lat), ncol = 2),
      matrix(c(end_long, end_lat), ncol = 2)
    ),
    distance_km = distance_m / 1000
  )

✅ Result:

    Recomputed distance_m and distance_km using (start_long, start_lat) instead of (start_lon, start_lat)


