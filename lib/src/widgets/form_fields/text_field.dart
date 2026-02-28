import 'package:dynamic_ui_renderer/src/core/utils.dart';
import 'package:flutter/material.dart';

import 'package:dynamic_ui_renderer/src/core/form_controller.dart';
import 'package:dynamic_ui_renderer/src/models/form_models.dart';

/// Dynamic text field widget
class DynamicTextField extends StatefulWidget {
  final FormFieldConfig field;
  final FormController controller;

  const DynamicTextField({
    super.key,
    required this.field,
    required this.controller,
  });

  @override
  State<DynamicTextField> createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState extends State<DynamicTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller.getController(widget.field.name)!;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _obscureText = widget.field.type == FieldType.password;
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

              TextField(
                controller: _controller,
                focusNode: _focusNode,
                obscureText: _obscureText,
                keyboardType: _getKeyboardType(),
                maxLines: widget.field.type == FieldType.textarea ? null : 1,
                minLines: widget.field.type == FieldType.textarea
                    ? (widget.field.uiProperties?['minLines']?.toInt() ?? 3)
                    : 1,
                decoration: InputDecoration(
                  hintText: widget.field.hint ?? widget.field.placeholder,
                  errorText: showError ? error : null,
                  errorStyle: const TextStyle(fontSize: 12),
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
                      : null,
                  suffixIcon: widget.field.type == FieldType.password
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null,
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
                  // Don't call setValue here - it's already in the controller listener
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

  TextInputType _getKeyboardType() {
    switch (widget.field.type) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.number:
        return const TextInputType.numberWithOptions(decimal: true);
      case FieldType.password:
        return TextInputType.visiblePassword;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.textarea:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
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
      case 'search':
        return Icons.search;
      default:
        return Icons.edit;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
