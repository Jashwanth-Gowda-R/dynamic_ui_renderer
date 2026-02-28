
```markdown
# dynamic_ui_renderer

[![pub package](https://img.shields.io/pub/v/dynamic_ui_renderer.svg)](https://pub.dev/packages/dynamic_ui_renderer)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)

A powerful Flutter package for rendering UI dynamically from JSON responses. Build forms, screens, and components from server-driven JSON — without requiring app updates.

**Perfect for:** Server-Driven UI (SDUI), Dynamic Forms, A/B Testing, CMS-driven UIs, and White-Label Apps

---

## ✨ Features (v0.2.0)

### 📝 **Complete Forms & Validation System**
- ✅ **Dynamic Form Widget** - Full-featured form container with validation
- ✅ **10+ Field Types** - Text, Email, Password, Number, Phone, Dropdown, Checkbox, Date, Textarea, Radio
- ✅ **Real-time Validation** - Validate as users type with instant feedback
- ✅ **Multi-Form Support** - Handle multiple independent forms with unique IDs
- ✅ **Form Callbacks** - Global and per-form submission callbacks with form data
- ✅ **Conditional Visibility** - Show/hide fields based on other field values
- ✅ **Form Reset** - Complete form reset for all field types

### ✅ **12+ Validation Rules**
| Rule | Description | Example |
|------|-------------|---------|
| `required` | Field must have a value | `{"type": "required"}` |
| `email` | Valid email format | `{"type": "email"}` |
| `minLength` | Minimum character length | `{"type": "minLength", "value": 8}` |
| `maxLength` | Maximum character length | `{"type": "maxLength", "value": 50}` |
| `minValue` | Minimum numeric value | `{"type": "minValue", "value": 18}` |
| `maxValue` | Maximum numeric value | `{"type": "maxValue", "value": 120}` |
| `pattern` | Regex pattern matching | `{"type": "pattern", "pattern": "^[A-Z]+$"}` |
| `match` | Match another field's value | `{"type": "match", "value": "password"}` |
| `phone` | Valid phone number format | `{"type": "phone"}` |
| `url` | Valid URL format | `{"type": "url"}` |
| `date` | Valid date format | `{"type": "date"}` |
| `custom` | Custom validation logic | `{"type": "custom", "customConfig": {...}}` |

### 🎯 **Complete Action System**
- ✅ **Print** - Debug logging with levels (info/warning/error)
- ✅ **Dialog** - Alert dialogs with custom titles and messages
- ✅ **Snackbar** - Toast notifications with action buttons
- ✅ **URL Launch** - Open web links in browser (uses `url_launcher`)
- ✅ **Bottom Sheet** - Modal bottom sheets
- ✅ **Navigation** - Screen navigation with push/pop strategies

### 🎨 **Core Widgets**
- ✅ **Text** - Full styling (size, weight, color, alignment)
- ✅ **Container** - Padding, margin, color, dimensions, border radius
- ✅ **Button** - Styled buttons with actions
- ✅ **Column** - Vertical layouts with alignment
- ✅ **Row** - Horizontal layouts with alignment

### 🛠️ **Developer Experience**
- ✅ **Type-safe JSON parsing** - No runtime surprises
- ✅ **Error handling** - Graceful fallbacks with user-friendly messages
- ✅ **Context propagation** - Automatic for navigation and dialogs
- ✅ **Extensible architecture** - Easy to add custom widgets
- ✅ **Well tested** - 95%+ code coverage
- ✅ **Lightweight** - Minimal dependencies (`url_launcher` only)

---

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  dynamic_ui_renderer: ^0.2.0
```

Then run:

```bash
flutter pub get
```

> **Note:** The package automatically includes `url_launcher` for web URL support. No additional setup needed!

---

## 🚀 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:dynamic_ui_renderer/dynamic_ui_renderer.dart';

