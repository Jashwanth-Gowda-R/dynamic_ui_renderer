import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_ui_renderer/dynamic_ui_renderer.dart';
import 'package:dynamic_ui_renderer/src/core/utils.dart' as utils;

void main() {
  group('UIComponent Parsing Tests', () {
    test('Parses text component correctly', () {
      final json = {
        'type': 'text',
        'properties': {'text': 'Hello World', 'fontSize': 20},
      };

      final component = UIComponent.fromJson(json);

      expect(component.type, 'text');
      expect(component.properties['text'], 'Hello World');
      expect(component.properties['fontSize'], 20);
    });

    test('Parses container with children', () {
      final json = {
        'type': 'container',
        'properties': {'padding': 16},
        'children': [
          {
            'type': 'text',
            'properties': {'text': 'Child Text'},
          },
        ],
      };

      final component = UIComponent.fromJson(json);

      expect(component.type, 'container');
      expect(component.children.length, 1);
      expect(component.children.first.type, 'text');
      expect(component.children.first.properties['text'], 'Child Text');
    });
  });

  group('Widget Rendering Tests', () {
    testWidgets('Renders text widget', (tester) async {
      final json = {
        'type': 'text',
        'properties': {'text': 'Test Text'},
      };

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DynamicUIRenderer.fromJsonMap(json))),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('Renders button widget', (tester) async {
      final json = {
        'type': 'button',
        'properties': {'text': 'Click Me'},
        'children': [
          {
            'type': 'text',
            'properties': {'text': 'Click Me'},
          },
        ],
      };

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DynamicUIRenderer.fromJsonMap(json))),
      );

      expect(find.text('Click Me'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Renders column with multiple children', (tester) async {
      final json = {
        'type': 'column',
        'children': [
          {
            'type': 'text',
            'properties': {'text': 'First'},
          },
          {
            'type': 'text',
            'properties': {'text': 'Second'},
          },
        ],
      };

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DynamicUIRenderer.fromJsonMap(json))),
      );

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('Handles invalid JSON gracefully', (tester) async {
      final invalidJson = {'invalid': 'data'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DynamicUIRenderer.fromJsonMap(invalidJson)),
        ),
      );

      // Should show error widget instead of crashing
      expect(find.byIcon(Icons.error), findsOneWidget);
    });
  });

  group('Utility Function Tests', () {
    // Import utils directly for testing

    test('parseEdgeInsets handles numbers correctly', () {
      final result = utils.UIUtils.parseEdgeInsets(16);
      expect(result, const EdgeInsets.all(16));
    });

    test('parseEdgeInsets handles lists correctly', () {
      final result = utils.UIUtils.parseEdgeInsets([8, 16, 8, 16]);
      expect(result, const EdgeInsets.fromLTRB(8, 16, 8, 16));
    });

    test('parseColor handles hex colors correctly', () {
      final result = utils.UIUtils.parseColor('#FF0000');
      expect(result, const Color(0xFFFF0000));
    });
  });
}
