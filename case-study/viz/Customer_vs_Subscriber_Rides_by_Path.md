### Sheet 2: Customer vs. Subscriber Rides by Path (Histogram)

<figure class="float-right" id="fig3">
  <a href="https://public.tableau.com/app/profile/scott.sesher/viz/GoogleDataAnalyticsCaseStudy_17480226880920/Sheet2" target="_blank" title="Select image to open interactive Tableau Visualization">
  <img src="../images/thumbnails/tableau_thumb_sheet2.png" alt="Horizontal bar chart showing the sum of subscriber rides (blue) and customer rides (orange) by top ride paths.">
  </a>
  <figcaption>
  Figure 3: Comparison of Customer vs. Subscriber Rides by Path. This horizontal bar chart visualizes the total number of rides by customer type (subscribers in blue, casual customers in orange) for the top ride paths. It highlights differences in route preferences and ride volumes between the two user segments. 
  </figcaption>
</figure>

#### Overview
A horizontal bar chart comparing ride counts for the 88 most-traveled station-to-station paths (≥10,000 rides each), split by rider type.

#### Chart Details
- **X-Axis**: Number of rides (stacked bar segments)
- **Y-Axis**: Individual station-to-station ride paths
- **Other Elements**: Bars colored by rider type (blue = Subscriber, orange = Customer)

#### Purpose
To show how ride volumes and route preferences differ between Subscribers and Customers on the most popular paths.

#### Observations
- Some paths are overwhelmingly dominated by Subscribers, suggesting daily commute patterns.
- Others show more balanced or Customer-heavy traffic, often around tourist areas.
- The longest bars are generally Subscriber-heavy, reinforcing the commuter narrative.

#### Interpretation
Subscriber ride patterns favor longer, distributed paths, likely associated with work commutes. Customers cluster on fewer, more localized tourist routes.

#### Data & Methods
- **Data Source:** [`reshaped_pairs.csv`](../data/provenance.qmd#reshaped_pairs-csv)
  This reshaped dataset supports directional visualization of paired stations. See the data provenance document for generation steps and structure.
- **Path Aggregation**: Filtered to include only paths with ≥10,000 rides; grouped and counted by user type.
- **Visualization Tool**: Tableau was used to create the histogram with interactive sorting and tooltips.

