#### asym_data

**Type:** R Data Frame

**Description**
Summary of directional ride asymmetry between station pairs. Each row includes ride counts in both directions and an asymmetry ratio.

**Data Origin**  
Loaded from the CSV file `asymmetry.csv`, which was generated as a summary of directional ride imbalances between pairs of stations.

**How Created**  
Read directly into R using `readr::read_csv()`:

**Purpose and Use in Analysis**

-  Provides counts of rides in each direction between pairs of stations.
-  Used to compute asymmetry ratios and identify directional imbalances in station-to-station flows.
-  Supports visualizations and prioritization of locations with high directional skew.

**Columns**

-   user_type_label: Label for the user type (subscriber or customer).
-   station_a_name: Name of the origin station.
-   station_b_name: Name of the destination station.
-   count_ab: Number of rides from A to B.
-   count_ba: Number of rides from B to A.
-   diff: Absolute difference in counts.
-   total: Sum of rides in both directions.
-   asymmetry_ratio: Proportion of rides in the more frequent direction.

```r
asym_data <- read_csv("/home/sas/classes/Google/data-analytics/data/asymmetry.csv")
```
