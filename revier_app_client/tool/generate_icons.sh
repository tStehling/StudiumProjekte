#!/bin/bash

# Revier App Icon Generator
# This script converts SVG to PNG and generates app icons and splash screen

set -e  # Exit on error

echo "Revier App - Icon & Splash Generator"
echo "==================================="

# Define paths
SVG_PATH="assets/logo/revierapp.svg"
PNG_PATH="assets/logo/revierapp.png"
WHITE_SVG_PATH="assets/logo/revierapp_white.svg" # For creating a white version
SPLASH_PNG_PATH="assets/logo/revierapp_splash.png"  # For splash screen
ANDROID_PNG_PATH="assets/logo/revierapp_android.png"
IOS_PNG_PATH="assets/logo/revierapp_ios.png"
FOREGROUND_PNG_PATH="assets/logo/revierapp_foreground.png"

# Define theme color
THEME_COLOR="#2C3532"

# Check if the SVG file exists
if [ ! -f "$SVG_PATH" ]; then
  echo "ERROR: SVG file not found at $SVG_PATH"
  echo "Please place your SVG logo there first."
  exit 1
fi

echo "✓ Found SVG logo at $SVG_PATH"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Determine the appropriate ImageMagick command to use
get_imagemagick_command() {
  # Check if magick command exists (ImageMagick v7+)
  if command_exists magick; then
    echo "magick"
  # Fall back to convert for older versions
  elif command_exists convert; then
    echo "convert"
  else
    echo ""
  fi
}

# Convert SVG to PNG using available tools
echo "Converting SVG to PNG files..."

# Get the appropriate ImageMagick command
IM_CMD=$(get_imagemagick_command)

if [ ! -z "$IM_CMD" ]; then
  # Using ImageMagick
  echo "Using ImageMagick for conversion with $IM_CMD command..."
  
  # Create standard PNG for general use (1024x1024)
  $IM_CMD -background none -density 300 "$SVG_PATH" -resize 1024x1024 "$PNG_PATH"
  echo "✓ Created $PNG_PATH"
  
  # Create a detailed white logo for splash screen
  # The trick is to preserve details while ensuring it's white
  echo "Creating a detailed white logo for splash screen..."
  
  # Create a temporary high-res version to preserve details
  TEMP_PNG="assets/logo/temp_deer.png"
  
  # Convert from white SVG if available (with high density for details)
  if [ -f "$WHITE_SVG_PATH" ]; then
    $IM_CMD -background none -density 600 "$WHITE_SVG_PATH" -resize 800x800 "$TEMP_PNG"
  else 
    # If no white SVG, use the regular SVG and convert to white
    $IM_CMD -background none -density 600 "$SVG_PATH" -resize 800x800 -channel RGB -fill white -colorize 100% "$TEMP_PNG"
  fi
  
  # Now create the final splash screen with the detailed white logo centered
  $IM_CMD -size 1024x1024 xc:none -gravity center "$TEMP_PNG" -composite "$SPLASH_PNG_PATH"
  
  # Clean up the temporary file
  rm "$TEMP_PNG"
  
  echo "✓ Created detailed white logo splash screen: $SPLASH_PNG_PATH"
  
  # Create Android icon (1024x1024)
  $IM_CMD -background none -density 300 "$SVG_PATH" -resize 1024x1024 "$ANDROID_PNG_PATH"
  echo "✓ Created $ANDROID_PNG_PATH"
  
  # Create iOS icon (1024x1024)
  $IM_CMD -background none -density 300 "$SVG_PATH" -resize 1024x1024 "$IOS_PNG_PATH"
  echo "✓ Created $IOS_PNG_PATH"
  
  # Create foreground icon with theme color for adaptive icons
  # This creates better results when displayed with a white background
  echo "Creating theme-colored icon without any padding or background for adaptive icons..."
  
  # For adaptive icon, we use theme color and ensure the icon fills the space properly
  # We don't want any padding for the foreground since the adaptive icon system handles that
  $IM_CMD -background none -density 600 "$SVG_PATH" -resize 1024x1024 \
    -channel RGB -fill "$THEME_COLOR" -colorize 100% \
    "$FOREGROUND_PNG_PATH"
  
  echo "✓ Created $FOREGROUND_PNG_PATH with theme color $THEME_COLOR (no padding)"
  
