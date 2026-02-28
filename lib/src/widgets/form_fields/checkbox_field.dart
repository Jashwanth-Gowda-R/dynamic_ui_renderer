import 'package:flutter/material.dart';

import 'package:dynamic_ui_renderer/src/core/form_controller.dart';
import 'package:dynamic_ui_renderer/src/core/utils.dart';
import 'package:dynamic_ui_renderer/src/models/form_models.dart';

/// Dynamic checkbox field widget
class DynamicCheckboxField extends StatefulWidget {
  final FormFieldConfig field;
  final FormController controller;

  const DynamicCheckboxField({
    super.key,
    required this.field,
    required this.controller,
  });

  @override
  State<DynamicCheckboxField> createState() => _DynamicCheckboxFieldState();
}

class _DynamicCheckboxFieldState extends State<DynamicCheckboxField> {
  late bool _value;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _value = widget.field.initialValue as bool? ?? false;
    widget.controller.setValue(widget.field.name, _value);
    _focusNode.addListener(_onFocusChange);

    // Add listener to react to external changes (like reset)
    widget.controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    // Check if the value in controller is different from local value
    final controllerValue =
        widget.controller.values[widget.field.name] ?? false;
    if (_value != controllerValue) {
      setState(() {
        _value = controllerValue;
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

        final error = widget.controller.errors[widget.field.name];
        final isTouched = widget.controller.isTouched(widget.field.name);
        final showError = isTouched && error != null;

        return Container(
          width: widget.field.width,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Focus(
                    focusNode: _focusNode,
                    child: Checkbox(
                      value: _value,
                      onChanged: (bool? value) {
                        setState(() {
                          _value = value ?? false;
                        });
                        widget.controller.setValue(widget.field.name, _value);
                        widget.controller.markTouched(widget.field.name);
                      },
                      activeColor: UIUtils.parseColor(
                        widget.field.uiProperties?['activeColor'],
                      ),
                      checkColor: UIUtils.parseColor(
                        widget.field.uiProperties?['checkColor'],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _value = !_value;
                        });
                        widget.controller.setValue(widget.field.name, _value);
                        widget.controller.markTouched(widget.field.name);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.field.label ?? '',
                                style: TextStyle(
                                  fontSize:
                                      widget.field.uiProperties?['fontSize']
                                          ?.toDouble() ??
                                      16,
                                  color: UIUtils.parseColor(
                                    widget.field.uiProperties?['textColor'],
                                  ),
                                ),
                              ),
                            ),
                            if (widget.field.required)
                              const Text(
                                ' *',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (showError)
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 4),
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(
      _onControllerChange,
    ); // Don't forget to remove listener
    _focusNode.dispose();
    super.dispose();
  }
}