void main() {
  // Register form callbacks (optional)
  DynamicUIRenderer.registerFormCallback('login_form', (formId, formData) {
    print('Login form submitted: $formData');
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Dynamic UI Demo')),
        body: DynamicUIRenderer.fromJsonString('''
        {
          "type": "column",
          "properties": {
            "crossAxisAlignment": "stretch",
            "padding": 16
          },
          "children": [
            {
              "type": "text",
              "properties": {
                "text": "Login Form",
                "fontSize": 24,
                "fontWeight": "bold",
                "color": "#2196F3"
              }
            },
            {
              "type": "form",
              "properties": {
                "formId": "login_form",
                "submitText": "Login",
                "submitButtonColor": "#4CAF50"
              },
              "fields": [
                {
                  "name": "email",
                  "type": "email",
                  "label": "Email",
                  "required": true,
                  "validations": [
                    {"type": "email", "message": "Invalid email"}
                  ]
                },
                {
                  "name": "password",
                  "type": "password",
                  "label": "Password",
                  "required": true,
                  "validations": [
                    {"type": "minLength", "value": 6}
                  ]
                },
                {
                  "name": "rememberMe",
                  "type": "checkbox",
                  "label": "Remember me"
                }
              ]
            }
          ]
        }
        ''', context, formId: 'login_form'),
      ),
    );
  }
}
```

---

## 📖 Documentation

### 📝 Form JSON Schema

#### Form Widget

```json
{
  "type": "form",
  "properties": {
    "formId": "unique_form_id",           // Optional: for multi-form support
    "title": "Form Title",                 // Optional
    "titleFontSize": 18,                   // Optional
    "titleColor": "#1976D2",               // Optional
    "backgroundColor": "#FFFFFF",          // Optional
    "padding": 20,                         // Optional
    "borderRadius": 12,                    // Optional
    "elevation": 4,                        // Optional
    "submitText": "Submit",                 // Optional: default "Submit"
    "submitButtonColor": "#4CAF50",         // Optional
    "submitButtonTextColor": "#FFFFFF",     // Optional
    "submitButtonRadius": 8,                // Optional
    "submitButtonHeight": 48,               // Optional
    "showValidationMessage": true,          // Optional: show error snackbar
    "validationMessage": "Please fix errors" // Optional: custom error message
  },
  "fields": [] // Array of field configurations
}
```

### 📝 Field Types Reference

#### Text Field
```json
{
  "name": "username",
  "type": "text",
  "label": "Username",
  "hint": "Enter your username",
  "placeholder": "johndoe",
  "required": true,
  "requiredMessage": "Username is required",
  "order": 1,
  "validations": [
    {"type": "minLength", "value": 3, "message": "Minimum 3 characters"},
    {"type": "maxLength", "value": 20, "message": "Maximum 20 characters"}
  ],
  "uiProperties": {
    "borderRadius": 8,
    "filled": true,
    "fillColor": "#F5F5F5",
    "fontSize": 16,
    "prefixIcon": "person",
    "prefixIconColor": "#757575"
  }
}
```

#### Email Field
```json
{
  "name": "email",
  "type": "email",
  "label": "Email Address",
  "hint": "Enter your email",
  "required": true,
  "validations": [
    {"type": "email", "message": "Invalid email format"}
  ],
  "uiProperties": {
    "prefixIcon": "email"
  }
}
```

#### Password Field
```json
{
  "name": "password",
  "type": "password",
  "label": "Password",
  "hint": "Create a strong password",
  "required": true,
  "validations": [
    {"type": "minLength", "value": 8, "message": "Minimum 8 characters"},
    {"type": "pattern", "pattern": "^(?=.*[A-Za-z])(?=.*\\d).{8,}$", 
     "message": "Must contain letter and number"}
  ],
  "uiProperties": {
    "prefixIcon": "lock"
  }
}
```

#### Number Field
```json
{
  "name": "age",
  "type": "number",
  "label": "Age",
  "hint": "Enter your age",
  "validations": [
    {"type": "minValue", "value": 18, "message": "Must be 18 or older"},
    {"type": "maxValue", "value": 120, "message": "Invalid age"}
  ]
}
```

#### Phone Field
```json
{
  "name": "phone",
  "type": "phone",
  "label": "Phone Number",
  "hint": "Enter your phone number",
  "validations": [
    {"type": "phone", "message": "Invalid phone number"}
  ],
  "uiProperties": {
    "prefixIcon": "phone"
  }
}
```

#### Dropdown Field
```json
{
  "name": "country",
  "type": "dropdown",
  "label": "Country",
  "hint": "Select your country",
  "required": true,
  "options": [
    {"label": "United States", "value": "us", "icon": {"name": "home"}},
    {"label": "India", "value": "in", "icon": {"name": "home"}},
    {"label": "United Kingdom", "value": "uk", "disabled": true}
  ]
}
```

#### Checkbox Field
```json
{
  "name": "termsAccepted",
  "type": "checkbox",
  "label": "I accept the Terms and Conditions",
  "required": true,
  "requiredMessage": "You must accept the terms",
  "uiProperties": {
    "activeColor": "#4CAF50",
    "checkColor": "#FFFFFF"
  }
}
```

#### Date Field
```json
{
  "name": "birthDate",
  "type": "date",
  "label": "Birth Date",
  "hint": "Select your birth date",
  "uiProperties": {
    "format": "dd/MM/yyyy",
    "iconColor": "#1976D2"
  }
}
```

#### Textarea Field
```json
{
  "name": "message",
  "type": "textarea",
  "label": "Message",
  "hint": "Type your message",
  "required": true,
  "uiProperties": {
    "minLines": 3,
    "maxLines": 5
  }
}
```

#### Radio Field
```json
{
  "name": "priority",
  "type": "radio",
  "label": "Priority",
  "options": [
    {"label": "Low", "value": "low"},
    {"label": "Medium", "value": "medium"},
    {"label": "High", "value": "high"}
  ]
}
```

### 🎬 Available Action Types

| Type | Description | Required Parameters | Example |
|------|-------------|---------------------|---------|
| `print` | Print to console | `message`, `level` | `{"message": "Hello", "level": "info"}` |
| `showDialog` | Show alert dialog | `title`, `message`, `buttonText` | `{"title": "Alert", "message": "Hello"}` |
| `showSnackbar` | Show snackbar | `message`, `duration`, `actionLabel` | `{"message": "Saved!", "duration": 3}` |
| `launchUrl` | Open URL in browser | `url`, `mode` | `{"url": "https://flutter.dev"}` |
| `showBottomSheet` | Show modal bottom sheet | `title`, `message`, `buttonText` | `{"title": "Options"}` |
| `navigate` | Navigate to route | `route`, `type` | `{"route": "/home", "type": "push"}` |

---

## 🎯 Complete Examples

### 📝 Multi-Form Demo

```dart
// Register multiple form callbacks
DynamicUIRenderer.registerFormCallback('login_form', (formId, formData) {
  print('Login: $formData');
});