elif command_exists inkscape; then
  # Using Inkscape
  echo "Using Inkscape for conversion..."
  
  # Create standard PNG for general use (1024x1024)
  inkscape --export-filename="$PNG_PATH" --export-width=1024 --export-height=1024 "$SVG_PATH"
  echo "✓ Created $PNG_PATH"
  
  # For the splash screen, try to create a detailed white logo
  if [ ! -z "$IM_CMD" ]; then
    # Still use ImageMagick for the splash screen conversion
    echo "Creating a detailed white logo for splash screen using ImageMagick..."
  
    # Create a temporary high-res version to preserve details
    TEMP_PNG="assets/logo/temp_deer.png"
    
    # Convert from white SVG if available (with high density for details)
    if [ -f "$WHITE_SVG_PATH" ]; then
      $IM_CMD -background none -density 600 "$WHITE_SVG_PATH" -resize 800x800 "$TEMP_PNG"
    else 
      # If no white SVG, use the regular SVG and convert to white
      $IM_CMD -background none -density 600 "$SVG_PATH" -resize 800x800 -channel RGB -fill white -colorize 100% "$TEMP_PNG"
    fi
    
    # Now create the final splash screen with the detailed white logo centered
    $IM_CMD -size 1024x1024 xc:none -gravity center "$TEMP_PNG" -composite "$SPLASH_PNG_PATH"
    
    # Clean up the temporary file
    rm "$TEMP_PNG"
    
    echo "✓ Created detailed white logo splash screen: $SPLASH_PNG_PATH"
  elif [ -f "$WHITE_SVG_PATH" ]; then
    # Without ImageMagick, use Inkscape directly with the white SVG
    inkscape --export-filename="$SPLASH_PNG_PATH" --export-width=800 --export-height=800 --export-background=none "$WHITE_SVG_PATH"
    echo "✓ Created splash screen using white SVG: $SPLASH_PNG_PATH"
  else 
    # Fallback for when we have neither ImageMagick nor a white SVG
    inkscape --export-filename="$SPLASH_PNG_PATH" --export-width=800 --export-height=800 --export-background=none "$SVG_PATH"
    echo "⚠️ WARNING: Using regular icon for splash. The logo may not appear correctly."
  fi
  
  # Create Android icon (1024x1024)
  inkscape --export-filename="$ANDROID_PNG_PATH" --export-width=1024 --export-height=1024 "$SVG_PATH"
  echo "✓ Created $ANDROID_PNG_PATH"
  
  # Create iOS icon (1024x1024)
  inkscape --export-filename="$IOS_PNG_PATH" --export-width=1024 --export-height=1024 "$SVG_PATH"
  echo "✓ Created $IOS_PNG_PATH"
  
  # Create foreground icon for adaptive icons
  # Using Inkscape with ImageMagick for color conversion
  if [ ! -z "$IM_CMD" ]; then
    # Create a temporary PNG with Inkscape
    inkscape --export-filename="assets/logo/temp_foreground.png" --export-width=1024 --export-height=1024 "$SVG_PATH"
    # Convert to theme color with ImageMagick
    $IM_CMD "assets/logo/temp_foreground.png" -channel RGB -fill "$THEME_COLOR" -colorize 100% "$FOREGROUND_PNG_PATH"
    rm "assets/logo/temp_foreground.png"
    echo "✓ Created $FOREGROUND_PNG_PATH with theme color $THEME_COLOR (using ImageMagick)"
  else
    # Without ImageMagick, just use Inkscape and warn the user they may need to edit the color manually
    inkscape --export-filename="$FOREGROUND_PNG_PATH" --export-width=1024 --export-height=1024 "$SVG_PATH"
    echo "⚠️ WARNING: Created $FOREGROUND_PNG_PATH but couldn't convert to theme color. You may need to edit this file manually."
  fi
else
  echo "⚠️ WARNING: Neither ImageMagick (magick/convert) nor Inkscape is available."
  echo "Please install one of these tools or manually convert your SVG to PNG files:"
  echo "  - $PNG_PATH (1024x1024)"
  echo "  - $SPLASH_PNG_PATH (1024x1024, with detailed white logo)"
  echo "  - $ANDROID_PNG_PATH (1024x1024)"
  echo "  - $IOS_PNG_PATH (1024x1024)"
  echo "  - $FOREGROUND_PNG_PATH (1024x1024 with theme color $THEME_COLOR)"
  exit 1
fi

# Generate splash screen
echo -e "\nGenerating splash screen..."
flutter pub run flutter_native_splash:create

# Generate app icons
echo -e "\nGenerating app icons..."
flutter pub run flutter_launcher_icons

echo -e "\n✅ Setup complete! Your app now has:"
echo "- A splash screen with a detailed white logo on the brand color background ($THEME_COLOR)"
echo "- Custom app icons generated from your SVG"
echo "- Adaptive icons with white background and theme-colored foreground"
echo -e "\nYou can now run your app to see the results!" 