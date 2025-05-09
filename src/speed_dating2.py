import pandas as pd

# If your CSV has a header row, use column names instead
df = pd.read_csv("Divvy_Trips_20250501.csv", usecols=["START TIME", "STOP TIME"], parse_dates=["START TIME", "STOP TIME"])

# Strip time — keep only the date part
start_dates = df["START TIME"].dt.date
end_dates = df["STOP TIME"].dt.date

# Find earliest and latest across both columns
earliest = min(start_dates.min(), end_dates.min())
latest = max(start_dates.max(), end_dates.max())

print("Earliest:", earliest.strftime("%m/%d/%Y"))
print("Latest:  ", latest.strftime("%m/%d/%Y"))

