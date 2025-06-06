

```R
set title "Average hourly rides vs. temperature"
set xlabel "Temperature (°C)"
set ylabel "Average rides per hour"
set grid
set key off


# smoothed curve (Cubic Spline)
plot "temp_vs_rides.dat" using 1:2 smooth csplines lw 2
```


