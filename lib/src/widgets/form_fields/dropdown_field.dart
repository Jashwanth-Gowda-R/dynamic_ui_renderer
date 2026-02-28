import 'package:flutter/material.dart';

import 'package:dynamic_ui_renderer/src/core/form_controller.dart';
import 'package:dynamic_ui_renderer/src/core/utils.dart';
import 'package:dynamic_ui_renderer/src/models/form_models.dart';

/// Dynamic dropdown field widget
class DynamicDropdownField extends StatefulWidget {
  final FormFieldConfig field;
  final FormController controller;

  const DynamicDropdownField({
    super.key,
    required this.field,
    required this.controller,
  });

  @override
  State<DynamicDropdownField> createState() => _DynamicDropdownFieldState();
}

class _DynamicDropdownFieldState extends State<DynamicDropdownField> {
  dynamic _selectedValue;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.field.initialValue;
    _focusNode.addListener(_onFocusChange);

    // Set initial value in controller
    if (_selectedValue != null) {
      widget.controller.setValue(widget.field.name, _selectedValue);
    }

    // Add listener to react to external changes (like reset)
    widget.controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    final controllerValue = widget.controller.values[widget.field.name];
    if (_selectedValue != controllerValue) {
      setState(() {
        _selectedValue = controllerValue;
      });
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.controller.markTouched(widget.field.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        if (!widget.controller.isVisible(widget.field.name)) {
          return const SizedBox.shrink();
        }

        final options =
            widget.controller.getDropdownOptions(widget.field.name) ?? [];
        final error = widget.controller.errors[widget.field.name];
        final isTouched = widget.controller.isTouched(widget.field.name);
        final showError = isTouched && error != null;

        // // Get current value from controller
        // final currentValue = widget.controller.values[widget.field.name];

        // // Update selected value if it changed externally
        // if (_selectedValue != currentValue) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     setState(() {
        //       _selectedValue = currentValue;
        //     });
        //   });
        // }

        return Container(
          width: widget.field.width,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.field.label != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 4),
                  child: Row(
                    children: [
                      Text(
                        widget.field.label!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.field.required)
                        const Text(
                          ' *',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                    ],
                  ),
                ),

              DropdownButtonFormField<dynamic>(
                initialValue: _selectedValue,
                focusNode: _focusNode,
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: widget.field.hint,
                  errorText: showError ? error : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.field.uiProperties?['borderRadius']?.toDouble() ??
                          8,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.field.uiProperties?['borderRadius']?.toDouble() ??
                          8,
                    ),
                    borderSide: BorderSide(
                      color: showError ? Colors.red : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      widget.field.uiProperties?['borderRadius']?.toDouble() ??
                          8,
                    ),
                    borderSide: BorderSide(
                      color: showError
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: widget.field.uiProperties?['filled'] == true,
                  fillColor: widget.field.uiProperties?['fillColor'] != null
                      ? UIUtils.parseColor(
                          widget.field.uiProperties!['fillColor'],
                        )
                      : Colors.grey.shade50,
                  contentPadding: EdgeInsets.all(
                    widget.field.uiProperties?['contentPadding']?.toDouble() ??
                        16,
                  ),
                ),
                items: options.map((option) {
                  return DropdownMenuItem(
                    value: option.value,
                    enabled: option.disabled != true,
                    child: Row(
                      children: [
                        if (option.icon != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildIcon(option.icon!),
                          ),
                        Expanded(
                          child: Text(
                            option.label,
                            style: TextStyle(
                              color: option.disabled == true
                                  ? Colors.grey
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                  widget.controller.setValue(widget.field.name, value);
                },
                validator: (value) {
                  if (widget.field.required && value == null) {
                    return widget.field.requiredMessage ??
                        'Please select an option';
                  }
                  return null;
                },
              ),

              if (widget.field.uiProperties?['helperText'] != null &&
                  !showError)
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 4),
                  child: Text(
                    widget.field.uiProperties!['helperText'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIcon(Map<String, dynamic> iconData) {
    // Handle both string and map formats
    if (iconData.containsKey('name')) {
      // It's a map with name property
      return Icon(
        _getIconData(iconData['name']),
        color: UIUtils.parseColor(iconData['color']),
        size: iconData['size']?.toDouble() ?? 20,
      );
    } else if (iconData is String) {
      // It's just a string
      return Icon(_getIconData(iconData), size: 20);
    }
    return const SizedBox.shrink();
  }

  IconData _getIconData(dynamic iconName) {
    if (iconName == null) return Icons.arrow_drop_down;

    final name = iconName.toString().toLowerCase();
    switch (name) {
      case 'person':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'lock':
        return Icons.lock;
      case 'phone':
        return Icons.phone;
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      case 'flag':
        return Icons.flag;
      case 'public':
        return Icons.public;
      case 'location':
      case 'location_on':
        return Icons.location_on;
      default:
        return Icons.arrow_drop_down;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    _focusNode.dispose();
    super.dispose();
  }
}
