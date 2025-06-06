

```R
set title "Average hourly rides vs. temperature"
set xlabel "Temperature (°C)"
set ylabel "Average rides per hour"
set grid
set key off

# Simple connected line
plot "temp_vs_rides.dat" using 1:2 with linespoints lw 2 pt 7
```

