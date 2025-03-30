#!/bin/bash

# Folder path where the script will be created
folder_path="./scripts"
script_filename="baby_script.sh"
script_filepath="$folder_path/$script_filename"

# create the folder if it doesn't exist
mkdir -p "$folder_path"

# Define the script content
read -r -d '' script_content << 'EOF'

#!/bin/bash

# script content between the EOF tags

EOF

# Create or replace the script file
echo "$script_content" > "$script_filepath"

# Make the script executable
chmod +x "$script_filepath"

# Confirm the script creation
if [[ -f "$script_filepath" ]]; then
    echo "Script file created or replaced: $script_filepath"
    echo "Script is executable."
else
    echo "Failed to create or replace script file."
fi