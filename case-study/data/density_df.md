## Provenance: `density_df`

**Data Origin:**

Derived from the `non_loop_rides_df` data frame, which contains filtered bike rides excluding loops, limited to casual riders, non-tourist stations, and rides starting from 2023-01-01. The relevant column used is `distance_km`, representing the ride distances in kilometers.

**Transformation Details:**

- The R `density()` function was applied to the `distance_km` column to estimate the kernel density of ride distances.  
- `na.rm = TRUE` ensures missing values are excluded from the calculation.  
- The resulting density estimate (`density_data`) contains vectors `x` (distance values) and `y` (estimated density values).  
- These vectors were combined into a data frame with columns:
  - `x`: distance values (km)  
  - `y`: corresponding estimated density values

**Purpose:**  
The `density_df` data frame provides a smooth estimate of the distribution of ride distances, which can be used for visualizations such as density plots to understand the continuous frequency pattern of trip lengths in the dataset.

