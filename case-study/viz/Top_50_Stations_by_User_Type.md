#### Top 50 Stations by User Type

<figure class="float-right" id="fig1">
  <a href="Top_50_Stations_by_User_Type.html" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/thumbnail_top_50_stations.png" alt="Map of Top 50 Stations by User Type">
  </a>
  <figcaption>
  Figure 1: Top 50 stations for Subscribers (blue) and Customers (red). Dot size scales with ride count.
  </figcaption>
</figure>

##### Overview  

This interactive map of the top 50 stations includes the top 50 stations by number of Subscriber rides and the top 50 stations by number of Customer rides. We break from the normal color scheme as more contrast was required due to the preexisting colors in the map. So the dots for Subscriber stations rendered in <span style="color: blue;">blue</span> and the dots for Customer stations rendered in <span style="color: red;">red</span>. The dots for stations are offset slightly to avoid one dot obscuring the other for the cases where the station is in the top 50 for both Subscribers and Customers. This is accomplished by using a data frame where the location of the stations is offset. The size of the dots is scaled by the total number of rides (Subscriber or Customer as appropriate), so that stations with more rides are larger dots.

##### Chart Details

- **Blue dots** represent stations ranked in the top 50 for **Subscriber rides**.
- **Red dots** represent stations ranked in the top 50 for **Customer rides**.
- Dots are **offset slightly** to avoid overlap in cases where a station ranks in the top 50 for both groups.
- **Circle size** is proportional to the total ride volume of each station.
- A pop-up displays station name, rank, user type, and formatted ride count.

##### Observations

- Some stations appear prominently for both user types, indicating shared high-traffic locations.
- Certain clusters (particularly in tourist-heavy or commuter-focused areas) are strongly associated with one user group.
- A visual concentration of Customer stations appears near popular attractions.

##### Interpretation

The visualization underscores behavioral differences between Subscribers (likely commuters or regular riders) and Customers (potentially tourists or occasional users). Identifying these patterns supports targeted operational decisions, such as bike rebalancing and station expansion.

##### Use Case

This map can be used by:
- **Transportation planners** to prioritize infrastructure improvements.
- **Marketing teams** to develop user-segmented promotions.
- **Operations teams** to allocate resources efficiently based on demand hotspots by user type.

##### Technical Notes

- To create the **offset effect**, longitude coordinates were shifted slightly in the data frame (`long_offset`).
- Circle radius was scaled using the square root of ride counts to moderate the impact of extreme outliers.
- A custom color palette was applied for improved contrast against the base map.
- The visualization was generated using the **leaflet** R package.

##### Data Sources

- **Divvy Trip Data**: Chicago open data portal
- **Station Metadata**: Divvy station reference dataset
- Data preprocessed and aggregated to compute ride counts per station and user type.

##### R Code Used to Generate Chart:

```r
library(leaflet)
library(RColorBrewer)

# Color palette safer for colorblind accessibility
pal <- colorFactor(
    palette = c("#377eb8", "#e41a1c"),
    domain = top_stations_df_offset$user_type
)

# Scaling constant for circle radius
scale_factor <- 0.05

leaflet(top_stations_df_offset) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addCircleMarkers(
        lng = ~long_offset,
        lat = ~lat,
        color = ~pal(user_type),
        radius = ~pmax(sqrt(ride_count) * scale_factor, 4),
        stroke = TRUE,
        weight = 1,
        opacity = 1,
        fillOpacity = 0.8,
        popup = ~paste0(
            "<b>", name, "</b><br>",
            "Rank: #", rn, "<br>",
            "User Type: ", user_type, "<br>",
            "Ride Count: ", format(ride_count, big.mark = ",")
        )
    ) %>%
    addLegend(
        position = "bottomright",
        pal = pal,
        values = ~user_type,
        title = "User Type",
        opacity = 1
    )
```

The author created a tutorial using this visualization as an example.  More details are available on [Kaggle](https://www.kaggle.com/code/yaid2r/top-stations-leaflet-demo/)

