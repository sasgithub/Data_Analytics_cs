### `temp_vs_rides_avg.csv`

**Description:**  
A temperature-binned summary of average hourly ride counts across the study period.

**Source & Processing:**  
- Derived by grouping hourly weather and ride data by temperature bins (`temp_bin`).
- For each bin, the dataset records:
  - `avg`: Average total hourly rides (all users).
  - `subs`: Average hourly rides by subscribers.
  - `cust`: Average hourly rides by customers.
- Binning was performed in 2-degree Celsius increments, ranging from -28°C to +36°C.
- Missing or sparse bins were filled with low or zero values, reflecting limited ridership in extreme temperatures.

**Purpose:**  
Used as the input to generate `normalized_df`, in which all ride counts were normalized to a 0–1 scale for visualization of relative demand across temperatures and user types.

Conveniently Available as [temp_vs_rides_avg.csv](temp_vs_rides_avg.csv) for you importing pleasure.
