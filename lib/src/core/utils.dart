import 'package:flutter/material.dart';

/// Utility functions for parsing JSON properties
class UIUtils {
  /// Parses padding/margin values
  /// Can handle: number (all sides), list of 4 (LTRB), or null
  static EdgeInsets? parseEdgeInsets(dynamic value) {
    if (value == null) return null;

    // Single value applies to all sides
    if (value is num) {
      return EdgeInsets.all(value.toDouble());
    }

    // List of 4 values: [left, top, right, bottom]
    if (value is List && value.length == 4) {
      return EdgeInsets.fromLTRB(
        value[0].toDouble(),
        value[1].toDouble(),
        value[2].toDouble(),
        value[3].toDouble(),
      );
    }

    return null;
  }

  /// Parses color strings (#RRGGBB or #AARRGGBB)
  static Color? parseColor(String? colorString) {
    if (colorString == null) return null;

    if (colorString.startsWith('#')) {
      final hex = colorString.substring(1);

      // #RRGGBB format
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      // #AARRGGBB format
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }

    return null;
  }

  /// Parses font weight strings
  static FontWeight? parseFontWeight(String? weight) {
    if (weight == null) return null;

    switch (weight.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
      case 'normal':
        return FontWeight.normal;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return null;
    }
  }
}
