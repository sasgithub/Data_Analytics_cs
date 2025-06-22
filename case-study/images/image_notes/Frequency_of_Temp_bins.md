## Frequency of Temperature Bins

<figure class="float-right">
  <a href="../Frequency_of_Temp_bin.png" target="_blank" title="Select image to open full sized chart">
  <img src="../thumbnail/Frequency_of_Temp_bin.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>




```R
ggplot(aes(x = temp_bin, y = n)) +
  geom_col(fill = "gray") +
  labs(title = "Frequency of Temperature Bins", x = "Temp (°C)", y = "Hours Observed")
```

