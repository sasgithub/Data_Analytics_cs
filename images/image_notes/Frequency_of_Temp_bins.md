

```R
ggplot(aes(x = temp_bin, y = n)) +
  geom_col(fill = "gray") +
  labs(title = "Frequency of Temperature Bins", x = "Temp (°C)", y = "Hours Observed")
```

