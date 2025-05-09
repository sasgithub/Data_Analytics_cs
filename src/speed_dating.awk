BEGIN {
  FS = ","  # Assuming CSV
  min = 99999999
  max = 0
}

NR > 1 {
  # Extract just the date part from field 2 (start time)
  date1_str = substr($2, 7, 4) substr($2, 1, 2) substr($2, 4, 2) + 0
  # Extract just the date part from field 3 (end time)
  date2_str = substr($3, 7, 4) substr($3, 1, 2) substr($3, 4, 2) + 0

  if (date1_str < min) min = date1_str
  if (date2_str > max) max = date2_str
}

END {
  min_str = sprintf("%02d/%02d/%04d", substr(min,5,2), substr(min,7,2), substr(min,1,4))
  max_str = sprintf("%02d/%02d/%04d", substr(max,5,2), substr(max,7,2), substr(max,1,4))
  print "Earliest:", min_str
  print "Latest:  ", max_str
}

