## Ride Distance Distribution by Duration Cluster (Non-Tourist, Non-Loop, Customers)

<figure class="float-right">
  <a href="../images/Non-Tourist_Non-Loop_Customer_Ride_Distance_Distribution_by_Ride_Duration_Cluster.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Non-Loop_Customer_Ride_Distance_Distribution_by_Ride_Duration_Cluster.png" alt="Density plot showing the distribution of ride distances in kilometers for non-tourist, non-loop customer rides, grouped into Short, Medium, and Long duration clusters. Short rides peak around 1–2 km, Medium rides span 2–6 km, and Long rides extend beyond 6 km.">
  </a>
  <figcaption>
   Ride Distance Distribution by Duration Cluster (Customer Rides Only)
This density plot compares ride distances for non-tourist, non-loop customer rides, grouped into clusters based on ride duration. Short-duration rides are tightly concentrated around 1–2 km, medium-duration rides cover a broader 2–6 km range, and long-duration rides extend further, reflecting distinct usage behaviors within the same user group.
  </figcaption>
</figure>

### Overview
This kernel density plot illustrates the distribution of **ride distances** (in kilometers) for **non-tourist, non-loop customer rides**, broken out by **ride duration clusters** labeled as Short, Medium, and Long.

### Axes

- **X-Axis (Distance in km)**:
  - Ranges from 0 to 10 km.
  - Represents the straight-line distance from the start stations to the end stations (the minimum possilbe distatnce covered). Do not confuse this with the actual distance ridden, we have no way of knowing that from the currently available data.

- **Y-Axis (Density)**:
  - Represents the probability density of ride distances within each cluster.
  - Higher peaks indicate more common distances in that cluster.

### Cluster Colors

- **Short (Blue)**:
  - Peaks sharply between 0.5–2.5 km.
  - Characterized by high density at shorter distances and a quick drop-off after 3 km.

- **Medium (Green)**:
  - Peaks broadly from ~2.5 km to 6 km.
  - Forms a wider and flatter distribution, indicating greater variability in ride lengths.

- **Long (Red/Pink)**:
  - Starts lower but maintains a relatively even presence across 3–10 km.
  - Longest tail, with density extending up to the maximum distance shown (10 km).

### Observations

- **Short Cluster**:
  - Highest density of all clusters.
  - Indicates that most customer rides classified as “short” are under 3 km.
  - May reflect last-mile or station-to-neighborhood travel.

- **Medium Cluster**:
  - Broadest range of distances.
  - Overlaps with both short and long clusters, suggesting transitional ride behavior.

- **Long Cluster**:
  - Less frequent but not rare.
  - Ride distances in this group begin at approximatley 1.5 km and extend up to 10 km.
  - Possibly includes destination-oriented or special-purpose trips.

### Interpretations

- **Behavioral Insights**:
  - The sharp peak of the short cluster implies highly consistent short-distance use, likely for errands or short hops.
  - The medium cluster suggests a flexible usage pattern, potentially including both commuting and recreational trips.
  - Long-duration rides, although less common, cover the widest distance range, reflecting diverse travel purposes.

- **Data Characteristics**:
  - Rides were filtered to exclude tourist, subscribers and loop rides, increasing the likelihood that these reflect **practical** customer travel behavior (e.g., commuting, errands).
  - Clustering these customer rides by duration helps uncover distinct usage patterns — such as short errand-like trips versus longer recreational journeys — without needing to segment riders any further or rely on additional metadata.

### Use Case

This chart helps:
- Understand ride behavior by duration across distance ranges.
- Support clustering-based segmentation strategies.
- Inform infrastructure placement, pricing models, or service design for non-tourist use cases.

