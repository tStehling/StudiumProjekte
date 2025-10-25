# Collection View System

The Collection View system provides a flexible, reusable way to display collections of items in both grid and list layouts with a built-in toggle switch. This README explains the components and how to use them in your application.

## Components

### Core Components

1. **CoreCollectionView**: The main component that displays data in either grid or list layout with a toggle switch.
2. **CoreCollectionType**: Defines the data structure for collection items using Dart records.
3. **CoreGrid**: Grid layout for displaying collection items.
4. **CoreList**: List layout for displaying collection items.
5. **LayoutSwitch**: Toggle component to switch between grid and list views.

### Model Integration Components

1. **ModelCollectionAdapter**: Adapts model entities to CoreCollectionType records.
2. **ModelCollectionView**: A high-level component that combines data fetching with CoreCollectionView for model entities.
3. **HuntingGroundFilteredModelView**: A specialized view that filters models by the selected hunting ground.

## Usage Patterns

There are four main ways to use this system:

### 1. Direct Usage with CoreCollectionView

Use this pattern when you have custom data that doesn't come from the model system:

```dart
CoreCollectionView(
  collection: _myCustomItems,
  onItemSelected: _handleItemSelected,
  gridColumns: 2,
  gridAspectRatio: 1.5,
  initialShowGrid: true,
)
```

See `example_direct_collection_usage.dart` for a complete example.

### 2. Model-Based Usage with ModelCollectionView

Use this pattern when working with data from the Brick model system:

```dart
ModelCollectionView<Animal>(
  modelHandler: animalModelHandler,
  detailViewBuilder: (context, animal) => AnimalDetailView(animal: animal),
  imagePathProvider: _getAnimalImagePath,
  subtitleProvider: _getAnimalSubtitle,
)
```

See `animal_collection_view.dart` for a complete example.

### 3. Hunting Ground Filtered Model Views

For models that should be filtered by the current hunting ground, use `HuntingGroundFilteredModelView`:

```dart
HuntingGroundFilteredModelView<Animal>(
  modelHandler: animalModelHandler,
  detailViewBuilder: (context, animal) => AnimalDetailView(animal: animal),
  imagePathProvider: _getAnimalImagePath,
  subtitleProvider: _getAnimalSubtitle,
)
```

This component:
- Automatically filters models by the currently selected hunting ground
- Shows an appropriate message when no hunting ground is selected
- Hides the floating action button when no hunting ground is selected
- Can be configured with the same options as ModelCollectionView

### 4. Custom Model Adapter Pattern

For complex scenarios, you can create your own adapter based on ModelCollectionAdapter:

```dart
class CustomModelAdapter {
  CoreCollectionItemType convertToCollectionItem(MyModel model) {
    return (
      imagePath: _getImagePath(model),
      title: model.name,
      subtitle: model.description,
    );
  }
}
```

## Configuration Options

### CoreCollectionView Options

- `collection`: List of collection items to display
- `onItemSelected`: Callback when an item is tapped
- `onItemMoreOptions`: Callback when more options button is tapped (list view only)
- `gridColumns`: Number of columns in grid view
- `gridAspectRatio`: Aspect ratio of grid items
- `listItemHeight`: Height of list items
- `showDividers`: Whether to show dividers in list view
- `padding`: Padding around the collection
- `spacing`: Spacing between items
- `initialShowGrid`: Whether to start in grid view

### ModelCollectionView Additional Options

- `modelHandler`: Handler for the model type
- `detailViewBuilder`: Builder for item detail views
- `emptyStateBuilder`: Builder for empty state
- `searchFilter`: Custom search filter function
- `initialQuery`: Initial database query
- `showSearch`: Whether to show search bar
- `autoRefresh`: Whether to auto-refresh on mount
- `floatingActionButton`: Custom FAB
- `actions`: Additional action buttons

## Examples

### Example 1: Using CoreCollectionView with Custom Data

See `example_direct_collection_usage.dart` for a complete example of using CoreCollectionView with custom data.

### Example 2: Using ModelCollectionView with Animal Models

See `animal_collection_view.dart` for a complete example of using ModelCollectionView with the Animal model.

## Migrating from EntityListView

If you're migrating from the old EntityListView, here's how parameters map:

| EntityListView | ModelCollectionView |
|----------------|-------------------|
| `modelHandler` | `modelHandler` |
| `title` | Set in scaffold |
| `viewType` | `initialShowGrid` |
| `onTap` | `detailViewBuilder` |
| `includeAppBar` | Set outside |
| `searchable` | `showSearch` |

## Performance Considerations

- Both CoreCollectionView and ModelCollectionView use a lazy loading approach.
- ModelCollectionView includes proper state management with loading indicators.
- Consider implementing pagination for large collections.

## Styling

The collection views adapt to your app's theme automatically. Key style elements:

- Grid items use cards with rounded corners
- List items have customizable height and optional dividers
- The layout switch uses the primary color for the selected mode

## Extending the System

To extend the system for custom needs:

1. Create a custom adapter by extending `ModelCollectionAdapter`
2. Create a custom view by composing with `CoreCollectionView`
3. Add new properties or behaviors as needed 