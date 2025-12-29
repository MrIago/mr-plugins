#!/bin/bash

# Split Cloudflare DO documentation into skill reference files
# Usage: ./split-docs.sh <input-file> <output-dir>

INPUT_FILE="${1:?Usage: ./split-docs.sh <input-file> <output-dir>}"
OUTPUT_DIR="${2:-.claude/skills/durable-objects/reference}"

mkdir -p "$OUTPUT_DIR"

# Categories based on URL path
declare -A CATEGORIES=(
  ["api"]="api"
  ["best-practices"]="best-practices"
  ["examples"]="examples"
  ["concepts"]="concepts"
  ["reference"]="reference"
  ["platform"]="platform"
  ["tutorials"]="tutorials"
  ["observability"]="observability"
)

# Track files created
declare -A FILES_CREATED

# Read file and split by <page> tags
awk '
BEGIN {
  page_num = 0
  in_page = 0
  content = ""
}

/<page>/ {
  in_page = 1
  content = ""
  next
}

/<\/page>/ {
  if (in_page) {
    page_num++
    filename = sprintf("page_%04d.tmp", page_num)
    print content > filename
    close(filename)
  }
  in_page = 0
  next
}

in_page {
  content = content $0 "\n"
}
' "$INPUT_FILE"

# Process each temp page file
for tmpfile in page_*.tmp; do
  [ -f "$tmpfile" ] || continue

  # Extract title and URL from frontmatter
  title=$(grep -m1 "^title:" "$tmpfile" | sed 's/^title: //' | sed 's/ · Cloudflare.*$//' | tr -d '"')
  url=$(grep -m1 "html:" "$tmpfile" | sed 's/.*html: //' | tr -d ' ')

  # Skip empty or 404 pages
  if [[ -z "$title" ]] || [[ "$title" == "404"* ]]; then
    rm "$tmpfile"
    continue
  fi

  # Determine category from URL
  category="misc"
  for cat in "${!CATEGORIES[@]}"; do
    if [[ "$url" == *"/durable-objects/$cat/"* ]]; then
      category="${CATEGORIES[$cat]}"
      break
    fi
  done

  # Skip index pages (they're just link lists)
  if [[ "$url" == *"/index.md" ]] && [[ $(wc -l < "$tmpfile") -lt 50 ]]; then
    rm "$tmpfile"
    continue
  fi

  # Create filename from title
  filename=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')

  # Create category directory
  mkdir -p "$OUTPUT_DIR/$category"

  # Output file path
  outfile="$OUTPUT_DIR/$category/$filename.md"

  # Skip duplicates
  if [[ -f "$outfile" ]]; then
    rm "$tmpfile"
    continue
  fi

  # Extract content after frontmatter
  awk '
    BEGIN { found_end = 0 }
    /^---$/ && NR > 1 { found_end = 1; next }
    found_end { print }
  ' "$tmpfile" > "$outfile"

  # Add title header if not present
  if ! head -1 "$outfile" | grep -q "^#"; then
    sed -i "1i# $title\n" "$outfile"
  fi

  FILES_CREATED["$category/$filename.md"]=1
  rm "$tmpfile"
done

# Clean up any remaining temp files
rm -f page_*.tmp

# Print summary
echo "Created reference files in $OUTPUT_DIR:"
for cat in api best-practices examples concepts reference platform; do
  if [ -d "$OUTPUT_DIR/$cat" ]; then
    count=$(ls -1 "$OUTPUT_DIR/$cat" 2>/dev/null | wc -l)
    echo "  $cat/: $count files"
  fi
done

echo ""
echo "Update SKILL.md with links to reference files."
