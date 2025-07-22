#### prop_df

**Type:** R Data Frame

**Description**
Provides the *within-week part distribution* of ride frequency over the day, enabling comparisons of riding patterns between weekdays and weekends on a relative scale.

**Provenance:**  
Derived directly from `rides_by_hour_weekpart`, which summarizes the hourly count of non-tourist customer rides split by "week part" (Weekday or Weekend).  

**Transformation Steps:**  

- **Grouping:** Data is grouped by `week_part` (`Weekday` / `Weekend`).  
- **Computation:** For each hour within each group, a proportional share of rides (`prop`) is calculated:  

  \[
  \text{prop} = \frac{\text{ride_count}}{\sum(\text{ride_count for that week part})}
  \]
- This yields the fraction of total rides in each week part that occur in each hour.


**Example Columns:**  

- `week_part`: Weekday or Weekend  
- `hour`: Hour of the day (0–23)  
- `ride_count`: Raw ride counts from `rides_by_hour_weekpart`  
- `prop`: Proportion of rides within each `week_part`

