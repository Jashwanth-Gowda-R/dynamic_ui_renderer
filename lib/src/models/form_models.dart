/// Types of form fields supported
enum FieldType {
  text,
  email,
  password,
  number,
  dropdown,
  checkbox,
  radio,
  date,
  phone,
  textarea,
  time,
  datetime,
}

/// Validation rule types
enum ValidationType {
  required,
  email,
  minLength,
  maxLength,
  minValue,
  maxValue,
  pattern,
  match,
  url,
  phone,
  date,
  custom,
}

/// Represents a form field configuration
class FormFieldConfig {
  final String name;
  final FieldType type;
  final String? label;
  final String? hint;
  final dynamic initialValue;
  final bool required;
  final String? requiredMessage;
  final List<ValidationRule> validations;
  final Map<String, dynamic>? uiProperties;
  final List<DropdownOption>? options;
  final Map<String, dynamic>? conditionalLogic;
  final int? order;
  final double? width;
  final String? placeholder;

  FormFieldConfig({
    required this.name,
    required this.type,
    this.label,
    this.hint,
    this.initialValue,
    this.required = false,
    this.requiredMessage,
    this.validations = const [],
    this.uiProperties,
    this.options,
    this.conditionalLogic,
    this.order,
    this.width,
    this.placeholder,
  });

  factory FormFieldConfig.fromJson(Map<String, dynamic> json) {
    return FormFieldConfig(
      name: json['name'] as String,
      type: _parseFieldType(json['type'] as String),
      label: json['label'] as String?,
      hint: json['hint'] as String?,
      initialValue: json['initialValue'],
      required: json['required'] as bool? ?? false,
      requiredMessage: json['requiredMessage'] as String?,
      validations:
          (json['validations'] as List?)
              ?.map((v) => ValidationRule.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      uiProperties: json['uiProperties'] as Map<String, dynamic>?,
      options: (json['options'] as List?)
          ?.map((o) => DropdownOption.fromJson(o as Map<String, dynamic>))
          .toList(),
      conditionalLogic: json['conditionalLogic'] as Map<String, dynamic>?,
      order: json['order'] as int?,
      width: json['width']?.toDouble(),
      placeholder: json['placeholder'] as String?,
    );
  }

  static FieldType _parseFieldType(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return FieldType.text;
      case 'email':
        return FieldType.email;
      case 'password':
        return FieldType.password;
      case 'number':
        return FieldType.number;
      case 'dropdown':
        return FieldType.dropdown;
      case 'checkbox':
        return FieldType.checkbox;
      case 'radio':
        return FieldType.radio;
      case 'date':
        return FieldType.date;
      case 'phone':
        return FieldType.phone;
      case 'textarea':
        return FieldType.textarea;
      case 'time':
        return FieldType.time;
      case 'datetime':
        return FieldType.datetime;
      case 'tel':
        return FieldType.phone;
      default:
        return FieldType.text;
    }
  }

  bool shouldShow(Map<String, dynamic> formValues) {
    if (conditionalLogic == null) return true;

    final field = conditionalLogic!['field'] as String?;
    final value = conditionalLogic!['value'];
    final operator = conditionalLogic!['operator'] as String? ?? 'equals';

    if (field == null || !formValues.containsKey(field)) return true;

    final fieldValue = formValues[field];

    switch (operator) {
      case 'equals':
        return fieldValue == value;
      case 'notEquals':
        return fieldValue != value;
      case 'contains':
        return fieldValue?.toString().contains(value?.toString() ?? '') ??
            false;
      case 'greaterThan':
        return (fieldValue as num?)!.toDouble() > (value as num?)!.toDouble();
      case 'lessThan':
        return (fieldValue as num?)!.toDouble() < (value as num?)!.toDouble();
      default:
        return true;
    }
  }
}

/// Represents a validation rule
class ValidationRule {
  final ValidationType type;
  final dynamic value;
  final String? message;
  final String? pattern;
  final Map<String, dynamic>? customConfig;

  ValidationRule({
    required this.type,
    this.value,
    this.message,
    this.pattern,
    this.customConfig,
  });

  factory ValidationRule.fromJson(Map<String, dynamic> json) {
    return ValidationRule(
      type: _parseValidationType(json['type'] as String),
      value: json['value'],
      message: json['message'] as String?,
      pattern: json['pattern'] as String?,
      customConfig: json['customConfig'] as Map<String, dynamic>?,
    );
  }

  static ValidationType _parseValidationType(String type) {
    switch (type.toLowerCase()) {
      case 'required':
        return ValidationType.required;
      case 'email':
        return ValidationType.email;
      case 'minlength':
        return ValidationType.minLength;
      case 'maxlength':
        return ValidationType.maxLength;
      case 'minvalue':
        return ValidationType.minValue;
      case 'maxvalue':
        return ValidationType.maxValue;
      case 'pattern':
        return ValidationType.pattern;
      case 'match':
        return ValidationType.match;
      case 'url':
        return ValidationType.url;
      case 'phone':
        return ValidationType.phone;
      case 'date':
        return ValidationType.date;
      case 'custom':
        return ValidationType.custom;
      default:
        return ValidationType.required;
    }
  }
}

/// Represents a dropdown option
class DropdownOption {
  final String label;
  final dynamic value;
  final Map<String, dynamic>? icon;
  final bool? disabled;

  DropdownOption({
    required this.label,
    required this.value,
    this.icon,
    this.disabled,
  });

  factory DropdownOption.fromJson(Map<String, dynamic> json) {
    return DropdownOption(
      label: json['label'] as String,
      value: json['value'],
      icon: json['icon'] as Map<String, dynamic>?,
      disabled: json['disabled'] as bool?,
    );
  }
}
