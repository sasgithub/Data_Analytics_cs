### Hourly rides vs. temperature

<figure class="float-right">
  <a href="../Hourly_Rides_vs_Temp.svg" target="_blank" title="Select image to open full sized chart">
  <img src="../Hourly_Rides_vs_Temp.svg" alt="A Graph showing the total rides per hour vs temperature, with lines for total rides, subscriber rides and Customer rides.">
  </a>
  <figcaption>
  This graph show the number of rides starting at a given at a given temperature.  Temperature data is recorded hourly.
  </figcaption>
</figure>



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
