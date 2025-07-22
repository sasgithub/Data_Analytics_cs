#### `top_stations_df_offset`

**Type:** R Data Frame

**Description**

This dataset is a transformed version of [`top_stations_df`](top_stations_df.md) created to help improve visualization clarity when plotting subscriber and customer top stations on the same map.

**Generation Steps**

1. Based on `top_stations_df`, which contains the top 50 stations per user type by ride volume.
2. Applied `mutate()` to create a new column `long_offset`:
   - For **subscribers**: longitude shifted *west* by 0.0001 degrees.
   - For **customers**: longitude shifted *east* by 0.0001 degrees.
3. This offset avoids overlapping station markers in visualizations, making it easier to see the distribution of user types.

**Purpose**

Facilitates clearer, less cluttered maps showing both user groups’ station popularity side by side.

**Key Columns:**

- `station_id`
- `name`
- `lat`
- `long`
- `user_type`
- `ride_count`
- `rn`
- `long_offset`

```r
top_stations_df_offset <- top_stations_df %>%
    mutate(
        long_offset = ifelse(user_type == "subscriber", long - 0.0001, long + 0.0001)
    )
```
