#!/bin/bash

# Function to perform curl request and check cache status
check_cache_status() {
    curl_output=$(curl -IkL -X GET "$url" -s | grep -i "CF-Cache-Status\|X-Kinsta-Cache")

    echo "$curl_output"

    kinsta_cache=$(echo "$curl_output" | grep -i "X-Kinsta-Cache" | awk '{print $2}')

    if [ "$kinsta_cache" != "MISS" ]; then
        return 1
    else
        return 0
    fi
}

# Read URL from user input
read -p "Enter the URL: " url

# Repeat until X-Kinsta-Cache is "MISS"
while check_cache_status; do
    echo "Cache status is not MISS, retrying in 30 seconds..."
    sleep 30
done

echo "Cache status is MISS"
