# revier_app_client

A new Flutter project.

## Development
If an error with the build occurs run `tool/delete_google_drive_sync_icon.sh` to delete the icons created automatically from the google drive sync.

## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/to/state-management-sample).

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/to/resolution-aware-images).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter apps](https://flutter.dev/to/internationalization).

## App Icon and Splash Screen

The app uses a custom brand color (`#2C3532`) for its theme and splash screen.

### Setting up App Icons and Splash Screen

1. Place your logo SVG in `assets/logo/revierapp.svg`
2. Convert your SVG to PNG files of appropriate sizes:
   - `assets/logo/revierapp.png` (1024x1024) - For splash screen
   - `assets/logo/revierapp_android.png` (1024x1024) - For Android icon
   - `assets/logo/revierapp_ios.png` (1024x1024) - For iOS icon
   - `assets/logo/revierapp_foreground.png` (1024x1024 with padding) - For Android adaptive icon

3. Generate the splash screen:
   ```
   flutter pub run flutter_native_splash:create
   ```

4. Generate the app icons:
   ```
   flutter pub run flutter_launcher_icons
   ```

Alternatively, run our helper tool:
```
dart run tool/generate_icons.dart
```

### Theme Configuration

The app theme is configured in `lib/config/brand_theme.dart` with the brand color (`#2C3532`) as the primary color. Modify this file to adjust the theme as needed.

## Hunting Ground Filtering

The app now implements automatic filtering of models by the selected hunting ground. This ensures that users only see data relevant to their current context.

### Key Components:

1. **HuntingGroundFilteredModelView**: A reusable component that automatically filters models by the selected hunting ground. It's located at `lib/common/model_management/hunting_ground_filtered_model_view.dart`.

2. **Implementation**: The component observes the `selectedHuntingGroundProvider` and creates a query to filter models by the hunting ground ID. It also handles the case when no hunting ground is selected, showing an appropriate message.

3. **Usage**: The component is used in various collection views, such as:
   - AnimalCollectionView
   - AnimalFilterCollectionView
   - (And can be used in other collection views that need hunting ground filtering)

4. **Benefits**:
   - Consistent filtering across the app
   - Automatic handling of the "no hunting ground selected" state
   - Simplified implementation in collection views
   - Centralized logic for hunting ground filtering

### How to Use:

To use the `HuntingGroundFilteredModelView` in a new collection view:

```dart
HuntingGroundFilteredModelView<YourModel>(
  modelHandler: yourModelHandler,
  huntingGroundIdField: 'huntingGroundId', // Field name in your model
  detailViewBuilder: (context, model) => YourDetailView(model: model),
  subtitleProvider: (model) => 'Your subtitle text',
  // Other parameters as needed
)
```

# Useful commands

Install dependencies

```bash
flutter pub get
```

Upgrade dependencies

```bash
flutter pub upgrade
```

Generate the code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Start the app with emulator

```bash
flutter run
```





