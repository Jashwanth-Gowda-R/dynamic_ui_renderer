import 'package:flutter/material.dart';

import 'package:dynamic_ui_renderer/src/actions/action_handler.dart';
import 'package:dynamic_ui_renderer/src/core/form_controller.dart';
import 'package:dynamic_ui_renderer/src/core/utils.dart';
import 'package:dynamic_ui_renderer/src/models/form_models.dart';
import 'package:dynamic_ui_renderer/src/models/ui_component.dart';
import 'package:dynamic_ui_renderer/src/widgets/form_fields/checkbox_field.dart';
import 'package:dynamic_ui_renderer/src/widgets/form_fields/date_field.dart';
import 'package:dynamic_ui_renderer/src/widgets/form_fields/dropdown_field.dart';
import 'package:dynamic_ui_renderer/src/widgets/form_fields/email_field.dart';
import 'package:dynamic_ui_renderer/src/widgets/form_fields/number_field.dart';
import 'package:dynamic_ui_renderer/src/widgets/form_fields/password_field.dart';
import 'package:dynamic_ui_renderer/src/widgets/form_fields/phone_field.dart';
import 'package:dynamic_ui_renderer/src/widgets/form_fields/text_field.dart';

/// Main form widget that renders dynamic forms from JSON
class DynamicForm extends StatefulWidget {
  final UIComponent component;

  const DynamicForm({super.key, required this.component});

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  late List<FormFieldConfig> _fields;
  late FormController _controller;
  final _formKey = GlobalKey<FormState>();
  String? _formId;

  @override
  void initState() {
    super.initState();

    _formId = widget.component.properties['formId'];

    final fieldsJson = widget.component.properties['fields'];

    if (fieldsJson != null && fieldsJson is List) {
      _fields =
          fieldsJson
              .map((f) => FormFieldConfig.fromJson(f as Map<String, dynamic>))
              .toList()
            ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    } else {
      _fields = [];
    }

    _controller = FormController(_fields, formId: _formId);

    // Add form submit listener
    _controller.addFormSubmitListener(_handleFormSubmit);

    // Add listener for conditional visibility using ChangeNotifier's method
    _controller.addListener(_updateConditionalVisibility);
  }

  void _handleFormSubmit(Map<String, dynamic> formData) {
    // This will be called when form is submitted
    debugPrint('Form submitted with data: $formData');
  }

  void _updateConditionalVisibility() {
    for (var field in _fields) {
      if (field.conditionalLogic != null) {
        final shouldShow = field.shouldShow(_controller.values);
        _controller.updateVisibility(field.name, shouldShow);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        widget.component.properties['padding']?.toDouble() ?? 16,
      ),
      margin:
          UIUtils.parseEdgeInsets(widget.component.properties['margin']) ??
          EdgeInsets.zero,
      decoration: BoxDecoration(
        color: UIUtils.parseColor(
          widget.component.properties['backgroundColor'],
        ),
        borderRadius: BorderRadius.circular(
          widget.component.properties['borderRadius']?.toDouble() ?? 0,
        ),
        boxShadow: widget.component.properties['elevation'] != null
            ? [
                BoxShadow(
                  blurRadius: widget.component.properties['elevation']!
                      .toDouble(),
                  color: Colors.black.withOpacity(0.1),
                ),
              ]
            : null,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.component.properties['title'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  widget.component.properties['title'],
                  style: TextStyle(
                    fontSize:
                        widget.component.properties['titleFontSize']
                            ?.toDouble() ??
                        20,
                    fontWeight: FontWeight.bold,
                    color: UIUtils.parseColor(
                      widget.component.properties['titleColor'],
                    ),
                  ),
                ),
              ),

            ..._buildFields(),

            if (widget.component.properties['showSubmitButton'] != false)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: _buildSubmitButton(),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFields() {
    return _fields.map((field) {
      if (!_controller.isVisible(field.name)) {
        return const SizedBox.shrink();
      }

      switch (field.type) {
        case FieldType.text:
        case FieldType.textarea:
          return DynamicTextField(field: field, controller: _controller);

        case FieldType.email:
          return DynamicEmailField(field: field, controller: _controller);

        case FieldType.password:
          return DynamicPasswordField(field: field, controller: _controller);

        case FieldType.number:
          return DynamicNumberField(field: field, controller: _controller);

        case FieldType.phone:
          return DynamicPhoneField(field: field, controller: _controller);

        case FieldType.dropdown:
          return DynamicDropdownField(field: field, controller: _controller);

        case FieldType.checkbox:
          return DynamicCheckboxField(field: field, controller: _controller);

        case FieldType.date:
          return DynamicDateField(field: field, controller: _controller);

        default:
          return const SizedBox.shrink();
      }
    }).toList();
  }

  Widget _buildSubmitButton() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          height:
              widget.component.properties['submitButtonHeight']?.toDouble() ??
              48,
          child: ElevatedButton(
            onPressed: _controller.isSubmitting ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: UIUtils.parseColor(
                widget.component.properties['submitButtonColor'] ?? '#2196F3',
              ),
              foregroundColor: UIUtils.parseColor(
                widget.component.properties['submitButtonTextColor'] ??
                    '#FFFFFF',
              ),
              elevation: widget.component.properties['submitButtonElevation']
                  ?.toDouble(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  widget.component.properties['submitButtonRadius']
                          ?.toDouble() ??
                      8,
                ),
              ),
            ),
            child: _controller.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.component.properties['submitText'] ?? 'Submit',
                    style: TextStyle(
                      fontSize:
                          widget.component.properties['submitButtonFontSize']
                              ?.toDouble() ??
                          16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _submitForm() async {
    if (_controller.validateAll()) {
      _controller.startSubmitting();

      final formData = _controller.values;

      debugPrint(
        '\n📋 ===== FORM SUBMITTED ${_formId != null ? '($_formId)' : ''} =====',
      );
      formData.forEach((key, value) {
        debugPrint('   • $key: $value');
      });
      debugPrint('📋 ===========================\n');

      // Notify form submit listeners
      _controller.notifyFormSubmitted();

      // Handle form submission actions
      final submitAction = widget.component.actions['onSubmit'];
      if (submitAction != null) {
        final actionWithData = Map<String, dynamic>.from(submitAction);
        if (actionWithData['parameters'] == null) {
          actionWithData['parameters'] = {};
        }
        actionWithData['parameters']['formData'] = formData;

        if (widget.component.buildContext != null) {
          ActionHandler.handleAction(
            widget.component.buildContext!,
            actionWithData,
          );
        }
      }

      _controller.stopSubmitting();

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _controller.reset();
        }
      });
    } else {
      if (widget.component.properties['showValidationMessage'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.component.properties['validationMessage'] ??
                  'Please fix the errors and try again',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateConditionalVisibility);
    _controller.removeFormSubmitListener(_handleFormSubmit);
    _controller.dispose();
    super.dispose();
  }
}
