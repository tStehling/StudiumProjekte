import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart'
    show OfflineFirstWithSupabaseModel;
import 'package:flutter/material.dart';
import 'package:revier_app_client/common/widgets/buttons/extended_floating_action_button.dart';
import 'model_handler.dart';
import 'field_config.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// A generic detail view for displaying entity information.
///
/// This widget displays the details of an entity in a read-only format
/// and provides actions to edit or delete the entity.
class EntityDetailView<T extends OfflineFirstWithSupabaseModel>
    extends StatelessWidget {
  /// The handler for the model type.
  final ModelHandler<T> modelHandler;

  /// The entity to display.
  final T entity;

  /// Callback when the edit button is tapped.
  final void Function() onEdit;

  /// Callback when the delete button is tapped.
  final void Function()? onDelete;

  /// Additional actions to display in the app bar.
  final List<Widget>? actions;

  const EntityDetailView({
    super.key,
    required this.modelHandler,
    required this.entity,
    required this.onEdit,
    this.onDelete,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${modelHandler.modelTitle} Details'),
        actions: [
          if (actions != null) ...actions!,
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildDetailFields(context),
        ),
      ),
      floatingActionButton: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() {
    return ExtendedFloatingActionButton(
      type: ButtonType.edit,
      isFlyoutMode: onDelete != null || onEdit != null,
      flyoutButtons: [
        if (onDelete != null)
          FlyoutButtonItem(
            type: ButtonType.delete,
            onPressed: onDelete!,
            flyoutDirection: FlyoutDirection.up,
          ),
        if (onEdit != null)
          FlyoutButtonItem(
            type: ButtonType.edit,
            onPressed: onEdit,
            flyoutDirection: FlyoutDirection.left,
          ),
      ],
    );
  }

  List<Widget> _buildDetailFields(BuildContext context) {
    final fields = <Widget>[];
    final fieldConfigs = modelHandler.fieldConfigurations;

    // Get list of field names from the configuration
    fieldConfigs.forEach((fieldName, config) {
      // Skip fields that shouldn't be visible in detail view
      if (!config.isVisibleInDetail) {
        return; // Skip this field
      }

      // Get the value using the model handler's getFieldValue method
      final value = modelHandler.getFieldValue(entity, fieldName);

      // Skip null values and empty values for non-required fields
      if (value == null && !config.isRequired) {
        return; // Skip this field
      }

      // Build the field widget and add it to the list
      fields.add(
        _buildDetailField(context, fieldName, value, config),
      );
      fields.add(const SizedBox(height: 16));
    });

    return fields;
  }

  Widget _buildDetailField(
    BuildContext context,
    String fieldName,
    dynamic value,
    FieldConfig config,
  ) {
    if (value == null) {
      return const SizedBox.shrink();
    }

    String displayValue;
    Widget? customWidget;
    final l10n = AppLocalizations.of(context);

    // Handle different field types appropriately
    switch (config.fieldType) {
      case FieldType.relation:
        // Use modelHandler's formatDisplayValue specifically for relations
        displayValue = modelHandler.formatDisplayValue(fieldName, value);
        break;
      case FieldType.boolean:
        displayValue = value == true ? 'Yes' : 'No';
        break;
      case FieldType.date:
      case FieldType.dateTime:
        if (value is DateTime) {
          displayValue = config.formatter != null
              ? config.formatter!(value)
              : _formatDateTime(value, config.fieldType == FieldType.dateTime);
        } else {
          displayValue = value.toString();
        }
        break;
      case FieldType.location:
        if (value is Map) {
          displayValue =
              'Lat: ${value['latitude']}, Lng: ${value['longitude']}';
        } else {
          displayValue = modelHandler.formatDisplayValue(fieldName, value);
        }
        break;
      case FieldType.custom:
        // For custom fields, we might want to render a specialized view
        if (config.formatter != null) {
          displayValue = config.formatter!(value);
        } else {
          displayValue = modelHandler.formatDisplayValue(fieldName, value);
        }
        break;
      default:
        // Use the model handler's formatter first, or custom formatter if available
        if (config.formatter != null) {
          displayValue = config.formatter!(value);
        } else {
          displayValue = modelHandler.formatDisplayValue(fieldName, value);
        }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 4),
        if (customWidget != null)
          customWidget
        else
          Text(
            displayValue,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime, bool includeTime) {
    if (includeTime) {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  }
}
