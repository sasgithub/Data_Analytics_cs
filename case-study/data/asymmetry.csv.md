### File: `asymmetry.csv`

**Data Origin**

Derived from the `rides` table in SQLite.

**Generation Process**

- Trips were grouped by:
  - Rider type (`user_type`)
  - Origin station
  - Destination station
- For each station pair `(A,B)` and rider type:
  - Counted rides in both directions (A→B and B→A)
  - Calculated:
    - `diff` (count_ab - count_ba)
    - `total` (count_ab + count_ba)
    - `asymmetry_ratio` (diff / total)

**Purpose**

Supports analysis of directional imbalances in station-to-station traffic, helping to identify:
- Pairs with consistent one-way flows (e.g., commuting corridors)
- Potential rebalancing priorities
- Differences in patterns between subscribers and casual users

*File available at:* [`asymmetry.csv`](../data/asymmetry.csv)

