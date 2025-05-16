#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# --- Parameter check ---
if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <dir1> <dir2> [output.html]"
  exit 1
fi

dir1="$1"
dir2="$2"
output="${3:-comparison.html}"

# --- Compute sizes of each directory ---
# du -sh prints human-readable size; cut -f1 extracts just the size field
size1=$(du -sh "$dir1" 2>/dev/null | cut -f1 || echo "N/A")
size2=$(du -sh "$dir2" 2>/dev/null | cut -f1 || echo "N/A")

# --- Temporary files ---
tmp1=$(mktemp)
tmp2=$(mktemp)
diff12=$(mktemp)
diff21=$(mktemp)
trap 'rm -f "$tmp1" "$tmp2" "$diff12" "$diff21"' EXIT

# --- Build sorted lists of RELATIVE paths ---
find "$dir1" -mindepth 1 -print | sed "s:^$dir1/::" | sort > "$tmp1"
find "$dir2" -mindepth 1 -print | sed "s:^$dir2/::" | sort > "$tmp2"

# --- Compare:
#     diff12 = items in dir1 but not in dir2
#     diff21 = items in dir2 but not in dir1
comm -23 "$tmp1" "$tmp2" > "$diff12"
comm -13 "$tmp1" "$tmp2" > "$diff21"

# --- Start HTML report ---
cat > "$output" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Comparison: $dir1 vs $dir2</title>
  <style>
    body { font-family: sans-serif; line-height: 1.5; }
    h1,h2,h3 { margin-bottom: .2em; }
    ul { margin-top: .2em; margin-bottom: 1em; }
    p.size { margin-top: .1em; margin-bottom: .5em; font-style: italic; }
  </style>
</head>
<body>
  <h1>Comparison: <code>$dir1</code> vs <code>$dir2</code></h1>
  <p class="size">Size of <code>$dir1</code>: $size1</p>
  <p class="size">Size of <code>$dir2</code>: $size2</p>

  <h2>Missing in <code>$dir2</code> (present in <code>$dir1</code>)</h2>
EOF

# --- Group and output diff12 ---
awk '
  {
    path=$0
    if (path ~ /\//) { split(path,a,"/"); top=a[1] }
    else { top="Root" }
    print top "|" path
  }
' "$diff12" | sort | awk -F"|" '
  BEGIN { prev="" }
  {
    if ($1 != prev) {
      if (prev!="") print "  </ul>"
      printf "  <h3>%s</h3>\n  <ul>\n", $1
      prev=$1
    }
    printf "    <li>%s</li>\n", $2
  }
  END { if (prev!="") print "  </ul>" }
' >> "$output"

# --- Section for items missing in dir1 ---
cat >> "$output" <<EOF

  <h2>Missing in <code>$dir1</code> (present in <code>$dir2</code>)</h2>
EOF

# --- Group and output diff21 ---
awk '
  {
    path=$0
    if (path ~ /\//) { split(path,a,"/"); top=a[1] }
    else { top="Root" }
    print top "|" path
  }
' "$diff21" | sort | awk -F"|" '
  BEGIN { prev="" }
  {
    if ($1 != prev) {
      if (prev!="") print "  </ul>"
      printf "  <h3>%s</h3>\n  <ul>\n", $1
      prev=$1
    }
    printf "    <li>%s</li>\n", $2
  }
  END { if (prev!="") print "  </ul>" }
' >> "$output"

# --- Close HTML ---
cat >> "$output" <<EOF

</body>
</html>
EOF

echo "Report generated: $output"