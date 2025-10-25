#!/bin/bash
# Script to add new translations to the app

# Check if key and value parameters are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <translation_key> <english_value> [<german_value>]"
  echo "Example: $0 'hello' 'Hello World' 'Hallo Welt'"
  exit 1
fi

TRANSLATION_KEY="$1"
ENGLISH_VALUE="$2"
GERMAN_VALUE="${3:-$2}"  # Default to English if German not provided

echo "Adding translation:"
echo "Key: $TRANSLATION_KEY"
echo "English: $ENGLISH_VALUE"
echo "German: $GERMAN_VALUE"

# Get the path to the ARB files
ENGLISH_ARB="lib/localization/app_en.arb"
GERMAN_ARB="lib/localization/app_de.arb"

# Check if the files exist
if [ ! -f "$ENGLISH_ARB" ]; then
  echo "Error: English ARB file not found at $ENGLISH_ARB"
  exit 1
fi

if [ ! -f "$GERMAN_ARB" ]; then
  echo "Error: German ARB file not found at $GERMAN_ARB"
  exit 1
fi

# Add the translation to the English ARB file
# Find the last line with a closing brace
LAST_LINE_EN=$(grep -n "}" "$ENGLISH_ARB" | tail -n 1 | cut -d: -f1)
if [ -z "$LAST_LINE_EN" ]; then
  echo "Error: Could not find closing brace in English ARB file"
  exit 1
fi

# Create temporary file
EN_TEMP_FILE=$(mktemp)

# Split the file and insert the new translation
head -n $((LAST_LINE_EN-1)) "$ENGLISH_ARB" > "$EN_TEMP_FILE"
echo "  \"$TRANSLATION_KEY\": \"$ENGLISH_VALUE\"," >> "$EN_TEMP_FILE"
echo "  \"@$TRANSLATION_KEY\": {" >> "$EN_TEMP_FILE"
echo "    \"description\": \"$ENGLISH_VALUE\"" >> "$EN_TEMP_FILE"
echo "  }" >> "$EN_TEMP_FILE"
echo "}" >> "$EN_TEMP_FILE"

# Update the original file
mv "$EN_TEMP_FILE" "$ENGLISH_ARB"

# Add the translation to the German ARB file
# Find the last line with a closing brace
LAST_LINE_DE=$(grep -n "}" "$GERMAN_ARB" | tail -n 1 | cut -d: -f1)
if [ -z "$LAST_LINE_DE" ]; then
  echo "Error: Could not find closing brace in German ARB file"
  exit 1
fi

# Create temporary file
DE_TEMP_FILE=$(mktemp)

# Split the file and insert the new translation
head -n $((LAST_LINE_DE-1)) "$GERMAN_ARB" > "$DE_TEMP_FILE"
echo "  \"$TRANSLATION_KEY\": \"$GERMAN_VALUE\"," >> "$DE_TEMP_FILE"
echo "}" >> "$DE_TEMP_FILE"

# Update the original file
mv "$DE_TEMP_FILE" "$GERMAN_ARB"

echo "Translations added successfully!"
echo "Regenerating localization files..."

# Run flutter gen-l10n to generate the localization files
flutter gen-l10n

echo "Done!" 