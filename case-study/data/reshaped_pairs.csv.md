#### `reshaped_pairs.csv`

**Type:** CSV File

**Description**

This dataset was created by reshaping aggregated station-to-station ride counts to support Tableau visualizations of directional flows.

**Generation Steps:**

1. **Base File (`station_pairs.csv`):**
   - Each row contained:
     - Two stations: A and B, including their names and coordinates.
     - Aggregated counts:
       - `total_rides`: Combined rides in both directions.
       - `subscriber_rides`: Rides by subscribers.
       - `customer_rides`: Rides by customers.

2. **Reshaping Logic:**
   - Used `awk` to split each row into **two rows**, one for each station in the pair:
     - The first output row corresponds to Station A (`path_id = 1`).
     - The second output row corresponds to Station B (`path_id = 2`).
   - All ride counts were retained identically in both rows to enable Tableau to reconstruct paths by matching `path_id`.

3. **Final Columns:**
   - `station_name`: Name of one station in the pair.
   - `lat`: Latitude of the station.
   - `lon`: Longitude of the station.
   - `total_rides`: Total rides between the two stations.
   - `subscriber_rides`: Subscriber rides between the two stations.
   - `customer_rides`: Customer rides between the two stations.
   - `path_id`: Unique identifier to group the two records back into a path.

4. **Output:**
   - Saved to [`reshaped_pairs.csv`](reshaped_pairs.csv).

**Purpose:**

- Used as the **primary input to Tableau** to visualize:
  - Ride volumes between station pairs.
  - Directional flows.
  - Customer vs. subscriber usage patterns.

**Example:**

If `station_pairs.csv` contained:

Station A, 41.88, -87.63, Station B, 41.89, -87.64, 500, 300, 200

The `awk` command would produce **two rows in `reshaped_pairs.csv`**:

Station A,41.88,-87.63,500,300,200,1
Station B,41.89,-87.64,500,300,200,2


