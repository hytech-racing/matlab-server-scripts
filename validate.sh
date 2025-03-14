# Keep track of all the script names and where they were exported from
declare -A script_names

find . -name "exports.txt" | while read -r exports_file; do
    exports_dir=$(dirname "$exports_file")

    while read -r m_file; do
        # Remove any leading/trailing whitespace from m_file
        m_file=$(echo "$m_file" | xargs)

        # Check if the .m file exists
        m_file_path="$exports_dir/$m_file"
        if [ ! -f "$m_file_path" ]; then
            echo "Error: $m_file_path does not exist"
            exit 1
        fi

        # Get the base name of .m file
        base_name=$(basename "$m_file" .m)

				# Check if the base name is already used
        if [[ -n "${script_names[$base_name]}" ]]; then
            echo "Error: Duplicate base name '$base_name' found in $exports_file (already found in ${script_names[$base_name]})."
            exit 1
        fi

				# Record this script name as seen
        script_names["$base_name"]="$exports_file"

        # Get the first line of the .m file
        first_line=$(head -n 1 "$m_file_path")

        # Check if the base name appears anywhere in the first line
				# Simple but not conclusive test to make sure that the exported
				# function is at the top of the file
        if [[ "$first_line" != *"$base_name"* ]]; then
            echo "Error: The first line of $m_file_path does not contain '$base_name'."
            exit 1
        fi

    done < "$exports_file"
done
