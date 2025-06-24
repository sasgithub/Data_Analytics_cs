#### Frequency of Temperature Bins

<figure class="float-right">
  <a href="../images/Frequency_of_Temp_bins.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Frequency_of_Temp_bins.png" alt="ALT_TEXT">
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

<br style="clear: both;"></br>

