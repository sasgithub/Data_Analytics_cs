top_stations_df_offset <- top_stations_df %>%
    mutate(
        long_offset = ifelse(user_type == "subscriber", long - 0.0001, long + 0.0001)
    )
