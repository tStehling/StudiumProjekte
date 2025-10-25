#!/bin/bash


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd )

cd $PROJECT_ROOT

# Script to regenerate localization files

echo "Regenerating localization files..."
flutter gen-l10n

echo "Localization files regenerated successfully!"
echo "You can now use the translations in your code with AppLocalizations.of(context)." 