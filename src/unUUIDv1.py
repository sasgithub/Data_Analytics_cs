#
# author: sas
# purpose:  extracts info from a UUID
#   Takes a UUID v1 string as input (via the command line).
#   Extracts the timestamp and the MAC address embedded within the UUID.
#   Optionally looks up the MAC address to determine its vendor using an online API.
#   Outputs the UUID string, the extracted timestamp, the MAC address, and the MAC vendor.


import uuid
import datetime
import requests
import sys

def parse_uuid_v1(u_str):
    u = uuid.UUID(u_str)
    if u.version != 1:
        raise ValueError("Not a version 1 UUID")

    # Extract timestamp
    timestamp_100ns = u.time
    timestamp = datetime.datetime(1582, 10, 15) + datetime.timedelta(microseconds=timestamp_100ns / 10)

    # Extract MAC address
    node = u.node
    mac = ':'.join(f'{(node >> ele) & 0xff:02x}' for ele in range(40, -1, -8))

    return timestamp, mac

def lookup_mac_vendor(mac):
    # lots of stuff uses random MAC addresses these days, so this might be a waste of time
    url = f"https://api.maclookup.app/v2/macs/{mac}"
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            data = response.json()
            return data.get('company', 'Vendor not found')
        else:
            return "Vendor not found"
    except requests.RequestException:
        return "Error during vendor lookup"

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 unUUIDv1.py <uuid>")
        sys.exit(1)

    uuid_str = sys.argv[1]
    try:
        timestamp, mac = parse_uuid_v1(uuid_str)
        print(f"UUID:      {uuid_str}")
        print(f"Timestamp: {timestamp}")
        print(f"MAC Addr:  {mac}")
        vendor = lookup_mac_vendor(mac)
        print(f"Vendor:    {vendor}")
    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)
