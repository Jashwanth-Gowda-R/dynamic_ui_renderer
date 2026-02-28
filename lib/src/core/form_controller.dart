import 'package:flutter/material.dart';

import 'package:dynamic_ui_renderer/dynamic_ui_renderer.dart';

typedef FormSubmitListener = void Function(Map<String, dynamic> formData);

/// Manages form state and validation
class FormController extends ChangeNotifier {
  final String? _formId;
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, bool> _touched = {};
  final Map<String, bool> _isVisible = {};
  final Map<String, List<ValidationRule>> _validations = {};
  final Map<String, FieldType> _fieldTypes = {};
  final Map<String, List<DropdownOption>> _dropdownOptions = {};
  final Map<String, bool> _requiredFields = {};
  final Map<String, dynamic> _initialValues = {};
  final List<FormSubmitListener> _formSubmitListeners = [];

  bool _isSubmitting = false;
  bool _isValid = true;
  bool _isDirty = false;

  FormController(List<FormFieldConfig> fields, {String? formId})
    : _formId = formId {
    _initializeFields(fields);
    validateAll();
  }

  void _initializeFields(List<FormFieldConfig> fields) {
    for (var field in fields) {
      final fieldName = field.name;

      _isVisible[fieldName] = true;
      _validations[fieldName] = field.validations;
      _fieldTypes[fieldName] = field.type;
      _values[fieldName] = field.initialValue;
      _initialValues[fieldName] = field.initialValue;
      _requiredFields[fieldName] = field.required;
      _errors[fieldName] = null;
      _touched[fieldName] = false;

      if (field.type == FieldType.dropdown) {
        _dropdownOptions[fieldName] = field.options ?? [];
      }

      if (field.type == FieldType.text ||
          field.type == FieldType.email ||
          field.type == FieldType.password ||
          field.type == FieldType.number ||
          field.type == FieldType.phone ||
          field.type == FieldType.textarea) {
        _textControllers[fieldName] = TextEditingController(
          text: field.initialValue?.toString() ?? '',
        );

        _textControllers[fieldName]!.addListener(() {
          _values[fieldName] = _textControllers[fieldName]!.text;
          _validateField(fieldName);
          _isDirty = true;
        });
      }
    }
  }

  // Add local listener
  // Add form submit listener (not overriding ChangeNotifier.addListener)
  void addFormSubmitListener(FormSubmitListener listener) {
    _formSubmitListeners.add(listener);
  }

  // Remove form submit listener
  void removeFormSubmitListener(FormSubmitListener listener) {
    _formSubmitListeners.remove(listener);
  }

  void _notifySubmitListeners() {
    final Map<String, dynamic> formData = Map.unmodifiable(_values);

    // Notify local listeners
    for (var listener in _formSubmitListeners) {
      listener(formData);
    }

    // Notify global callback if formId exists
    if (_formId != null) {
      final callback = DynamicUIRenderer.getFormCallback(_formId);
      if (callback != null) {
        callback(_formId, formData);
      }
    }
  }

  // Call this when form is successfully submitted
  void notifyFormSubmitted() {
    _notifySubmitListeners();
  }

  // bool _validateField(String fieldName) {
  //   if (!_isVisible[fieldName]!) return true;

  //   final value = _values[fieldName];
  //   final rules = _validations[fieldName] ?? [];
  //   final isRequired = _requiredFields[fieldName] ?? false;

  //   // Check required first
  //   if (isRequired) {
  //     if (value == null || value.toString().isEmpty) {
  //       final requiredRule = rules.firstWhere(
  //         (r) => r.type == ValidationType.required,
  //         orElse: () => ValidationRule(
  //           type: ValidationType.required,
  //           message: 'This field is required',
  //         ),
  //       );
  //       _errors[fieldName] = requiredRule.message ?? 'This field is required';
  //       return false;
  //     }
  //   }

  //   // Skip other validations if field is empty and not required
  //   if ((value == null || value.toString().isEmpty)) {
  //     _errors[fieldName] = null;
  //     return true;
  //   }

  //   for (var rule in rules) {
  //     if (rule.type == ValidationType.required) continue;

  //     final error = _applyValidation(rule, value);
  //     if (error != null) {
  //       _errors[fieldName] = error;
  //       return false;
  //     }
  //   }

  //   _errors[fieldName] = null;
  //   return true;
  // }

  // String? _applyValidation(ValidationRule rule, dynamic value) {
  //   switch (rule.type) {
  //     case ValidationType.email:
  //       final emailRegex = RegExp(
  //         r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  //       );
  //       if (!emailRegex.hasMatch(value.toString())) {
  //         return rule.message ?? 'Enter a valid email address';
  //       }
  //       break;

