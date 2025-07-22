#### `peak_df`

**Type:** R Data Frame

**Description**
`peak_df` highlights the key distance values where the density of rides is locally maximized, helping to identify common ride distance modes or popular trip length clusters in the dataset.

**Data Origin:**  
Derived from the `density_df` data frame, which contains kernel density estimates of bike ride distances (`x` for distance in km, `y` for density values).

**Transformation Details:**  
- The `find_peaks()` function was applied to the `y` values of `density_df` to identify local maxima (peaks) in the density distribution.  
- The resulting indices (`peak_indices`) correspond to positions in `density_df` where the density reaches a local peak.  
- `peak_df` is a subset of `density_df` containing only the rows at these peak positions.

