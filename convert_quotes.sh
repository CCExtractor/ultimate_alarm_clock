#!/bin/bash

find . -name "*.dart" -type f | while read -r file; do
  if [[ "$file" != *".dart_tool"* && "$file" != *"build/"* ]]; then
    sed -i.bak 's/"\([^"'\'']*\)"/\x27\1\x27/g' "$file"
    
    rm "${file}.bak"
    
    echo "Processed: $file"
  fi
done

echo "Quote conversion completed" 