DynamicUIRenderer.registerFormCallback('register_form', (formId, formData) {
  print('Registration: $formData');
});

// Render forms with different IDs
Column(
  children: [
    DynamicUIRenderer.fromJsonString(loginFormJson, context, formId: 'login_form'),
    DynamicUIRenderer.fromJsonString(registerFormJson, context, formId: 'register_form'),
  ],
);
```

### 🔄 Dynamic Layout with Order Property

```json
{
  "type": "form",
  "fields": [
    {"name": "field1", "type": "text", "label": "Field 1", "order": 3},
    {"name": "field2", "type": "text", "label": "Field 2", "order": 1},
    {"name": "field3", "type": "text", "label": "Field 3", "order": 2}
  ]
}
// Fields will render in order: field2, field3, field1
```

### 🌐 Fetch UI from Server

```dart
Future<Widget> fetchUIFromServer(BuildContext context, String formId) async {
  try {
    final response = await http.get(
      Uri.parse('https://api.example.com/forms/$formId')
    );

    if (response.statusCode == 200) {
      return DynamicUIRenderer.fromJsonString(
        response.body, 
        context,
        formId: formId,
      );
    }
    return Text('Error: ${response.statusCode}');
  } catch (e) {
    return Text('Network error: $e');
  }
}
```

---

## 📱 Complete Demo App

Check out the `/example` folder for a complete Flutter app demonstrating all features:

```bash
cd example
flutter run
```

The example app includes:
- 🎯 **Button Actions Demo** - Test all 6 action types
- 📱 **Core Widgets Demo** - Basic widgets showcase
- 🎨 **Styling Properties Demo** - Colors, fonts, padding, margins
- 📐 **Layout Examples Demo** - Different alignments and arrangements
- 📝 **Multi-Form Demo** - Three independent forms with real-time data display
  - Registration Form with all field types
  - Contact Form with dropdown and textarea
  - Dynamic Layout Form with toggleable field order
- ⚠️ **Error Handling Demo** - Graceful fallbacks for unsupported widgets

---

## 🏗 Architecture Overview

```
JSON → UIComponent (Model) → WidgetFactory → Flutter Widget
        ↓              ↓
   Form Models    Properties Parser
        ↓              ↓
