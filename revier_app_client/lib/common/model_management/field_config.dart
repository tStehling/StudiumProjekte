import 'package:flutter/material.dart';

/// Types of form fields that can be rendered.
enum FieldType {
  text,
  number,
  date,
  dateTime,
  boolean,
  dropdown,
  multiSelect,

  /// Use this field type for relations between entities.
  ///
  /// When handling relations, the field often stores just the ID of the related entity.
  /// To properly set the relation, implement the `setRelationFieldValue` method in your
  /// `ModelHandler` implementation to fetch and set the complete related entity.
  relation,
  location,
  custom
}

/// Configuration for a model field in forms and detail views.
class FieldConfig {
  /// The display label for the field.
  final String label;

  /// Optional hint text for the field.
  final String? hint;

  /// Whether the field can be edited in forms.
  final bool isEditable;

  /// Whether the field is required.
  final bool isRequired;

  /// Whether the field is visible in detail view.
  final bool isVisibleInDetail;

  /// The type of UI field to render.
  final FieldType fieldType;

  /// Optional formatter function for display values.
  final String Function(dynamic value)? formatter;

  /// Optional validator function.
  final String? Function(dynamic value)? validator;

  /// Options for dropdown/multiselect fields.
  final List<DropdownOption>? options;

  /// Function to load options asynchronously (for relations).
  final Future<List<DropdownOption>> Function()? optionsLoader;

  /// Optional icon to display with the field.
  final IconData? icon;

  /// Custom widget builder for complex fields.
  final Widget Function(
          BuildContext context, dynamic value, ValueChanged<dynamic> onChanged)?
      customFieldBuilder;

  const FieldConfig({
    required this.label,
    this.hint,
    this.isEditable = true,
    this.isRequired = false,
    this.isVisibleInDetail = true,
    this.fieldType = FieldType.text,
    this.formatter,
    this.validator,
    this.options,
    this.optionsLoader,
    this.icon,
    this.customFieldBuilder,
  });

  /// Creates a copy of this FieldConfig with the given fields replaced.
  FieldConfig copyWith({
    String? label,
    String? hint,
    bool? isEditable,
    bool? isRequired,
    bool? isVisibleInDetail,
    FieldType? fieldType,
    String Function(dynamic value)? formatter,
    String? Function(dynamic value)? validator,
    List<DropdownOption>? options,
    Future<List<DropdownOption>> Function()? optionsLoader,
    IconData? icon,
    Widget Function(BuildContext context, dynamic value,
            ValueChanged<dynamic> onChanged)?
        customFieldBuilder,
  }) {
    return FieldConfig(
      label: label ?? this.label,
      hint: hint ?? this.hint,
      isEditable: isEditable ?? this.isEditable,
      isRequired: isRequired ?? this.isRequired,
      isVisibleInDetail: isVisibleInDetail ?? this.isVisibleInDetail,
      fieldType: fieldType ?? this.fieldType,
      formatter: formatter ?? this.formatter,
      validator: validator ?? this.validator,
      options: options ?? this.options,
      optionsLoader: optionsLoader ?? this.optionsLoader,
      icon: icon ?? this.icon,
      customFieldBuilder: customFieldBuilder ?? this.customFieldBuilder,
    );
  }
}

/// Option for dropdown and multiselect fields.
class DropdownOption<T> {
  /// The value to use when this option is selected.
  final T value;

  /// The text to display for this option.
  final String label;

  /// Optional subtitle for more complex dropdowns.
  final String? subtitle;

  /// Optional icon to display with the option.
  final IconData? icon;

  const DropdownOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}
