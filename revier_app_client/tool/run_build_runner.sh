#!/bin/bash
# This script runs build_runner to generate code for Brick, Riverpod, and other code generation tools

echo "Running build_runner..."

# Clean up any previous build artifacts first
dart run build_runner clean

# Run the build_runner with delete-conflicting-outputs to avoid conflicts
echo "Running build_runner..."
dart run build_runner build --delete-conflicting-outputs

# Generate localization files
echo "Generating localization files..."
flutter gen-l10n