### Average Hourly Rides vs. Temperature

This chart illustrates the relationship between **ambient temperature (°C)** and the **average number of rides per hour**, with data grouped into **2°C bins** to smooth short-term fluctuations and reveal broader trends..

- The **x-axis** shows temperature in degrees Celsius.
- The **y-axis** displays the average number of rides per hour, formatted with metric suffixes (e.g., 1k, 1m, etc).
- Grid lines and a clear legend outside the plot area aid interpretability.

Three ride categories are plotted:

- **Total Rides** (all users)
- **Subscribers** (dark blue line)
- **Customers** (dark orange line)

#### Insights:

- Bike usage increases with warmer weather, peaking for both Subscribers and Customers at 26°C (78.8∘F) temperatures, after which it falls off sharplybe.
- **Subscribers** tend to be less dependant on temperature range (correlation coefficient **VALUE** compared to **VALUE** for Customers), but sill follow the same basic pattern.
- **Customers** show a sharper increase in usage with warmth, indicating stronger sensitivity to weather.

These trends can inform operational decisions and user engagement strategies, particularly around marketing and bike redistribution efforts during seasonal changes.

Below is the the SQL command used to gather data for this chart.


```gnuplot
set title "Average Hourly Rides vs. Temperature (2°C Bins)"
set xlabel "Temperature (°C)"
set ylabel "Average Rides per Hour"
set datafile separator '\t'
set term wxt
set grid
set key outside
set format y "%.0f"
plot \
>    "temp_vs_rides.tsv" every ::35::68 using 1:2 with lines lw 2 lc rgb "black" title "Avg Total", \
    "" every ::35::68 using 1:3 with lines lw 2 lc rgb "dark-blue" title "Avg Subscribers", \
    "" every ::35::68 using 1:4 with lines lw 2 lc rgb "dark-orange" title "Avg Customers"
plot \
    "temp_vs_rides.tsv" every ::35::68 using 1:2 with lines lw 2 lc rgb "black" title "Avg Total", \
    "" every ::35::68 using 1:3 with lines lw 2 lc rgb "dark-blue" title "Avg Subscribers", \
    "" every ::35::68 using 1:4 with lines lw 2 lc rgb "dark-orange" title "Avg Customers"
```

'''SQL

```

