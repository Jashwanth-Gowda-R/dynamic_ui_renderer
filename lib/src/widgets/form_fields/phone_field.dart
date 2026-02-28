import 'package:flutter/material.dart';

import 'package:dynamic_ui_renderer/src/core/form_controller.dart';
import 'package:dynamic_ui_renderer/src/core/utils.dart';
import 'package:dynamic_ui_renderer/src/models/form_models.dart';

/// Dynamic phone field widget
class DynamicPhoneField extends StatefulWidget {
  final FormFieldConfig field;
  final FormController controller;

  const DynamicPhoneField({
    super.key,
    required this.field,
    required this.controller,
  });

  @override
  State<DynamicPhoneField> createState() => _DynamicPhoneFieldState();
}

class _DynamicPhoneFieldState extends State<DynamicPhoneField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller.getController(widget.field.name)!;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
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

        final error = widget.controller.errors[widget.field.name];
        final isTouched = widget.controller.isTouched(widget.field.name);
        final showError = isTouched && error != null;

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

              TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText:
                      widget.field.hint ??
                      widget.field.placeholder ??
                      'Enter phone number',
                  errorText: showError ? error : null,
                  errorStyle: const TextStyle(fontSize: 12),
                  prefixText: widget.field.uiProperties?['prefix'] ?? '+',
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
                  prefixIcon: widget.field.uiProperties?['prefixIcon'] != null
                      ? Icon(
                          _getIconData(
                            widget.field.uiProperties!['prefixIcon'],
                          ),
                          color: UIUtils.parseColor(
                            widget.field.uiProperties!['prefixIconColor'],
                          ),
                        )
                      : const Icon(Icons.phone),
                ),
                style: TextStyle(
                  fontSize:
                      widget.field.uiProperties?['fontSize']?.toDouble() ?? 16,
                  color: UIUtils.parseColor(
                    widget.field.uiProperties?['textColor'],
                  ),
                ),
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  // Value already updated via controller listener
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

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'lock':
        return Icons.lock;
      case 'phone':
        return Icons.phone;
      default:
        return Icons.phone;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