  //     case ValidationType.minLength:
  //       final minLength = rule.value as int;
  //       if (value.toString().length < minLength) {
  //         return rule.message ?? 'Minimum length is $minLength';
  //       }
  //       break;

  //     case ValidationType.maxLength:
  //       final maxLength = rule.value as int;
  //       if (value.toString().length > maxLength) {
  //         return rule.message ?? 'Maximum length is $maxLength';
  //       }
  //       break;

  //     case ValidationType.minValue:
  //       final minValue = (rule.value as num).toDouble();
  //       final numValue = double.tryParse(value.toString()) ?? 0;
  //       if (numValue < minValue) {
  //         return rule.message ?? 'Minimum value is $minValue';
  //       }
  //       break;

  //     case ValidationType.maxValue:
  //       final maxValue = (rule.value as num).toDouble();
  //       final numValue = double.tryParse(value.toString()) ?? 0;
  //       if (numValue > maxValue) {
  //         return rule.message ?? 'Maximum value is $maxValue';
  //       }
  //       break;

  //     case ValidationType.pattern:
  //       if (rule.pattern != null) {
  //         final pattern = RegExp(rule.pattern!);
  //         if (!pattern.hasMatch(value.toString())) {
  //           return rule.message ?? 'Invalid format';
  //         }
  //       }
  //       break;

  //     case ValidationType.match:
  //       final otherValue = _values[rule.value.toString()];
  //       if (value != otherValue) {
  //         return rule.message ?? 'Values do not match';
  //       }
  //       break;

  //     case ValidationType.url:
  //       final urlRegex = RegExp(
  //         r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  //       );
  //       if (!urlRegex.hasMatch(value.toString())) {
  //         return rule.message ?? 'Enter a valid URL';
  //       }
  //       break;

  //     case ValidationType.phone:
  //       final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
  //       if (!phoneRegex.hasMatch(value.toString())) {
  //         return rule.message ?? 'Enter a valid phone number';
  //       }
  //       break;

  //     case ValidationType.date:
  //       final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  //       if (!dateRegex.hasMatch(value.toString())) {
  //         return rule.message ?? 'Enter a valid date (YYYY-MM-DD)';
  //       }
  //       break;

  //     default:
  //       break;
  //   }

  //   return null;
  // }

  bool _validateField(String fieldName) {
    if (!_isVisible[fieldName]!) return true;

    final value = _values[fieldName];
    final rules = _validations[fieldName] ?? [];
    final isRequired = _requiredFields[fieldName] ?? false;
    final fieldType = _fieldTypes[fieldName];

    // Check required first - SPECIAL HANDLING FOR CHECKBOX
    if (isRequired) {
      if (fieldType == FieldType.checkbox) {
        // For checkbox, required means it must be true
        if (value != true) {
          final requiredRule = rules.firstWhere(
            (r) => r.type == ValidationType.required,
            orElse: () => ValidationRule(
              type: ValidationType.required,
              message: 'This field is required',
            ),
          );
          _errors[fieldName] = requiredRule.message ?? 'This field is required';
          return false;
        }
      } else {
        // For other field types, check for empty/null
        if (value == null || value.toString().isEmpty) {
          final requiredRule = rules.firstWhere(
            (r) => r.type == ValidationType.required,
            orElse: () => ValidationRule(
              type: ValidationType.required,
              message: 'This field is required',
            ),
          );
          _errors[fieldName] = requiredRule.message ?? 'This field is required';
          return false;
        }
      }
    }

    // Skip other validations if field is empty and not required (except checkbox)
    if (fieldType != FieldType.checkbox &&
        (value == null || value.toString().isEmpty)) {
      _errors[fieldName] = null;
      return true;
    }

    // Apply other validations
    for (var rule in rules) {
      if (rule.type == ValidationType.required) continue;

      final error = _applyValidation(rule, value);
      if (error != null) {
        _errors[fieldName] = error;
        return false;
      }
    }

    _errors[fieldName] = null;
    return true;
  }

