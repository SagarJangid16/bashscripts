#!/bin/bash

# Define the path to the log file
LOG_FILE="access.log"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Log file does not exist: $LOG_FILE"
    exit 1
fi

echo "Log Analysis Report"
echo "==================="

# Number of 404 errors
echo -n "404 Errors: "
grep ' 404 ' "$LOG_FILE" | wc -l

# Most requested pages
echo "Most Requested Pages:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 ": " $1 " requests"}'

# IP addresses with the most requests
echo "IP Addresses with Most Requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 ": " $1 " requests"}'
