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

  /// Parses color strings (#RRGGBB or #AARRGGBB or #RGB)
  static Color? parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return null;

    String hex = colorString.replaceFirst('#', '');

    // Handle 3-digit hex (e.g., #F00 -> #FF0000)
    if (hex.length == 3) {
      hex = hex.split('').map((c) => '$c$c').join();
    }

    // Handle 4-digit hex with alpha (e.g., #80F -> #80FF0000 format)
    if (hex.length == 4) {
      final alpha = hex[0];
      final rgb = hex.substring(1);
      final expandedRgb = rgb.split('').map((c) => '$c$c').join();
      hex = '$alpha$expandedRgb';
    }

    // Add opacity if not present (for 6-digit RGB)
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    try {
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return null;
    }
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
