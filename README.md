🚧 **This project is currently a work in progress.**  
I'm actively building out my case study as part of the Google Data Analytics Capstone.  
Full write-up, code, and visualizations will be available soon!

# 🚲 Data Analytics Case Study: Divvy Bike Share

This project explores over 28 million Divvy bike-share ride records in Chicago, with the goal of identifying patterns in ridership behavior between casual users and annual members.

It was developed as part of the [Google Data Analytics Professional Certificate](https://www.coursera.org/professional-certificates/google-data-analytics) capstone and is intended for portfolio presentation.

**Live Site**: [sasgithub.github.io/Data_Analytics_cs](https://sasgithub.github.io/Data_Analytics_cs/)

---

## Data Sources

- **Divvy Trip Data**: [Divvy Trip Archive](https://divvy-tripdata.s3.amazonaws.com/index.html) and [City of Chicago Data Portal](https://data.cityofchicago.org/Transportation/Divvy-Trips/fg6s-gzvg/about_data)
- **Weather Data**: [Meteostat Hourly Bulk Data](https://bulk.meteostat.net/v2/hourly/72534.csv.gz)
- **Tourist Stations**: Custom dataset created from Google Maps lat/lng queries

See the [Data Sources](https://sasgithub.github.io/Data_Analytics_cs/data.html) page for more details and attribution.

---

## Repository Structure

```text
├── case-study/ # Quarto source files (index.qmd, etc.)
├── docs/ # Rendered site (GitHub Pages target)
├── data/ # Sample CSVs and data README
├── images/ # Visualization thumbnails, maps, exports
├── Legal/ # City of Chicago license/terms
├── schema/ # SQL schema for rides database
├── src/ # Cleaning and transformation scripts
└── README.md # This file
```

---

## Key Technologies

- R / SQLite / Bash / Python – Data processing
- ggplot2 / gnuplot / Tableau / Leaflet – Visualizations
- Quarto – Site generation and publishing
- GitHub Pages – Free portfolio hosting

## Build Instructions

To build the site locally:

1. Install [Quarto](https://quarto.org/docs/get-started/)
2. Clone this repo:
   ```bash
   git clone https://github.com/sasgithub/Data_Analytics_cs.git
   cd Data_Analytics_cs/case-study
   ```
3. Render the site into ../docs:
   ```bash
   quarto render
   ```

## License

Divvy and City of Chicago data is subject to the City of Chicago [Terms of Use](Legal/City_of_Chicago_disclaimer.txt).

Weather data provided by Meteostat
<blockquote><p>Source: <a href="https://meteostat.net" target="_blank" rel="noopener noreferrer">Meteostat<span><svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false" x="0px" y="0px" viewBox="0 0 100 100" width="15" height="15" class="icon outbound"><path fill="currentColor" d="M18.8,85.1h56l0,0c2.2,0,4-1.8,4-4v-32h-8v28h-48v-48h28v-8h-32l0,0c-2.2,0-4,1.8-4,4v56C14.8,83.3,16.6,85.1,18.8,85.1z"></path> <polygon fill="currentColor" points="45.7,48.7 51.3,54.3 77.2,28.5 77.2,37.2 85.2,37.2 85.2,14.9 62.8,14.9 62.8,22.9 71.5,22.9"></polygon></svg> <span class="sr-only">(opens new window)</span></span></a></p></blockquote>

This case study is © 2025 Scott Sesher and provided under the MIT License. See [LICENSE](LICENSE) for details.
---
[![Report Issues](https://img.shields.io/github/issues/sasgithub/Data_Analytics_cs.svg?label=report%20issue)](https://github.com/sasgithub/Data_Analytics_cs/issues)

