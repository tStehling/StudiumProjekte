# Riverpod-based Sorting and View Mode System

This document explains the implementation of a robust sorting and view mode system built with Riverpod for the Revier App.

## Overview

The sorting system provides a way to:
1. Apply consistent sorting across collections
2. Persist sort settings between app sessions
3. Toggle between grid and list views
4. Ensure sort settings survive navigation events
5. Provide a responsive UI for sorting and layout controls

## Key Components

### 1. Sort Provider (`sort_provider.dart`)

The core of the system consists of:

- **`SortSettings`**: A data class that holds the current sort field and direction
- **`SortSettingsNotifier`**: A Riverpod `StateNotifier` that manages sort settings with persistence
- **`ViewModeNotifier`**: A Riverpod `StateNotifier` that manages grid/list view with persistence
- **Helper functions**: For creating model-specific providers for different collections

### 2. Responsive Layout Switch (`responsive_layout_switch.dart`)

A reusable widget that:
- Displays the current sort field and direction
- Provides a dropdown for sort options
- Allows toggling sort direction
- Provides a button to switch between grid and list views

### 3. Model Collection Integration

The system integrates with:
- **`ModelCollectionView`**: The base collection view for all models
- **`HuntingGroundFilteredModelView`**: A specialized view that filters by hunting ground

## How to Use

### 1. Create Providers for Your Model

Create providers for your model collection in a dedicated provider file:

```dart
// animal_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/common/model_management/sort_provider.dart';

// Provider for animal sort settings
final animalSortProvider = createSortSettingsProvider(
  defaultField: 'updatedAt',
  prefsKey: 'animal',
);

// Provider for animal view mode (grid vs list)
final animalViewModeProvider = createViewModeProvider(
  defaultIsGrid: true,
  prefsKey: 'animal',
);

// Provider for animal sort field labels
final animalSortLabelsProvider = Provider<Map<String, String>>((ref) {
  return {
    'updatedAt': 'Updated',
    'createdAt': 'Created', 
    'name': 'Name',
    // Add more sort fields as needed
  };
});
```

### 2. Use the Providers in Your Collection View

Pass the providers to your collection view:

```dart
// animal_collection_view.dart
class AnimalCollectionView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelHandler = ref.watch(animalModelHandlerProvider);
    
    return HuntingGroundFilteredModelView<Animal>(
      modelHandler: modelHandler,
      detailViewBuilder: (context, animal) => AnimalFormView(initialEntity: animal),
      
      // Use Riverpod providers for sorting and view mode
      sortProvider: animalSortProvider,
      viewModeProvider: animalViewModeProvider,
      sortLabelsProvider: animalSortLabelsProvider,
      
      // Other configuration...
    );
  }
}
```

### 3. Add the Responsive Layout Switch to Your UI

Add the layout switch to your screen's app bar:

```dart
// In your screen file
Consumer(
  builder: (context, ref, _) {
    final sortSettings = ref.watch(animalSortProvider);
    final isGrid = ref.watch(animalViewModeProvider);
    final viewModeNotifier = ref.read(animalViewModeProvider.notifier);
    
    return ResponsiveLayoutSwitch(
      onToggle: (isGridMode) => viewModeNotifier.toggleViewMode(),
      isGrid: isGrid,
      sortProvider: animalSortProvider,
      sortLabelsProvider: animalSortLabelsProvider,
    );
  },
),
```

## How It Works

1. **State Management**: Riverpod providers maintain the current sort field, direction and view mode.

2. **Persistence**: The notifiers automatically save settings to `SharedPreferences`.

3. **Synchronization**: When the user selects a sort option:
   - The `ResponsiveLayoutSwitch` updates the provider state
   - The provider persists the change to `SharedPreferences`
   - The collection view reacts to the state change and re-sorts items

4. **Navigation Resilience**: Since the state is managed by Riverpod providers, it survives navigation events.

## Troubleshooting

If your sorting isn't working as expected:

1. **Check Logger Output**: Look for logs from `SortSettingsNotifier`, `ModelCollectionView`, and `ResponsiveLayoutSwitch`.

2. **Verify Field Names**: Ensure the field names in your `sortLabelsProvider` match actual fields in your model.

3. **Check Initialization Order**: Make sure providers are created before they're used.

## Extending the System

To add sorting to a new model type:

1. Create providers for the new model (sort settings, view mode, labels)
2. Pass those providers to your collection view
3. Add the `ResponsiveLayoutSwitch` to your UI
4. Ensure your model fields match the sort field names 