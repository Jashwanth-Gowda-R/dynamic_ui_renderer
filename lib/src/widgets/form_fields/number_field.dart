import 'package:flutter/material.dart';

import 'package:dynamic_ui_renderer/src/core/form_controller.dart';
import 'package:dynamic_ui_renderer/src/models/form_models.dart';
import 'package:dynamic_ui_renderer/src/widgets/form_fields/text_field.dart';

/// Dynamic number field widget (specialized text field)
class DynamicNumberField extends StatelessWidget {
  final FormFieldConfig field;
  final FormController controller;

  const DynamicNumberField({
    super.key,
    required this.field,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure type is number
    final numberField = FormFieldConfig(
      name: field.name,
      type: FieldType.number,
      label: field.label,
      hint: field.hint ?? 'Enter a number',
      initialValue: field.initialValue,
      required: field.required,
      requiredMessage: field.requiredMessage,
      validations: field.validations,
      uiProperties: field.uiProperties,
      order: field.order,
      width: field.width,
    );

    return DynamicTextField(field: numberField, controller: controller);
  }
}
