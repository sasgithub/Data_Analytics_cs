## Hourly Rides vs. Temperature (2°C bins)

<figure class="float-right">
  <a href="../Hourly_Rides_vs_Temp.svg" target="_blank" title="Select image to open full sized chart">
  <img src="../thumbnail/Hourly_Rides_vs_Temp.svg" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>


This chart illustrates the relationship between **ambient temperature (°C)** and the **number of rides** starting at that temperature. Data is grouped into **2°C bins** to smooth short-term fluctuations and reveal broader trends..

- The **x-axis** shows temperature in degrees Celsius.
- The **y-axis** displays the total number of rides per bin, formatted with metric suffixes (e.g., 1k, 1m, etc).
- Grid lines and a clear legend outside the plot area aid interpretability.

Three ride categories are plotted:

- **Total Rides** (all users)
- **Subscribers** (dark blue line)
- **Customers** (dark orange line)

### Insights:

- Bike usage increases with warmer weather, peaking for both Subscribers and Customers at 26°C (78.8∘F) temperatures, after which it falls off sharplybe.
- **Subscribers** tend to be less dependant on temperature range (correlation coefficient **VALUE** compared to **VALUE** for Customers), but sill follow the same basic pattern.
- **Customers** show a sharper increase in usage with warmth, indicating stronger sensitivity to weather.

These trends can inform operational decisions and user engagement strategies, particularly around marketing and bike redistribution efforts during seasonal changes.

Below is the the SQL command used to gather data for this chart. 

```SQL
.headers off
.mode tabs
.output temp_vs_rides.tsv

WITH binned AS (                          -- 2 °C comfort‑oriented buckets
    SELECT
        CAST(temp / 2.0 AS INT) * 2              AS temp_bin,         -- –10,‑8,…,34
        r.user_type,
        SUM(r.rides)                             AS rides
    FROM rides_per_hour_tbl   AS r
    JOIN hourly_weather       AS w  ON w.epoch = r.epoch
    GROUP BY temp_bin, r.user_type
), pivot AS (                             -- turn rows into columns
    SELECT
        temp_bin,
        SUM(rides)                                  AS total,
        SUM(CASE WHEN user_type='subscriber' THEN rides END) AS subs,
        SUM(CASE WHEN user_type='customer'   THEN rides END) AS cust
    FROM binned
    GROUP BY temp_bin
    ORDER BY temp_bin
)
SELECT temp_bin, total, subs, cust
FROM pivot;

.output stdout
```

```gnuplot
set format y "%.0s%c"
set term wxt           
set title "Hourly Rides vs. Temperature"
set xlabel "Temperature (°C)"
set ylabel "Rides per hour"
set grid
set datafile separator '\t'   
set key outside
plot \
    "temp_vs_rides.tsv" every ::1::34 using 1:2 with lines lw 2 lc rgb "black" title "Total", \
    ""      every ::1::34 using 1:3 with lines lw 2 lc rgb "dark-blue" title "Subscribers", \
    ""      every ::1::34 using 1:4 with lines lw 2 lc rgb "dark-orange" title "Customers"
```



