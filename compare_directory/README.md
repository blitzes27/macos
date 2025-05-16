# Directory compare

This script compares all the files in two directories, its subdirectories and list the differences like the image below on a HTML page.

![alt text](image1.png)

```bash
# YOUR VARIABLES HERE
FOLDER1="$HOME/Documents/Skola"
FOLDER2="$HOME/Desktop/Skola"
HTML_RESULT="$HOME/Desktop/result.html"
GITHUB="https://raw.githubusercontent.com/blitzes27/macos/main"

# Runs the script from github
curl -fsSL "$GITHUB/compare_directory/compare_dir.sh" | bash \
-s -- "$FOLDER1" "$FOLDER2" "$HTML_RESULT"
```