  String? _applyValidation(
    ValidationRule rule,
    dynamic value,
    // FieldType? fieldType,
  ) {
    switch (rule.type) {
      case ValidationType.email:
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        if (!emailRegex.hasMatch(value.toString())) {
          return rule.message ?? 'Enter a valid email address';
        }
        break;

      case ValidationType.minLength:
        final minLength = rule.value as int;
        if (value.toString().length < minLength) {
          return rule.message ?? 'Minimum length is $minLength';
        }
        break;

      case ValidationType.maxLength:
        final maxLength = rule.value as int;
        if (value.toString().length > maxLength) {
          return rule.message ?? 'Maximum length is $maxLength';
        }
        break;

      case ValidationType.minValue:
        final minValue = (rule.value as num).toDouble();
        final numValue = double.tryParse(value.toString()) ?? 0;
        if (numValue < minValue) {
          return rule.message ?? 'Minimum value is $minValue';
        }
        break;

      case ValidationType.maxValue:
        final maxValue = (rule.value as num).toDouble();
        final numValue = double.tryParse(value.toString()) ?? 0;
        if (numValue > maxValue) {
          return rule.message ?? 'Maximum value is $maxValue';
        }
        break;

      case ValidationType.pattern:
        if (rule.pattern != null) {
          final pattern = RegExp(rule.pattern!);
          if (!pattern.hasMatch(value.toString())) {
            return rule.message ?? 'Invalid format';
          }
        }
        break;

      case ValidationType.match:
        final otherValue = _values[rule.value.toString()];
        if (value != otherValue) {
          return rule.message ?? 'Values do not match';
        }
        break;

      case ValidationType.url:
        final urlRegex = RegExp(
          r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
        );
        if (!urlRegex.hasMatch(value.toString())) {
          return rule.message ?? 'Enter a valid URL';
        }
        break;

      case ValidationType.phone:
        final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
        if (!phoneRegex.hasMatch(value.toString())) {
          return rule.message ?? 'Enter a valid phone number';
        }
        break;

      case ValidationType.date:
        final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
        if (!dateRegex.hasMatch(value.toString())) {
          return rule.message ?? 'Enter a valid date (YYYY-MM-DD)';
        }
        break;

      default:
        break;
    }

    return null;
  }

  bool validateAll() {
    bool isValid = true;

    for (var fieldName in _isVisible.keys) {
      if (_isVisible[fieldName] == true) {
        if (!_validateField(fieldName)) {
          isValid = false;
        }
      }
    }

    _isValid = isValid;
    notifyListeners();
    return isValid;
  }

  void markTouched(String fieldName) {
    _touched[fieldName] = true;
    notifyListeners();
  }

  void setValue(String fieldName, dynamic value) {
    _values[fieldName] = value;
    _validateField(fieldName);
    _isDirty = true;
    notifyListeners();
  }

  TextEditingController? getController(String fieldName) {
    return _textControllers[fieldName];
  }

  List<DropdownOption>? getDropdownOptions(String fieldName) {
    return _dropdownOptions[fieldName];
  }

  Map<String, dynamic> get values => Map.unmodifiable(_values);
  Map<String, String?> get errors => Map.unmodifiable(_errors);
  Map<String, bool> get touched => Map.unmodifiable(_touched);

  bool isVisible(String fieldName) => _isVisible[fieldName] ?? true;
  bool isTouched(String fieldName) => _touched[fieldName] ?? false;
  bool get isValid => _isValid;
  bool get isDirty => _isDirty;
  bool get isSubmitting => _isSubmitting;

  void startSubmitting() {
    _isSubmitting = true;
    notifyListeners();
  }

  void stopSubmitting() {
    _isSubmitting = false;
    notifyListeners();
  }

  void reset() {
    // Clear all text controllers
    for (var controller in _textControllers.values) {
      controller.clear();
    }

    // Reset values map for ALL fields to null (not just required fields)
    // for (var fieldName in _fieldTypes.keys) {
    //   _values[fieldName] = null;
    // }
    for (var fieldName in _fieldTypes.keys) {
      if (_fieldTypes[fieldName] == FieldType.checkbox) {
        _values[fieldName] = false; // Checkboxes reset to false, not null
      } else {
        _values[fieldName] = null;
      }
    }

    // Clear all errors and touched states
    _errors.clear();
    _touched.clear();

    // Reinitialize errors and touched for all fields
    for (var fieldName in _fieldTypes.keys) {
      _errors[fieldName] = null;
      _touched[fieldName] = false;
    }

    // Reset state flags
    _isDirty = false;
    _isValid = true;

    // Trigger a full rebuild of all form fields
    notifyListeners();
  }

  void resetToInitial() {
    // Reset to initial values instead of null
    for (var fieldName in _fieldTypes.keys) {
      _values[fieldName] = _initialValues[fieldName];

      // Update text controllers if they exist
      if (_textControllers.containsKey(fieldName)) {
        _textControllers[fieldName]?.text =
            _initialValues[fieldName]?.toString() ?? '';
      }
    }

    // Clear all errors and touched states
    _errors.clear();
    _touched.clear();

    // Reinitialize errors and touched for all fields
    for (var fieldName in _fieldTypes.keys) {
      _errors[fieldName] = null;
      _touched[fieldName] = false;
    }

    // Reset state flags
    _isDirty = false;
    _isValid = true;

    // Trigger a full rebuild
    notifyListeners();
  }

  void updateVisibility(String fieldName, bool visible) {
    if (_isVisible[fieldName] != visible) {
      _isVisible[fieldName] = visible;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
