output_file="signatures.json"
echo "{" > "$output_file"
echo '"_schemaVersion": "1.1.0",' >> "$output_file"
first=true

find . -name "exports.txt" | while read -r exports_file; do
    exports_dir=$(dirname "$exports_file")
    while read -r script; do
        script_name=$(basename "$script" .m)
        if [ "$first" = true ]; then
            first=false
        else
            echo -e "," >> "$output_file"
        fi
        cat <<EOF >> "$output_file"
    "$script_name": {"inputs": [{"name": "filePath", "type": [], "purpose": ""}], "outputs": [{"name": "result", "type": [], "purpose": ""}], "purpose": ""}
EOF
    done < "$exports_file"
done

echo "}" >> "$output_file"

