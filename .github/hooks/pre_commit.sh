# Get the list of Dart files to check
dart_files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(dart)$')

# Check if there are no Dart files to check
if [[ -z "$dart_files" ]]; then
  exit 0
fi

# Apply 'dart fix' to each file individually
for file in $dart_files; do
  echo "Adding required trailing commas to $file..."
  dart fix --apply --code=require_trailing_commas "$file"
done

echo "Formatting Dart files..."
dart format $dart_files

echo "Dart files formatted successfully."
exit 0
