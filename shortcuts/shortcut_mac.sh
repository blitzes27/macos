#!/bin/bash

# This script creates shortcuts on the desktop for specified applications and web links.
# It checks if the shortcuts already exist and skips creation if they do.
# It also verifies that the target applications exist before creating the shortcuts.

# Define a list of shortcuts with the format "Name|TargetPath"
shortcuts=(
    "Notepad|/System/Applications/Notes.app"
    "Calculator|/System/Applications/Calculator.app"
    "Google|https://www.macrumors.com"
    "Aftonbladet|https://www.aftonbladet.se"
)

# Define the desktop path for the logged-in user
desktopPath="$HOME/Desktop"

# Loop through all entries in the list
for entry in "${shortcuts[@]}"; do
    # Split the entry into 'name' and 'target' using '|' as a delimiter
    IFS="|" read -r name target <<< "$entry"
    
    # Check if the target is a web link (if it starts with "http")
    if [[ "$target" =~ ^http ]]; then
        shortcutFile="$desktopPath/$name.webloc"
        
        # Check if the shortcut file already exists
        if [ -e "$shortcutFile" ]; then
            echo "Shortcut for $name already exists at $shortcutFile. Skipping creation."
            continue
        fi
        
        # Create a .webloc file with the proper XML structure required by macOS
        cat <<EOF > "$shortcutFile"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>URL</key>
    <string>$target</string>
</dict>
</plist>
EOF
        echo "Web shortcut for $name created at $shortcutFile."
    
    else
        # Otherwise, treat the target as a program path
        shortcutFile="$desktopPath/$name"
        
        # Check if the shortcut already exists
        if [ -e "$shortcutFile" ]; then
            echo "Shortcut for $name already exists at $shortcutFile. Skipping creation."
            continue
        fi
        
        # Check that the target file or directory exists
        if [ ! -e "$target" ]; then
            echo "Target for $name does not exist at $target. Skipping creation."
            continue
        fi
        
        # Create a symbolic link on the desktop for the program
        ln -s "$target" "$shortcutFile"
        echo "Program shortcut for $name created at $shortcutFile."
    fi
done

echo "Shortcut creation process completed."