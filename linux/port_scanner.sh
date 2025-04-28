#!/bin/bash

# Description: Scans for open ports on the local machine
# Usage: ./port_scanner.sh [--detailed]

echo "Running Port Scan - $(date)"

# Check if netstat or ss is available
if command -v ss &>/dev/null; then
    CMD="ss -tulnp"
elif command -v netstat &>/dev/null; then
    CMD="netstat -tuln"
else
    echo "Error: Neither 'ss' nor 'netstat' found!"
    exit 1
fi

# Scan ports
echo "Open Ports:"
$CMD | grep -E '0.0.0.0|:::' | awk '{print $1,$5}' | column -t

# Detailed scan if --detailed flag is passed
if [[ $1 == "--detailed" ]]; then
    echo -e "\nDetailed Scan:"
    $CMD | grep -E '0.0.0.0|:::'
fi

# Save to output file
OUTPUT_FILE="../outputs/port_scan_$(date +%Y-%m-%d).txt"
$CMD > "$OUTPUT_FILE"
echo -e "\nResults saved to $OUTPUT_FILE"