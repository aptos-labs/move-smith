#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory_path>"
    exit 1
fi

directory="$1"

# Check if the provided argument is a directory
if [ ! -d "$directory" ]; then
    echo "Error: Provided argument is not a directory"
    exit 1
fi

# Loop through all .raw files in the directory
for raw_file in "$directory"/*.raw; do
    if [ ! -e "$raw_file" ]; then
        continue
    fi
    move_file="${raw_file%.raw}.move"
    if [ ! -e "$move_file" ]; then
        echo "$raw_file"
    fi
done
