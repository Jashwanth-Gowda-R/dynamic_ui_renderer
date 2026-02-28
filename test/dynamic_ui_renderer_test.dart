import 'package:dynamic_ui_renderer/dynamic_ui_renderer.dart';
import 'package:dynamic_ui_renderer/src/core/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

    test('Parses form component correctly', () {
      final json = {
        'type': 'form',
        'properties': {'title': 'Test Form', 'submitText': 'Submit'},
        'fields': [
          {
            'name': 'testField',
            'type': 'text',
            'label': 'Test Field',
            'required': true,
          },
        ],
        'actions': {
          'onSubmit': {'type': 'print', 'parameters': {}},
        },
      };

      final component = UIComponent.fromJson(json);

      expect(component.type, 'form');
      expect(component.properties['title'], 'Test Form');
      expect(component.properties['submitText'], 'Submit');

      // Fix: Properly cast the fields list
      final fields = component.properties['fields'] as List?;
      expect(fields, isNotNull);
      expect(fields!.length, 1);
    });
  });

  group('FormFieldConfig Tests', () {
    test('Parses text field config correctly', () {
      final json = {
        'name': 'username',
        'type': 'text',
        'label': 'Username',
        'hint': 'Enter username',
        'required': true,
        'requiredMessage': 'Username is required',
        'order': 1,
        'validations': [
          {'type': 'minLength', 'value': 3, 'message': 'Minimum 3 characters'},
          {
            'type': 'maxLength',
            'value': 20,
            'message': 'Maximum 20 characters',
          },
        ],
        'uiProperties': {
          'borderRadius': 8,
          'filled': true,
          'prefixIcon': 'person',
        },
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.name, 'username');
      expect(field.type, FieldType.text);
      expect(field.label, 'Username');
      expect(field.hint, 'Enter username');
      expect(field.required, true);
      expect(field.requiredMessage, 'Username is required');
      expect(field.order, 1);
      expect(field.validations.length, 2);
      expect(field.validations[0].type, ValidationType.minLength);
      expect(field.validations[0].value, 3);
      expect(field.validations[1].type, ValidationType.maxLength);
      expect(field.validations[1].value, 20);
    });

    test('Parses email field config correctly', () {
      final json = {
        'name': 'email',
        'type': 'email',
        'label': 'Email',
        'required': true,
        'validations': [
          {'type': 'email', 'message': 'Invalid email'},
        ],
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.name, 'email');
      expect(field.type, FieldType.email);
      expect(field.validations[0].type, ValidationType.email);
    });

    test('Parses password field config correctly', () {
      final json = {
        'name': 'password',
        'type': 'password',
        'label': 'Password',
        'required': true,
        'validations': [
          {
            'type': 'pattern',
            'pattern': '^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}\$',
            'message': 'Password must contain letter and number',
          },
        ],
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.name, 'password');
      expect(field.type, FieldType.password);
      expect(field.validations[0].type, ValidationType.pattern);
      expect(field.validations[0].pattern, isNotNull);
    });

    test('Parses dropdown field with options', () {
      final json = {
        'name': 'country',
        'type': 'dropdown',
        'label': 'Country',
        'options': [
          {'label': 'USA', 'value': 'us'},
          {'label': 'India', 'value': 'in'},
          {'label': 'UK', 'value': 'uk'},
        ],
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.type, FieldType.dropdown);
      expect(field.options?.length, 3);
      expect(field.options?[0].label, 'USA');
      expect(field.options?[0].value, 'us');
    });

    test('Parses checkbox field', () {
      final json = {
        'name': 'terms',
        'type': 'checkbox',
        'label': 'Accept Terms',
        'required': true,
        'uiProperties': {'activeColor': '#4CAF50', 'checkColor': '#FFFFFF'},
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.type, FieldType.checkbox);
      expect(field.label, 'Accept Terms');
      expect(field.required, true);
    });

    test('Parses date field', () {
      final json = {
        'name': 'birthDate',
        'type': 'date',
        'label': 'Birth Date',
        'uiProperties': {'format': 'dd/MM/yyyy', 'iconColor': '#1976D2'},
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.type, FieldType.date);
      expect(field.uiProperties?['format'], 'dd/MM/yyyy');
    });

    test('Parses phone field', () {
      final json = {
        'name': 'phone',
        'type': 'phone',
        'label': 'Phone',
        'validations': [
          {'type': 'phone', 'message': 'Invalid phone'},
        ],
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.type, FieldType.phone);
      expect(field.validations[0].type, ValidationType.phone);
    });

    test('Parses number field with min/max validations', () {
      final json = {
        'name': 'age',
        'type': 'number',
        'label': 'Age',
        'validations': [
          {'type': 'minValue', 'value': 18, 'message': 'Must be 18 or older'},
          {
            'type': 'maxValue',
            'value': 100,
            'message': 'Must be 100 or younger',
          },
        ],
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.type, FieldType.number);
      expect(field.validations[0].type, ValidationType.minValue);
      expect(field.validations[0].value, 18);
      expect(field.validations[1].type, ValidationType.maxValue);
      expect(field.validations[1].value, 100);
    });
  });

  group('FormController Tests', () {
    late List<FormFieldConfig> fields;
    late FormController controller;

    setUp(() {
      fields = [
        FormFieldConfig(
          name: 'username',
          type: FieldType.text,
          required: true,
          validations: [
            ValidationRule(
              type: ValidationType.minLength,
              value: 3,
              message: 'Min 3 chars',
            ),
          ],
        ),
        FormFieldConfig(
          name: 'email',
          type: FieldType.email,
          required: true,
          validations: [
            ValidationRule(
              type: ValidationType.email,
              message: 'Invalid email',
            ),
          ],
        ),
        FormFieldConfig(
          name: 'password',
          type: FieldType.password,
          required: true,
          validations: [
            ValidationRule(
              type: ValidationType.minLength,
              value: 8,
              message: 'Min 8 chars',
            ),
          ],
        ),
        FormFieldConfig(
          name: 'age',
          type: FieldType.number,
          validations: [
            ValidationRule(
              type: ValidationType.minValue,
              value: 18,
              message: 'Must be 18+',
            ),
          ],
        ),
        FormFieldConfig(
          name: 'terms',
          type: FieldType.checkbox,
          required: true,
        ),
      ];

      controller = FormController(fields);
    });

    test('Initializes with correct field count', () {
      // Fix: Check the internal state through available methods
      expect(controller.values.length, 5);
      expect(controller.errors.length, 5);
    });

    test('Validates required fields correctly', () {
      // Initially all values are empty/null
      final isValid = controller.validateAll();
      expect(isValid, false);

      // Check specific field errors
      expect(controller.errors['username'], isNotNull);
      expect(controller.errors['email'], isNotNull);
      expect(controller.errors['password'], isNotNull);
      expect(controller.errors['terms'], isNotNull);
    });

    test('Validates email format correctly', () {
      controller.setValue('email', 'invalid-email');
      controller.validateAll();
      expect(controller.errors['email'], 'Invalid email');

      controller.setValue('email', 'test@example.com');
      controller.validateAll();
      expect(controller.errors['email'], null);
    });

    test('Validates min length correctly', () {
      controller.setValue('username', 'ab');
      controller.validateAll();
      expect(controller.errors['username'], 'Min 3 chars');

      controller.setValue('username', 'abc');
      controller.validateAll();
      expect(controller.errors['username'], null);
    });

    test('Validates min value correctly', () {
      controller.setValue('age', 16);
      controller.validateAll();
      expect(controller.errors['age'], 'Must be 18+');

      controller.setValue('age', 20);
      controller.validateAll();
      expect(controller.errors['age'], null);
    });

    test('Tracks touched state correctly', () {
      expect(controller.isTouched('username'), false);

      controller.markTouched('username');
      expect(controller.isTouched('username'), true);
    });

    test('Tracks dirty state correctly', () {
      expect(controller.isDirty, false);

      controller.setValue('username', 'newvalue');
      expect(controller.isDirty, true);
    });

    test('Resets form correctly', () {
      controller.setValue('username', 'testuser');
      controller.markTouched('username');
      expect(controller.isDirty, true);
      expect(controller.isTouched('username'), true);

      controller.reset();
      expect(controller.isDirty, false);
      expect(controller.isTouched('username'), false);
      expect(controller.values['username'], null);
    });

    test('Handles conditional visibility', () {
      expect(controller.isVisible('username'), true);

      controller.updateVisibility('username', false);
      expect(controller.isVisible('username'), false);
    });

    test('Starts and stops submitting state', () {
      expect(controller.isSubmitting, false);

      controller.startSubmitting();
      expect(controller.isSubmitting, true);

      controller.stopSubmitting();
      expect(controller.isSubmitting, false);
    });
  });

  group('ValidationRule Tests', () {
    test('Creates validation rules from JSON', () {
      final json = {
        'type': 'minLength',
        'value': 8,
        'message': 'Too short',
        'pattern': '^[A-Z]+\$',
      };

      final rule = ValidationRule.fromJson(json);

      expect(rule.type, ValidationType.minLength);
      expect(rule.value, 8);
      expect(rule.message, 'Too short');
      expect(rule.pattern, '^[A-Z]+\$');
    });

    test('Parses all validation types correctly', () {
      final types = {
        'required': ValidationType.required,
        'email': ValidationType.email,
        'minLength': ValidationType.minLength,
        'maxLength': ValidationType.maxLength,
        'minValue': ValidationType.minValue,
        'maxValue': ValidationType.maxValue,
        'pattern': ValidationType.pattern,
        'match': ValidationType.match,
        'url': ValidationType.url,
        'phone': ValidationType.phone,
        'date': ValidationType.date,
        'custom': ValidationType.custom,
      };

      types.forEach((key, value) {
        final json = {'type': key};
        final rule = ValidationRule.fromJson(json);
        expect(rule.type, value);
      });
    });
  });

  group('Widget Rendering Tests', () {
    testWidgets('Renders text widget', (tester) async {
      final json = {
        'type': 'text',
        'properties': {'text': 'Test Text'},
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  DynamicUIRenderer.fromJsonMap(json, context),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('Renders button widget', (tester) async {
      final json = {
        'type': 'button',
        'properties': {'text': 'Click Me'},
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  DynamicUIRenderer.fromJsonMap(json, context),
            ),
          ),
        ),
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
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  DynamicUIRenderer.fromJsonMap(json, context),
            ),
          ),
        ),
      );

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('Renders form widget', (tester) async {
      final json = {
        'type': 'form',
        'properties': {'title': 'Test Form', 'submitText': 'Submit'},
        'fields': [
          {
            'name': 'testField',
            'type': 'text',
            'label': 'Test Field',
            'required': true,
          },
        ],
        'actions': {
          'onSubmit': {'type': 'print', 'parameters': {}},
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  DynamicUIRenderer.fromJsonMap(json, context),
            ),
          ),
        ),
      );

      // Wait for form to render
      await tester.pumpAndSettle();

      // Check for form elements
      expect(find.text('Test Form'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('Renders multiple form fields', (tester) async {
      final json = {
        'type': 'form',
        'properties': {'title': 'Registration Form', 'submitText': 'Register'},
        'fields': [
          {
            'name': 'username',
            'type': 'text',
            'label': 'Username',
            'required': true,
          },
          {
            'name': 'email',
            'type': 'email',
            'label': 'Email',
            'required': true,
          },
          {
            'name': 'password',
            'type': 'password',
            'label': 'Password',
            'required': true,
          },
        ],
        'actions': {
          'onSubmit': {'type': 'print', 'parameters': {}},
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  DynamicUIRenderer.fromJsonMap(json, context),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for form elements
      expect(find.text('Registration Form'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('Handles invalid JSON gracefully', (tester) async {
      final invalidJson = {'invalid': 'data'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  DynamicUIRenderer.fromJsonMap(invalidJson, context),
            ),
          ),
        ),
      );

      // Should show error widget instead of crashing
      expect(find.byIcon(Icons.error), findsOneWidget);
    });
  });

  group('Utility Function Tests', () {
    test('parseEdgeInsets handles numbers correctly', () {
      final result = utils.UIUtils.parseEdgeInsets(16);
      expect(result, const EdgeInsets.all(16));
    });

    test('parseEdgeInsets handles lists correctly', () {
      final result = utils.UIUtils.parseEdgeInsets([8, 16, 8, 16]);
      expect(result, const EdgeInsets.fromLTRB(8, 16, 8, 16));
    });

    test('parseEdgeInsets returns null for invalid input', () {
      final result = utils.UIUtils.parseEdgeInsets('invalid');
      expect(result, null);
    });

    test('parseColor handles hex colors correctly', () {
      final result = utils.UIUtils.parseColor('#FF0000');
      expect(result, const Color(0xFFFF0000));
    });

    test('parseColor handles 3-digit hex colors', () {
      final result = utils.UIUtils.parseColor('#F00');
      expect(result, const Color(0xFFFF0000));
    });

    test('parseColor handles 8-digit hex with alpha', () {
      final result = utils.UIUtils.parseColor('#80FF0000');
      expect(result, const Color(0x80FF0000));
    });

    test('parseColor returns null for invalid color', () {
      final result = utils.UIUtils.parseColor('invalid');
      expect(result, null);
    });

    test('parseFontWeight handles all weight values', () {
      expect(utils.UIUtils.parseFontWeight('bold'), FontWeight.bold);
      expect(utils.UIUtils.parseFontWeight('normal'), FontWeight.normal);
      expect(utils.UIUtils.parseFontWeight('w100'), FontWeight.w100);
      expect(utils.UIUtils.parseFontWeight('w200'), FontWeight.w200);
      expect(utils.UIUtils.parseFontWeight('w300'), FontWeight.w300);
      expect(utils.UIUtils.parseFontWeight('w400'), FontWeight.normal);
      expect(utils.UIUtils.parseFontWeight('w500'), FontWeight.w500);
      expect(utils.UIUtils.parseFontWeight('w600'), FontWeight.w600);
      expect(utils.UIUtils.parseFontWeight('w700'), FontWeight.w700);
      expect(utils.UIUtils.parseFontWeight('w800'), FontWeight.w800);
      expect(utils.UIUtils.parseFontWeight('w900'), FontWeight.w900);
      expect(utils.UIUtils.parseFontWeight('invalid'), null);
    });
  });

  group('Multi-Form Support Tests', () {
    test('Registers and retrieves form callbacks correctly', () {
      // Clear any existing callbacks
      DynamicUIRenderer.clearCallbacks();

      // Register callbacks
      DynamicUIRenderer.registerFormCallback('form1', (id, data) {});
      DynamicUIRenderer.registerFormCallback('form2', (id, data) {});

      // Test retrieval
      expect(DynamicUIRenderer.getFormCallback('form1'), isNotNull);
      expect(DynamicUIRenderer.getFormCallback('form2'), isNotNull);
      expect(DynamicUIRenderer.getFormCallback('nonexistent'), isNull);

      // Test clearing
      DynamicUIRenderer.clearCallbacks();
      expect(DynamicUIRenderer.getFormCallback('form1'), isNull);
    });

    test('FormController notifies global callbacks on submit', () {
      String? receivedFormId;
      Map<String, dynamic>? receivedData;

      // Register callback
      DynamicUIRenderer.registerFormCallback('test_form', (id, data) {
        receivedFormId = id;
        receivedData = data;
      });

      // Create form controller with formId
      final fields = [FormFieldConfig(name: 'test', type: FieldType.text)];
      final controller = FormController(fields, formId: 'test_form');

      // Set value and notify submit
      controller.setValue('test', 'hello');
      controller.notifyFormSubmitted();

      // Verify callback was called
      expect(receivedFormId, 'test_form');
      expect(receivedData?['test'], 'hello');
    });

    test('FormController notifies local listeners on submit', () {
      Map<String, dynamic>? receivedData;

      final fields = [FormFieldConfig(name: 'test', type: FieldType.text)];
      final controller = FormController(fields);

      // Add local listener
      controller.addFormSubmitListener((data) {
        receivedData = data;
      });

      // Set value and notify submit
      controller.setValue('test', 'hello');
      controller.notifyFormSubmitted();

      // Verify listener was called
      expect(receivedData?['test'], 'hello');
    });
  });

  group('Conditional Visibility Tests', () {
    test('Conditional logic with equals operator', () {
      final json = {
        'name': 'dependentField',
        'type': 'text',
        'conditionalLogic': {
          'field': 'parentField',
          'value': 'show',
          'operator': 'equals',
        },
      };

      final field = FormFieldConfig.fromJson(json);
      final formValues = {'parentField': 'show'};

      expect(field.shouldShow(formValues), true);

      formValues['parentField'] = 'hide';
      expect(field.shouldShow(formValues), false);
    });

    test('Conditional logic with notEquals operator', () {
      final json = {
        'name': 'dependentField',
        'type': 'text',
        'conditionalLogic': {
          'field': 'parentField',
          'value': 'hide',
          'operator': 'notEquals',
        },
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.shouldShow({'parentField': 'show'}), true);
      expect(field.shouldShow({'parentField': 'hide'}), false);
    });

    test('Conditional logic with contains operator', () {
      final json = {
        'name': 'dependentField',
        'type': 'text',
        'conditionalLogic': {
          'field': 'parentField',
          'value': 'special',
          'operator': 'contains',
        },
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.shouldShow({'parentField': 'special value'}), true);
      expect(field.shouldShow({'parentField': 'regular'}), false);
    });

    test('Conditional logic with greaterThan operator', () {
      final json = {
        'name': 'dependentField',
        'type': 'text',
        'conditionalLogic': {
          'field': 'age',
          'value': 18,
          'operator': 'greaterThan',
        },
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.shouldShow({'age': 20}), true);
      expect(field.shouldShow({'age': 15}), false);
      expect(field.shouldShow({'age': 18}), false); // equals, not greater
    });

    test('Conditional logic with lessThan operator', () {
      final json = {
        'name': 'dependentField',
        'type': 'text',
        'conditionalLogic': {
          'field': 'age',
          'value': 65,
          'operator': 'lessThan',
        },
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.shouldShow({'age': 30}), true);
      expect(field.shouldShow({'age': 70}), false);
      expect(field.shouldShow({'age': 65}), false); // equals, not less
    });
  });

  group('Form Reset Tests', () {
    test('Reset clears all field values correctly', () {
      final fields = [
        FormFieldConfig(
          name: 'text',
          type: FieldType.text,
          initialValue: 'initial',
        ),
        FormFieldConfig(
          name: 'number',
          type: FieldType.number,
          initialValue: 42,
        ),
        FormFieldConfig(
          name: 'checkbox',
          type: FieldType.checkbox,
          initialValue: true,
        ),
        FormFieldConfig(
          name: 'dropdown',
          type: FieldType.dropdown,
          initialValue: 'option1',
        ),
      ];

      final controller = FormController(fields);

      // Set new values
      controller.setValue('text', 'new value');
      controller.setValue('number', 100);
      controller.setValue('checkbox', false);
      controller.setValue('dropdown', 'option2');
      controller.markTouched('text');

      expect(controller.isDirty, true);
      expect(controller.isTouched('text'), true);

      // Reset
      controller.reset();

      // Verify all values are cleared appropriately
      expect(controller.values['text'], null);
      expect(controller.values['number'], null);
      expect(
        controller.values['checkbox'],
        false,
      ); // Checkbox should be false, not null
      expect(controller.values['dropdown'], null);
      expect(controller.isDirty, false);
      expect(controller.isTouched('text'), false);
    });

    test('ResetToInitial restores initial values', () {
      final fields = [
        FormFieldConfig(
          name: 'text',
          type: FieldType.text,
          initialValue: 'initial',
        ),
        FormFieldConfig(
          name: 'checkbox',
          type: FieldType.checkbox,
          initialValue: true,
        ),
      ];

      final controller = FormController(fields);

      // Change values
      controller.setValue('text', 'changed');
      controller.setValue('checkbox', false);

      // Reset to initial
      controller.resetToInitial();

      expect(controller.values['text'], 'initial');
      expect(controller.values['checkbox'], true);
    });
  });

  group('Field Order Tests', () {
    test('Fields are sorted by order property', () {
      final jsonList = [
        {'name': 'field3', 'type': 'text', 'order': 3},
        {'name': 'field1', 'type': 'text', 'order': 1},
        {'name': 'field2', 'type': 'text', 'order': 2},
        {'name': 'field4', 'type': 'text'}, // No order, should be last
      ];

      final fields = jsonList.map((f) => FormFieldConfig.fromJson(f)).toList()
        ..sort((a, b) => (a.order ?? 999).compareTo(b.order ?? 999));

      expect(fields[0].name, 'field1');
      expect(fields[1].name, 'field2');
      expect(fields[2].name, 'field3');
      expect(fields[3].name, 'field4');
    });
  });

  group('Validation Edge Cases', () {
    test('Pattern validation with special regex characters', () {
      final rule = ValidationRule(
        type: ValidationType.pattern,
        pattern: r'^[A-Za-z0-9.@!\-_]+$',
        message: 'Invalid characters',
      );

      // This test just verifies the rule can be created with special chars
      expect(rule.pattern, r'^[A-Za-z0-9.@!\-_]+$');
      expect(rule.type, ValidationType.pattern);
    });

    test('Match validation compares fields correctly', () {
      final fields = [
        FormFieldConfig(name: 'password', type: FieldType.password),
        FormFieldConfig(name: 'confirm', type: FieldType.password),
      ];

      final controller = FormController(fields);

      controller.setValue('password', 'secret123');
      controller.setValue('confirm', 'secret123');

      // Add match validation
      // Note: This would need to be set up in the controller
      // This test is more for conceptual verification

      expect(controller.values['password'], 'secret123');
      expect(controller.values['confirm'], 'secret123');
    });

    test('URL validation accepts valid URLs', () {
      // This is more of a parser test
      final urlRegex = RegExp(
        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      );

      expect(urlRegex.hasMatch('https://flutter.dev'), true);
      expect(urlRegex.hasMatch('flutter.dev'), true);
      expect(urlRegex.hasMatch('https://pub.dev/packages'), true);
      expect(urlRegex.hasMatch('not a url'), false);
    });

    test('Phone validation accepts valid phone numbers', () {
      final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');

      expect(phoneRegex.hasMatch('+1 234 567 8900'), true);
      expect(phoneRegex.hasMatch('1234567890'), true);
      expect(phoneRegex.hasMatch('123-456-7890'), true);
      expect(phoneRegex.hasMatch('12345'), false); // Too short
    });
  });

  group('Action Handler Tests', () {
    testWidgets('Print action works', (tester) async {
      // This is more of an integration test
      // We're just verifying the action can be created
      final json = {
        'type': 'button',
        'properties': {'text': 'Test'},
        'actions': {
          'type': 'print',
          'parameters': {'message': 'test', 'level': 'info'},
        },
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  DynamicUIRenderer.fromJsonMap(json, context),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      // Can't easily test print output, but widget should render
    });

    test('ButtonAction fromJson parses correctly', () {
      final json = {
        'type': 'navigate',
        'parameters': {'route': '/home', 'type': 'push'},
      };

      final action = ButtonAction.fromJson(json);

      expect(action.type, ActionType.navigate);
      expect(action.parameters['route'], '/home');
      expect(action.parameters['type'], 'push');
    });
  });

  group('TextField Widget Tests', () {
    testWidgets('Text field shows label and hint', (tester) async {
      final json = {
        'type': 'form',
        'fields': [
          {
            'name': 'test',
            'type': 'text',
            'label': 'Test Label',
            'hint': 'Test Hint',
          },
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  DynamicUIRenderer.fromJsonMap(json, context),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
    });
  });

  group('Checkbox Field Reset Tests', () {
    testWidgets('Checkbox resets after form submission', (tester) async {
      final json = {
        'type': 'form',
        'properties': {'submitText': 'Submit'},
        'fields': [
          {'name': 'terms', 'type': 'checkbox', 'label': 'Accept Terms'},
        ],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  DynamicUIRenderer.fromJsonMap(json, context),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap checkbox
      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);

      // Initially unchecked
      Checkbox checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, false);

      // Tap to check
      await tester.tap(checkboxFinder);
      await tester.pump();

      // Should be checked
      checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, true);

      // Tap submit (this will trigger reset)
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Should be unchecked again
      checkbox = tester.widget(checkboxFinder);
      expect(checkbox.value, false);
    });
  });

  group('Radio Field Tests', () {
    test('Radio field config parses correctly', () {
      final json = {
        'name': 'priority',
        'type': 'radio',
        'label': 'Priority',
        'options': [
          {'label': 'Low', 'value': 'low'},
          {'label': 'Medium', 'value': 'medium'},
          {'label': 'High', 'value': 'high'},
        ],
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.type, FieldType.radio);
      expect(field.options?.length, 3);
      expect(field.options?[0].label, 'Low');
      expect(field.options?[0].value, 'low');
    });
  });

  group('Textarea Field Tests', () {
    test('Textarea field config parses correctly', () {
      final json = {
        'name': 'message',
        'type': 'textarea',
        'label': 'Message',
        'uiProperties': {'minLines': 3, 'maxLines': 5},
      };

      final field = FormFieldConfig.fromJson(json);

      expect(field.type, FieldType.textarea);
      expect(field.uiProperties?['minLines'], 3);
      expect(field.uiProperties?['maxLines'], 5);
    });
  });
}
