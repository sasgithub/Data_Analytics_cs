package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	file, err := os.Open("Divvy_Trips_20250501.csv")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	var minDate, maxDate string
	first := true

	// Skip the header
	if scanner.Scan() {
		// do nothing, skip first line
	}

	for scanner.Scan() {
		line := scanner.Text()
		fields := strings.SplitN(line, ",", 4)
		if len(fields) < 3 {
			continue
		}

		// Get just the mm/dd/yyyy portion (first 10 chars) from field 2 and 3
		start := fields[1]
		stop := fields[2]
		if len(start) < 10 || len(stop) < 10 {
			continue
		}
		startDate := reformatDate(start[:10]) // mm/dd/yyyy -> yyyymmdd
		stopDate := reformatDate(stop[:10])

		if first {
			minDate, maxDate = startDate, stopDate
			first = false
		} else {
			if startDate < minDate {
				minDate = startDate
			}
			if stopDate > maxDate {
				maxDate = stopDate
			}
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Scanner error:", err)
		return
	}

	fmt.Printf("Earliest: %s/%s/%s\n", minDate[4:6], minDate[6:], minDate[:4])
	fmt.Printf("Latest:   %s/%s/%s\n", maxDate[4:6], maxDate[6:], maxDate[:4])
}

func reformatDate(d string) string {
	// Assumes mm/dd/yyyy
	// Returns yyyymmdd as a string
	return d[6:10] + d[0:2] + d[3:5]
}

