# Generic Sorting and Layout System

This system provides a reusable, type-safe way to manage sorting and layout options across different model collections in the app. It uses Riverpod for state management and SharedPreferences for persistence.

## Key Components

### SortSettings

The `SortSettings` class represents the current sort state:

```dart
class SortSettings {
  final String field;
  final bool ascending;
  // ...
}
```

### SortSettingsNotifier

The `SortSettingsNotifier` manages changes to sort settings and persists them:

```dart
class SortSettingsNotifier extends StateNotifier<SortSettings> {
  // ...
  Future<void> setSortField(String field, {bool? direction}) async { /*...*/ }
  Future<void> toggleDirection() async { /*...*/ }
}
```

### ViewModeNotifier

The `ViewModeNotifier` manages grid/list view preferences:

```dart
class ViewModeNotifier extends StateNotifier<bool> {
  // ...
  Future<void> toggleViewMode() async { /*...*/ }
}
```

### ResponsiveLayoutSwitch

The `ResponsiveLayoutSwitch` widget provides UI for sorting and layout controls.

## How to Use

### 1. Create Providers

For each model type, create dedicated providers:

```dart
// In your_model_providers.dart
import 'package:revier_app_client/common/model_management/sort_provider.dart';

// Sort labels specific to this model
final yourModelSortLabelsProvider = createSortLabelsProvider({
  'updatedAt': 'Recently Updated',
  'createdAt': 'Date Created',
  'name': 'Name',
  // Add custom fields for this model
  'customField': 'Custom Field Label',
});

// Sort settings provider
final yourModelSortProvider = createSortProvider(
  'your_model_collection', // Unique key for persistence
  defaultField: 'updatedAt',
  defaultAscending: false,
);

// View mode provider (grid vs list)
final yourModelViewModeProvider = createViewModeProvider(
  'your_model_collection', // Same key for consistent persistence
  defaultIsGrid: true,
);
```

### 2. Use in Your Collection View

```dart
class YourModelCollectionView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for sort settings and view mode changes
    final sortSettings = ref.watch(yourModelSortProvider);
    final isGrid = ref.watch(yourModelViewModeProvider);
    final viewModeNotifier = ref.read(yourModelViewModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Models'),
        actions: [
          // Add the responsive layout switch to your app bar
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ResponsiveLayoutSwitch(
              onToggle: (isGridMode) => viewModeNotifier.toggleViewMode(),
              isGrid: isGrid,
              sortProvider: yourModelSortProvider,
              sortLabelsProvider: yourModelSortLabelsProvider,
            ),
          ),
        ],
      ),
      body: HuntingGroundFilteredModelView<YourModel>(
        // ...other parameters
        
        // Use the view mode from the provider
        initialShowGrid: isGrid,
        
        // Disable the built-in layout switch
        showLayoutSwitch: false,
        
        // Connect to the sort provider
        onExternalSort: (field, ascending) {
          ref.read(yourModelSortProvider.notifier).setSortField(
                field, 
                direction: ascending
              );
        },
      ),
    );
  }
}
```

## Benefits

1. **Consistent UX**: The same sort and layout controls across the app
2. **Persistence**: User preferences are automatically saved 
3. **Type Safety**: Fully type-safe with Riverpod
4. **Separation of Concerns**: Clear separation between UI, state, and persistence
5. **Reusability**: No need to reimplement for each model type

## Integration with Model Collections

The system integrates with the existing `ModelCollectionView` through:

1. The `showLayoutSwitch` parameter to disable the built-in layout switch
2. The `onExternalSort` callback to connect to sort providers
3. The `initialShowGrid` parameter to respect view mode preferences

This approach allows for a gradual adoption in existing screens. 