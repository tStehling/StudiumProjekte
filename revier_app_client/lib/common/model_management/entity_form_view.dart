import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'model_handler.dart';
import 'field_config.dart';
import 'package:revier_app_client/localization/app_localizations.dart';
import 'package:revier_app_client/core/services/logging_service.dart';

/// A generic form view for creating or editing entities.
///
/// This widget provides a form with fields based on the model's configuration
/// and handles validation, saving, and cancellation.
class EntityFormView<T extends OfflineFirstWithSupabaseModel>
    extends ConsumerStatefulWidget {
  /// The handler for the model type.
  final ModelHandler<T> modelHandler;

  /// The entity to edit (null for create mode).
  final T? entity;

  /// Callback when the form is saved successfully.
  final void Function(T entity) onSave;

  /// Callback when the form is cancelled.
  final void Function()? onCancel;

  /// Additional actions to display in the app bar.
  final List<Widget>? actions;

  const EntityFormView({
    super.key,
    required this.modelHandler,
    this.entity,
    required this.onSave,
    this.onCancel,
    this.actions,
  });

  @override
  ConsumerState<EntityFormView<T>> createState() => _EntityFormViewState<T>();
}

class _EntityFormViewState<T extends OfflineFirstWithSupabaseModel>
    extends ConsumerState<EntityFormView<T>> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formValues = {};
  bool _isLoading = false;
  bool _hasChanges = false;
  late final _log = loggingService.getLogger('EntityFormView<${T.toString()}>');

  @override
  void initState() {
    super.initState();
    _log.debug('Initializing form for ${widget.modelHandler.modelTitle}');
    _initFormValues();
  }

  void _initFormValues() {
    if (widget.entity == null) {
      // Create mode - initialize with defaults
      _log.debug('Create mode: initializing with empty values');
      _formValues = {};
    } else {
      // Edit mode - initialize with entity values
      _log.debug('Edit mode: initializing with existing entity values');
      _formValues = {};
      widget.modelHandler.fieldConfigurations.forEach((fieldName, config) {
        if (config.isEditable) {
          final value =
              widget.modelHandler.getFieldValue(widget.entity!, fieldName);
          _formValues[fieldName] = value;
          _log.debug('Loaded field "$fieldName" with value: $value');
        }
      });
    }
  }

  void _updateFormValue(String fieldName, dynamic value) {
    _log.debug(
        'Updating field "$fieldName" with value: $value (type: ${value?.runtimeType})');

    // Check if this is a relation field
    final fieldConfig = widget.modelHandler.fieldConfigurations[fieldName];
    if (fieldConfig?.fieldType == FieldType.relation) {
      _log.debug('Field "$fieldName" is a relation field');
    }

    setState(() {
      _formValues[fieldName] = value;
      _hasChanges = true;
    });
  }

  Future<void> _saveForm() async {
    _log.debug('Form save initiated');
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      _log.debug('Form validation passed, saving entity');

      setState(() {
        _isLoading = true;
      });

      try {
        // Create a new entity or update the existing one
        T entity;
        if (widget.entity == null) {
          // Create mode
          _log.debug('Creating new ${widget.modelHandler.modelTitle}');
          entity = await widget.modelHandler.createNew();
        } else {
          // Edit mode
          _log.debug(
              'Updating existing ${widget.modelHandler.modelTitle} with ID: ${widget.modelHandler.getEntityId(widget.entity!)}');
          entity = widget.entity!;
        }

        // Apply form values to the entity
        _log.debug('Applying form values to entity');
        for (final entry in _formValues.entries) {
          final fieldName = entry.key;
          final value = entry.value;
          _log.debug(
              'Processing field "$fieldName" with value: $value (type: ${value?.runtimeType})');

          // Handle relation fields differently
          final fieldConfig =
              widget.modelHandler.fieldConfigurations[fieldName];
          _log.debug(
              'Field "$fieldName" config: fieldType=${fieldConfig?.fieldType}');

          // Special handling for relation fields - use setRelationFieldValue for any field
          // configured as a relation, regardless of its current value (including null/empty)
          if (fieldConfig != null &&
              fieldConfig.fieldType == FieldType.relation) {
            _log.debug(
                'Setting relation field "$fieldName" with value: $value');

            // Convert the value to a string ID or empty string if null
            String relationId = '';
            if (value != null) {
              if (value is String) {
                relationId = value;
              } else {
                relationId = value.toString();
              }
            }

            _log.debug('Relation ID for "$fieldName": "$relationId"');

            // For relation fields, we need to fetch the related entity
            entity = await widget.modelHandler.setRelationFieldValue(
              ref,
              entity,
              fieldName,
              relationId,
            );
          } else if (fieldConfig != null &&
              fieldConfig.fieldType == FieldType.custom) {
            // Special handling for custom fields
            _log.debug('Setting custom field "$fieldName" with value: $value');

            // Use setFieldValue for custom fields
            entity =
                widget.modelHandler.setFieldValue(entity, fieldName, value);
          } else {
            // For regular fields, use the standard setFieldValue method
            _log.debug('Setting regular field "$fieldName" with value: $value');
            entity =
                widget.modelHandler.setFieldValue(entity, fieldName, value);
          }
        }

        // Validate the entity
        final validationErrors = mounted
            ? widget.modelHandler.validate(
                entity,
                context,
              )
            : widget.modelHandler.validate(entity);

        if (validationErrors.isNotEmpty) {
          // Show validation errors
          _log.warning('Validation errors: $validationErrors');
          _showValidationErrors(validationErrors);
          return;
        }

        // Save the entity
        _log.debug('Saving entity to repository');
        final savedEntity = await widget.modelHandler.save(ref, entity);
        _log.info(
            'Entity saved successfully with ID: ${widget.modelHandler.getEntityId(savedEntity)}');

        // Call the onSave callback
        widget.onSave(savedEntity);
      } catch (e) {
        _log.error('Error saving entity', error: e);
        if (mounted) {
          // Handle error
          _showErrorDialog(
              'Error saving ${widget.modelHandler.modelTitle.toLowerCase()}',
              e.toString());
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      _log.warning('Form validation failed');
    }
  }

  void _showValidationErrors(Map<String, String?> errors) {
    _log.debug('Showing validation errors dialog');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Errors'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errors.entries
                .where((e) => e.value != null)
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('${e.key}: ${e.value}'),
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    _log.debug('Showing error dialog: $title - $message');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDiscard(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (!_hasChanges) {
      _log.debug('No changes to discard, allowing navigation');
      return true;
    }

    _log.debug('Showing discard changes confirmation dialog');
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.discardChanges),
        content: Text(l10n.unsavedDiscardWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );

    final shouldDiscard = result ?? false;
    _log.debug('User chose to ${shouldDiscard ? 'discard' : 'keep'} changes');
    return shouldDiscard;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    _log.debug('Building form UI for ${widget.modelHandler.modelTitle}');
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) return;

        final canPop = await _confirmDiscard(context);
        if (canPop && context.mounted) {
          _log.debug('Navigating away from form');
          if (widget.onCancel != null) {
            widget.onCancel!();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.entity == null
              ? '${l10n.wordNew} ${widget.modelHandler.modelTitle}'
              : '${l10n.edit} ${widget.modelHandler.modelTitle}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : _saveForm,
            ),
            if (widget.actions != null) ...widget.actions!,
          ],
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final canPop = await _confirmDiscard(context);
              if (canPop && context.mounted) {
                _log.debug('Canceling form');
                if (widget.onCancel != null) {
                  widget.onCancel!();
                } else {
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildFormFields(),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    final fields = <Widget>[];
    final fieldConfigs = widget.modelHandler.getFieldConfigurations(ref);

    for (final entry in fieldConfigs.entries) {
      final fieldName = entry.key;
      final config = entry.value;

      // Skip non-editable fields
      if (!config.isEditable) {
        continue;
      }

      // Get the current value from form values or default
      dynamic value = _formValues[fieldName];

      fields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildFormField(fieldName, config, value),
        ),
      );
    }

    return fields;
  }

  Widget _buildFormField(String fieldName, FieldConfig config, dynamic value) {
    final l10n = AppLocalizations.of(context);
    _log.debug(
        'Building form field "$fieldName" with value: $value (type: ${value?.runtimeType})');

    // Use config.customFieldBuilder if provided
    if (config.customFieldBuilder != null) {
      _log.debug('Using custom field builder for "$fieldName"');
      return config.customFieldBuilder!(
        context,
        value,
        (newValue) => _updateFormValue(fieldName, newValue),
      );
    }

    switch (config.fieldType) {
      case FieldType.text:
        return TextFormField(
          initialValue: value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: config.label,
            hintText: config.hint,
            prefixIcon: config.icon != null ? Icon(config.icon) : null,
          ),
          validator: config.validator != null
              ? (value) => config.validator!(value)
              : (value) {
                  if (config.isRequired && (value == null || value.isEmpty)) {
                    return '${config.label} ${l10n.isRequired}';
                  }
                  return null;
                },
          onChanged: (value) => _updateFormValue(fieldName, value),
        );

      case FieldType.number:
        return TextFormField(
          initialValue: value?.toString() ?? '',
          decoration: InputDecoration(
            labelText: config.label,
            hintText: config.hint,
            prefixIcon: config.icon != null ? Icon(config.icon) : null,
          ),
          keyboardType: TextInputType.number,
          validator: config.validator != null
              ? (value) => config.validator!(value)
              : (value) {
                  if (config.isRequired && (value == null || value.isEmpty)) {
                    return '${config.label} ${l10n.isRequired}';
                  }
                  if (value != null && value.isNotEmpty) {
                    final n = num.tryParse(value);
                    if (n == null) {
                      return l10n.plsEnterValNum;
                    }
                  }
                  return null;
                },
          onChanged: (value) {
            final n = num.tryParse(value);
            _updateFormValue(fieldName, n);
          },
        );

      case FieldType.date:
      case FieldType.dateTime:
        return _buildDateTimeField(
          context,
          fieldName,
          config,
          value,
          config.fieldType == FieldType.dateTime,
        );

      case FieldType.boolean:
        return CheckboxListTile(
          title: Text(config.label),
          subtitle: config.hint != null ? Text(config.hint!) : null,
          value: value ?? false,
          secondary: config.icon != null ? Icon(config.icon) : null,
          onChanged: (newValue) => _updateFormValue(fieldName, newValue),
        );

      case FieldType.dropdown:
        return _buildDropdownField(context, fieldName, config, value);

      case FieldType.relation:
        return _buildRelationField(context, fieldName, config, value);

      case FieldType.location:
        // A more complex location picker would be needed here
        _log.warning(
            'Location picker not fully implemented for field "$fieldName"');
        return const Text('Location picker not implemented');

      default:
        _log.warning(
            'Unsupported field type for field "$fieldName": ${config.fieldType}');
        return const Text('Unsupported field type');
    }
  }

  Widget _buildDateTimeField(
    BuildContext context,
    String fieldName,
    FieldConfig config,
    DateTime? initialValue,
    bool includeTime,
  ) {
    _log.debug(
        'Building date/time field "$fieldName" with includeTime=$includeTime');
    final l10n = AppLocalizations.of(context);
    final dateFormat =
        includeTime ? DateFormat('yyyy-MM-dd HH:mm') : DateFormat('yyyy-MM-dd');

    final displayValue =
        initialValue != null ? dateFormat.format(initialValue) : '';

    return FormField<DateTime>(
      initialValue: initialValue,
      validator: (value) {
        if (config.isRequired && value == null) {
          return '${config.label} ${l10n.isRequired}';
        }
        return config.validator != null ? config.validator!(value) : null;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: config.icon != null
                  ? Icon(config.icon)
                  : const Icon(Icons.calendar_today),
              title: Text(config.label),
              subtitle: Text(displayValue.isEmpty
                  ? config.hint ?? l10n.selectDate
                  : displayValue),
              onTap: () async {
                _log.debug('Opening date picker for "$fieldName"');
                // Use a local function to handle date selection
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: initialValue ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                // Check if the widget is still mounted and if a date was picked
                if (!mounted || picked == null) {
                  _log.debug('Date selection canceled for "$fieldName"');
                  return;
                }
                _log.debug('Date selected for "$fieldName": $picked');

                // Handle time selection if needed
                if (includeTime) {
                  _log.debug('Opening time picker for "$fieldName"');
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: initialValue != null
                        ? TimeOfDay.fromDateTime(initialValue)
                        : TimeOfDay.now(),
                  );

                  // Check if the widget is still mounted and if a time was picked
                  if (!mounted || pickedTime == null) {
                    _log.debug('Time selection canceled for "$fieldName"');
                    return;
                  }
                  _log.debug('Time selected for "$fieldName": $pickedTime');

                  // Create the complete date time and update the form
                  final DateTime dateTime = DateTime(
                    picked.year,
                    picked.month,
                    picked.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  _updateFormValue(fieldName, dateTime);
                } else {
                  // If no time needed, just update with the date
                  _updateFormValue(fieldName, picked);
                }
              },
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    String fieldName,
    FieldConfig config,
    dynamic value,
  ) {
    _log.debug(
        'Building dropdown field "$fieldName" with ${config.options?.length ?? 0} options');
    final l10n = AppLocalizations.of(context);
    if (config.options == null || config.options!.isEmpty) {
      _log.warning('No options available for dropdown field "$fieldName"');
      return Text(l10n.noOptionsAvailable);
    }

    return DropdownButtonFormField<dynamic>(
      value: value,
      decoration: InputDecoration(
        labelText: config.label,
        hintText: config.hint,
        prefixIcon: config.icon != null ? Icon(config.icon) : null,
      ),
      items: config.options!.map((option) {
        return DropdownMenuItem<dynamic>(
          value: option.value,
          child: Text(option.label),
        );
      }).toList(),
      validator: (value) {
        if (config.isRequired && value == null) {
          return '${config.label} ${l10n.isRequired}';
        }
        return config.validator != null ? config.validator!(value) : null;
      },
      onChanged: (newValue) => _updateFormValue(fieldName, newValue),
    );
  }

  Widget _buildRelationField(
    BuildContext context,
    String fieldName,
    FieldConfig config,
    dynamic value,
  ) {
    _log.debug(
        'Building relation field "$fieldName" with current value: $value');
    final l10n = AppLocalizations.of(context);
    // For relation fields, we'll use a FutureBuilder to load options asynchronously
    if (config.optionsLoader == null) {
      _log.warning(
          'No options loader provided for relation field "$fieldName"');
      return const Text('no option loader provided');
    }

    _log.debug('Loading relation options for "$fieldName"');
    return FutureBuilder<List<DropdownOption>>(
      future: config.optionsLoader!(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _log.debug('Loading options for relation field "$fieldName"');
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          _log.error('Error loading options for relation field "$fieldName"',
              error: snapshot.error);
          return Text('Error: ${snapshot.error}');
        }

        final options = snapshot.data ?? [];
        _log.debug(
            'Loaded ${options.length} options for relation field "$fieldName"');
        if (options.isEmpty) {
          _log.warning('No relation options available for field "$fieldName"');
          return Text(l10n.noOptionsAvailable);
        }

        return DropdownButtonFormField<dynamic>(
          value: value,
          decoration: InputDecoration(
            labelText: config.label,
            hintText: config.hint,
            prefixIcon: config.icon != null ? Icon(config.icon) : null,
          ),
          items: options.map((option) {
            return DropdownMenuItem<dynamic>(
              value: option.value,
              child: Text(option.label),
            );
          }).toList(),
          validator: (value) {
            if (config.isRequired && value == null) {
              return '${config.label} ${l10n.isRequired}';
            }
            return config.validator != null ? config.validator!(value) : null;
          },
          onChanged: (newValue) => _updateFormValue(fieldName, newValue),
        );
      },
    );
  }
}
