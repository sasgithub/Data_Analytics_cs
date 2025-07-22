#### stdres_long

**Type:** R Data Frame

**Description**
Contains standardized residuals from a chi-squared test of hourly ride patterns (weekday vs. weekend). Reformatted to long form for easier visualization and filtering of statistically significant hourly deviations.

**Provenance:**  
Derived from `stdres_df`, which contains standardized residuals from a chi-squared test comparing hourly ride distributions between weekdays and weekends.

**Transformation Steps:**  
- **Reshaping:** Used `pivot_longer()` to convert the wide format residuals into long format:
  - Columns `Weekday` and `Weekend` were gathered into rows.
  - New columns:
    - `week_part`: Weekday or Weekend
    - `std_residual`: The standardized residual value
- This makes the data tidy and easier to filter, plot, or interpret.

**Purpose:**  
Provides a long-form table of standardized residuals, enabling:
- Visualization of deviations from expected ride counts by hour and week part.
- Identification of significantly over- or under-represented hours (residuals > +2 or < –2).

**Example Columns:**
- `hour`: Hour of the day (0–23)
- `week_part`: Weekday or Weekend
- `std_residual`: Chi-squared standardized residual

