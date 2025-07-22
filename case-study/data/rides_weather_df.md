#### `rides_weather_df`

**Type:** R Data Frame

**Description**
Combines hourly ride counts with corresponding weather data by user type. Includes fields like temperature, humidity, and precipitation. Used to explore weather impacts on ride volume through binning, summaries, and LOESS-smoothed visualizations.

**Data Origin:**  
Derived directly from the `rides_weather` view in the SQLite database.

**View Definition Recap (`rides_weather`):**  
This view joins hourly weather observations to hourly ride counts:  
- **Left Join:** `hourly_weather` (hourly measurements)  
- **Left Join Target:** `rides_per_hour` (hourly ride counts by user type)  
- **Columns Selected:**  
  - `epoch` (UTC seconds)  
  - `user_type` (`0=Subscriber`, `1=Customer`)  
  - `rides` (hourly ride count)  
  - `temp` (temperature °C)  
  - `dwpt` (dewpoint °C)  
  - `rhum` (relative humidity %)  
  - `prcp` (precipitation mm)  
  - `wdir` (wind direction °)  
  - `wspd` (wind speed m/s)  
  - `coco` (weather condition code)

**How Imported:**  
Although no explicit import code was found in the logs, usage patterns strongly indicate it was loaded using a direct table read in R, for example:  

```r
rides_weather_df <- dbReadTable(con, "rides_weather")
```

or

```r
rides_weather_df <- dbGetQuery(con, "SELECT * FROM rides_weather")
```

**Usage in Analysis:**
This dataframe was used as the basis for:

  -  Binning temperatures (floor(temp/2)*2) to create temperature histograms and line plots
  -  Labeling precipitation conditions (Dry, Wet, No data)
  -  Summarising rides by temperature and precipitation bins
  -  Producing LOESS-smoothed plots of ride volume by temperature

