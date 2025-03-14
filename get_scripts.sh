#!/bin/bash

echo -n "["

first=true

# Loop through each exports.txt file
find . -name "exports.txt" | while read -r exports_file; do
    exports_dir=$(dirname "$exports_file")

    # Loop through each line in the exports.txt file
    while read -r script; do
        script_path="$exports_dir/$script"
        
				if [ "$first" = true ]; then
						first=false
				else
						echo -n ", "
				fi

				echo -n "\"$script_path\""
    done < "$exports_file"
done

echo "]"

