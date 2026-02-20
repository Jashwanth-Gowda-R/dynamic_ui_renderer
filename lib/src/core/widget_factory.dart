import 'package:dynamic_ui_renderer/src/actions/action_handler.dart';
import 'package:dynamic_ui_renderer/src/models/ui_component.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

/// The heart of the package - converts UIComponents to Flutter widgets
class WidgetFactory {
  /// Main build method - decides which widget to create based on type
  static Widget build(UIComponent component) {
    switch (component.type) {
      case 'text':
        return _buildText(component);
      case 'container':
        return _buildContainer(component);
      case 'button':
        return _buildButton(component);
      case 'column':
        return _buildColumn(component);
      case 'row':
        return _buildRow(component);
      default:
        return _buildUnsupported(component);
    }
  }

  /// Creates a Text widget from JSON
  static Widget _buildText(UIComponent component) {
    return Text(
      component.properties['text'] ?? '',
      style: TextStyle(
        fontSize: component.properties['fontSize']?.toDouble(),
        fontWeight: UIUtils.parseFontWeight(component.properties['fontWeight']),
        color: UIUtils.parseColor(component.properties['color']),
      ),
    );
  }

  /// Creates a Container widget from JSON
  static Widget _buildContainer(UIComponent component) {
    return Container(
      padding: UIUtils.parseEdgeInsets(component.properties['padding']),
      margin: UIUtils.parseEdgeInsets(component.properties['margin']),
      color: UIUtils.parseColor(component.properties['color']),
      width: component.properties['width']?.toDouble(),
      height: component.properties['height']?.toDouble(),
      child: component.children.isNotEmpty
          ? build(component.children.first)
          : null,
    );
  }

  // /// Creates a Button widget from JSON
  // static Widget _buildButton(UIComponent component) {
  //   return ElevatedButton(
  //     style: ButtonStyle(
  //       backgroundColor: WidgetStateProperty.all<Color>(
  //         UIUtils.parseColor(component.properties['color']) ?? Colors.white,
  //       ),
  //     ),
  //     onPressed: () {
  //       // Handle button actions
  //       // debugPrint('Button pressed: ${component.actions}');
  //     },
  //     child: component.children.isNotEmpty
  //         ? build(component.children.first)
  //         : Text(component.properties['text'] ?? 'Button'),
  //   );
  // }

  /// Creates a Button widget from JSON - UPDATED with actions
  static Widget _buildButton(UIComponent component) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: UIUtils.parseColor(
          component.properties['backgroundColor'],
        ),
        foregroundColor: UIUtils.parseColor(
          component.properties['foregroundColor'],
        ),
        elevation: component.properties['elevation']?.toDouble(),
        padding: UIUtils.parseEdgeInsets(component.properties['padding']),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            component.properties['borderRadius']?.toDouble() ?? 4,
          ),
        ),
      ),
      onPressed: () {
        // Handle button actions
        if (component.actions.isNotEmpty) {
          // debugPrint('Button pressed - executing action: ${component.actions}');
          ActionHandler.handleAction(
            component.buildContext!,
            component.actions,
          );
        } else {
          // debugPrint('Button pressed (no actions defined)');
        }
      },
      child: component.children.isNotEmpty
          ? build(component.children.first)
          : Text(
              component.properties['text'] ?? 'Button',
              style: TextStyle(
                fontSize: component.properties['fontSize']?.toDouble(),
                fontWeight: UIUtils.parseFontWeight(
                  component.properties['fontWeight'],
                ),
              ),
            ),
    );
  }

  /// Creates a Column widget from JSON
  static Widget _buildColumn(UIComponent component) {
    return Column(
      mainAxisAlignment: _parseMainAxisAlignment(
        component.properties['mainAxisAlignment'],
      ),
      crossAxisAlignment: _parseCrossAxisAlignment(
        component.properties['crossAxisAlignment'],
      ),
      children: component.children.map(build).toList(),
    );
  }

  /// Creates a Row widget from JSON
  static Widget _buildRow(UIComponent component) {
    return Row(
      mainAxisAlignment: _parseMainAxisAlignment(
        component.properties['mainAxisAlignment'],
      ),
      crossAxisAlignment: _parseCrossAxisAlignment(
        component.properties['crossAxisAlignment'],
      ),
      children: component.children.map(build).toList(),
    );
  }

  /// Fallback for unsupported widget types
  static Widget _buildUnsupported(UIComponent component) {
    return Container(
      color: Colors.yellow.shade100,
      padding: const EdgeInsets.all(8),
      child: Text(
        '⚠️ Unsupported widget type: ${component.type}',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  // Alignment helpers
  static MainAxisAlignment _parseMainAxisAlignment(String? value) {
    switch (value) {
      case 'center':
        return MainAxisAlignment.center;
      case 'end':
        return MainAxisAlignment.end;
      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment _parseCrossAxisAlignment(String? value) {
    switch (value) {
      case 'center':
        return CrossAxisAlignment.center;
      case 'end':
        return CrossAxisAlignment.end;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      default:
        return CrossAxisAlignment.start;
    }
  }
}

// Extension to get BuildContext - needed for navigation
extension UIComponentExtension on UIComponent {
  static BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  BuildContext? get buildContext => _context;
}
