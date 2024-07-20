#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Get CPU usage
CPU_USAGE=$(mpstat 1 1 | grep "Average" | awk '{print 100 - $12}')

# Get Memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Get Disk usage
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

# Check CPU usage
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "ALERT: CPU usage is high at ${CPU_USAGE}%"
fi

# Check Memory usage
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    echo "ALERT: Memory usage is high at ${MEMORY_USAGE}%"
fi

# Check Disk usage
if (( DISK_USAGE > DISK_THRESHOLD )); then
    echo "ALERT: Disk usage is high at ${DISK_USAGE}%"
fi

# Check for running processes (top 5 by CPU usage)
echo "Top 5 processes by CPU usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
