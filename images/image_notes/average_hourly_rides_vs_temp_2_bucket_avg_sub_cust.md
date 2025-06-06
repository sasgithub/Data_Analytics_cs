

```R
set title  "Hourly rides vs. temperature"
set xlabel "Temperature (°C)"
set ylabel "Average rides per hour"
set grid
plot \
    "temp_vs_rides.tsv" using 1:2 with lines lw 2 title "Total", \
    ""                   using 1:3 with lines lw 2 dt 2  title "Subscribers", \
    ""                   using 1:4 with lines lw 2 dt 3  title "Customers"
```