FormController    Action Handler
        ↓              ↓
  Validation      Navigation/Dialogs
```

The package follows a clean, modular architecture:
1. **JSON Parsing** - Converts JSON to type-safe models
2. **Form Models** - Type-safe field and validation rule definitions
3. **FormController** - Manages form state, validation, and submissions
4. **Widget Factory** - Maps component types to Flutter widgets
5. **Property Parsers** - Safely converts JSON values to Flutter types
6. **Action Handler** - Executes user interactions

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
# Then open coverage/html/index.html
```

---

## 📊 Package Statistics

| Metric | Value |
|--------|-------|
| **Latest Version** | v0.2.0 |
| **Published** | February 2026 |
| **License** | MIT |
| **Platforms** | Android, iOS, Web, macOS, Linux, Windows |
| **Dependencies** | `url_launcher` (automatically included) |
| **Field Types** | 10+ |
| **Validation Rules** | 12+ |
| **Test Coverage** | 95%+ |

---

## 🤝 Contributing

Contributions are welcome! Whether it's:
- 🐛 Reporting bugs
- 💡 Suggesting features
- 📝 Improving documentation
- 🔧 Submitting pull requests

**Steps to contribute:**

1. Fork the repository
2. Create your feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add some amazing feature"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/amazing-feature
   ```
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://pub.dev/packages/dynamic_ui_renderer/license) file for details.

---

## 🙏 Acknowledgments

- Inspired by server-driven UI patterns at **Airbnb**, **Lyft**, and **Prowork**
- Built with ❤️ for the Flutter community
- Thanks to all contributors and users

---

## 📞 Support

- 📧 **Email**: [webdevjash6@gmail.com](mailto:webdevjash6@gmail.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/Jashwanth-Gowda-R/dynamic_ui_renderer/issues)
- ⭐ **Star**: [GitHub Repository](https://github.com/Jashwanth-Gowda-R/dynamic_ui_renderer)

---

## 🔮 Coming Soon (v0.3.0)

- 🚀 **Network Fetching** - Load UI directly from URLs
- 💾 **Caching** - Cache UI definitions locally
- 🧩 **Custom Widget Registry** - Register your own widgets
- 🎨 **Theme Support** - Dynamic theming from JSON
- 📦 **Plugin System** - Easy third-party integrations

---

<div align="center">

**Made with ❤️ by [Jashwanth Gowda R](https://github.com/Jashwanth-Gowda-R)**

If you find this package useful, please consider:
- ⭐ **Starring** the [GitHub repository](https://github.com/Jashwanth-Gowda-R/dynamic_ui_renderer)
- 📢 **Sharing** it with others
- 🐛 **Reporting** issues
-  💡 **Suggesting** features

</div>

