import 'package:flutter/material.dart';
import 'package:dynamic_ui_renderer/src/core/form_controller.dart';
import 'package:dynamic_ui_renderer/src/core/utils.dart';
import 'package:dynamic_ui_renderer/src/models/form_models.dart';

/// Dynamic date field widget
class DynamicDateField extends StatefulWidget {
  final FormFieldConfig field;
  final FormController controller;

  const DynamicDateField({
    super.key,
    required this.field,
    required this.controller,
  });

  @override
  State<DynamicDateField> createState() => _DynamicDateFieldState();
}

class _DynamicDateFieldState extends State<DynamicDateField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);

    // Initialize with initial value if provided
    if (widget.field.initialValue != null) {
      _controller.text = widget.field.initialValue.toString();
      // Try to parse the date
      try {
        _selectedDate = DateTime.parse(widget.field.initialValue.toString());
      } catch (e) {
        // If parsing fails, just use the string as is
      }
    }

    // Add listener to react to external changes (like reset)
    widget.controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    final controllerValue = widget.controller.values[widget.field.name];
    final newText = controllerValue?.toString() ?? '';
    if (_controller.text != newText) {
      setState(() {
        _controller.text = newText;
        if (newText.isNotEmpty) {
          try {
            _selectedDate = DateTime.parse(newText);
          } catch (e) {
            _selectedDate = null;
          }
        } else {
          _selectedDate = null;
        }
      });
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.controller.markTouched(widget.field.name);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  UIUtils.parseColor(
                    widget.field.uiProperties?['pickerColor'] ?? '#2196F3',
                  ) ??
                  Colors.blue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;

        // Format date based on format property or default to yyyy-MM-dd
        String formattedDate;
        final format = widget.field.uiProperties?['format'] ?? 'yyyy-MM-dd';

        if (format == 'dd/MM/yyyy') {
          formattedDate =
              '${picked.day.toString().padLeft(2, '0')}/'
              '${picked.month.toString().padLeft(2, '0')}/'
              '${picked.year}';
        } else if (format == 'MM/dd/yyyy') {
          formattedDate =
              '${picked.month.toString().padLeft(2, '0')}/'
              '${picked.day.toString().padLeft(2, '0')}/'
              '${picked.year}';
        } else if (format == 'dd MMM yyyy') {
          const months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
          formattedDate =
              '${picked.day} ${months[picked.month - 1]} ${picked.year}';
        } else {
          // Default: yyyy-MM-dd
          formattedDate =
              '${picked.year.toString().padLeft(4, '0')}-'
              '${picked.month.toString().padLeft(2, '0')}-'
              '${picked.day.toString().padLeft(2, '0')}';
        }

        _controller.text = formattedDate;
        widget.controller.setValue(widget.field.name, formattedDate);
        widget.controller.markTouched(widget.field.name);
      });
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

        // final currentValue = widget.controller.values[widget.field.name];

        // // Update text field if value changed externally
        // if (_controller.text != (currentValue?.toString() ?? '')) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     _controller.text = currentValue?.toString() ?? '';
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

              TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: widget.field.hint ?? 'Select date',
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
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: UIUtils.parseColor(
                      widget.field.uiProperties?['iconColor'],
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
                style: TextStyle(
                  fontSize:
                      widget.field.uiProperties?['fontSize']?.toDouble() ?? 16,
                  color: UIUtils.parseColor(
                    widget.field.uiProperties?['textColor'],
                  ),
                ),
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

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
