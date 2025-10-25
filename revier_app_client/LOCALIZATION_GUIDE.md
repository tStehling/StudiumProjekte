# Revier App Localization Guide

This guide explains how to use and maintain the localization system in the Revier App.

## Overview

The Revier App uses Flutter's official localization system, which is based on ARB (Application Resource Bundle) files. This system provides:

- Type-safe access to translations
- Support for multiple languages (currently English and German)
- Automatic code generation for easy access to translations

## Project Structure

The localization files are organized as follows:

- `lib/localization/` - Contains all localization files
  - `app_en.arb` - English translations
  - `app_de.arb` - German translations
  - `app_localizations.dart` - Generated Dart code (do not edit manually)
  - `app_localizations_*.dart` - Generated language-specific files (do not edit manually)
- `l10n.yaml` - Configuration for the localization system
- `add_translation.sh` - Helper script for adding new translations
- `update_localization.sh` - Helper script for updating generated files

## Using Translations in Code

To use translations in your Flutter widgets:

1. Import the generated localization class:
   ```dart
   import 'package:revier_app_client/localization/app_localizations.dart';
   ```

2. Access translations in widgets:
   ```dart
   // Get the current localizations
   final l10n = AppLocalizations.of(context)!;
   
   // Use a translation
   Text(l10n.appTitle)
   ```

## Adding New Translations

### Method 1: Using the Helper Script

Run the `add_translation.sh` script with the following parameters:
```bash
./add_translation.sh <key> <english_value> [<german_value>]
```

Example:
```bash
./add_translation.sh "buttonSave" "Save" "Speichern"
```

### Method 2: Manual Editing

1. Open the ARB files in `lib/localization/`
2. Add your translation to both language files:

   In `app_en.arb`:
   ```json
   "buttonSave": "Save",
   "@buttonSave": {
     "description": "Text for save button"
   }
   ```

   In `app_de.arb`:
   ```json
   "buttonSave": "Speichern"
   ```

3. Run the following command to generate the Dart code:
   ```bash
   flutter gen-l10n
   ```

## Working with Plurals

ARB files support pluralization using ICU message format:

```json
"itemCount": "{count, plural, =0{No items} =1{One item} other{{count} items}}",
"@itemCount": {
  "description": "The number of items",
  "placeholders": {
    "count": {
      "type": "int"
    }
  }
}
```

Then use it in your code:
```dart
Text(l10n.itemCount(5)) // Shows "5 items"
```

## Working with Parameters

ARB files support parameters:

```json
"greeting": "Hello, {name}!",
"@greeting": {
  "description": "A greeting message",
  "placeholders": {
    "name": {
      "type": "String"
    }
  }
}
```

Then use it in your code:
```dart
Text(l10n.greeting('John')) // Shows "Hello, John!"
```

## Switching Languages

To change the app's language:

```dart
// Import the necessary files
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/core/services/i18n_service.dart';

// Access the localeProvider to change the language
ref.read(localeProvider.notifier).state = AppLocale.de; // Switch to German
ref.read(localeProvider.notifier).state = AppLocale.en; // Switch to English
```

## Troubleshooting

If you encounter issues with the localization system:

1. Run the `update_localization.sh` script to clean and regenerate localization files
2. Make sure your ARB files are valid JSON
3. Check for any syntax errors in the ARB files
4. Verify that the string keys are consistent across language files

## Resources

- [Flutter Internationalization Guide](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [ARB File Format](https://localizely.com/flutter-arb/)
- [ICU Message Format](https://unicode-org.github.io/icu/userguide/format_parse/messages/) 