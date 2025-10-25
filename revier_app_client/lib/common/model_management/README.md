# Model Management System

This system provides a generic way to manage model entities with reusable components for listing, viewing, editing, and creating entities. The implementation follows a clean architecture pattern with separation of concerns.

## Key Components

### ModelHandler

The `ModelHandler<T>` interface defines the contract for handling model operations and configuration. Each model type should implement this interface.

```dart
class MyModelHandler implements ModelHandler<MyModel> {
  // Implementation...
}
```

### Field Configuration

`FieldConfig` allows you to configure how each field in your model should be displayed and edited. It supports various field types and validations.

```dart
Map<String, FieldConfig> get fieldConfigurations => {
  'name': FieldConfig(
    label: 'Name',
    isRequired: true,
    fieldType: FieldType.text,
  ),
  // More fields...
};
```

### Reusable Views

1. **EntityListView**: Displays a list of entities with search functionality
2. **EntityDetailView**: Shows details of an entity
3. **EntityFormView**: Form for creating or editing an entity

## How to Implement for Your Model

1. Create a model handler that implements `ModelHandler<YourModel>`
2. Configure the field configurations
3. Use the generic views in your feature's UI

## Example Usage

### Model Handler

```dart
class AnimalModelHandler implements ModelHandler<Animal> {
  @override
  String get modelTitle => 'Animal';

  @override
  List<String> get listDisplayFields => ['name', 'species'];

  @override
  Map<String, FieldConfig> get fieldConfigurations => {
    'name': FieldConfig(
      label: 'Name',
      isRequired: true,
    ),
    // More field configurations...
  };

  // Implement other required methods...
}
```

### List View

```dart
EntityListView<Animal>(
  modelHandler: AnimalModelHandler(),
  onEntityTap: (animal) => _viewAnimalDetails(animal),
  listViewType: ListViewType.grid,
)
```

### Detail View

```dart
EntityDetailView<Animal>(
  modelHandler: AnimalModelHandler(),
  entity: animal,
  onEdit: () => _editAnimal(animal),
  onDelete: () => _deleteAnimal(animal),
)
```

### Form View

```dart
EntityFormView<Animal>(
  modelHandler: AnimalModelHandler(),
  entity: animal, // Null for create mode
  onSave: (savedAnimal) => _handleSave(savedAnimal),
)
```

## Handling Relation Fields

When working with Brick models, relations are often defined with getter methods for IDs. To properly handle setting relations by ID:

1. Use `FieldType.relation` for relation fields in your field configuration
2. Implement the `setRelationFieldValue` method in your model handler:

```dart
@override
Future<MyModel> setRelationFieldValue(
  WidgetRef ref,
  MyModel entity,
  String fieldName,
  String relationId,
) async {
  switch (fieldName) {
    case 'relationEntityId':
      final repository = ref.read(getModelRegistry(ref).getRepositoryProvider<RelatedEntity>());
      final relatedEntity = await repository.getById(relationId);
      return relatedEntity != null 
        ? entity.copyWith(relatedEntity: relatedEntity) 
        : entity;
    default:
      return entity;
  }
}
```

The form view will automatically detect relation fields and use this method instead of the standard `setFieldValue` method.

## Customization

Each generic view accepts a variety of customization options, including:

- Custom actions in app bars
- Grid or list layouts
- Custom field rendering
- Validation logic

Refer to each class's documentation for more details.

## Adding Custom Field Types

To add custom field types beyond what's provided:

1. Add a new value to the `FieldType` enum
2. Use the `customFieldBuilder` property in `FieldConfig` to create your custom field UI
3. Handle the value appropriately in your model handler's `setFieldValue` and `getFieldValue` methods 