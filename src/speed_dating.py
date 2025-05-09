import csv

def extract_min_max_dates(filename):
    min_date = None
    max_date = None

    with open(filename, newline='') as f:
        reader = csv.reader(f)
        next(reader)  # skip header
        for row in reader:
            for field_index in [1, 2]:  # start time, end time
                date = row[field_index].split(' ')[0]  # mm/dd/yyyy
                #print("date",date)
                m, d, y = date.split('/')
                compact = f"{y}{m}{d}"
                if compact < min_date or not min_date:
                    min_date = compact
                if compact > max_date or not max_date:
                    max_date = compact

    print("Earliest:", f"{min_date[4:6]}/{min_date[6:]}/{min_date[:4]}")
    print("Latest:  ", f"{max_date[4:6]}/{max_date[6:]}/{max_date[:4]}")

# Usage
extract_min_max_dates("Divvy_Trips_20250501.csv")

