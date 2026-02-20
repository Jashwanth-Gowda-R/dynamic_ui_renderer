

# dynamic_ui_renderer

[![pub package](https://img.shields.io/pub/v/dynamic_ui_renderer.svg)](https://pub.dev/packages/dynamic_ui_renderer)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev)

A powerful Flutter package for rendering UI dynamically from JSON responses. Build forms, screens, and components from server-driven JSON — without requiring app updates.

**Perfect for:** Server-Driven UI (SDUI), Dynamic Forms, A/B Testing, CMS-driven UIs, and White-Label Apps

---

## ✨ Features (v0.1.0)

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
- ✅ **Well tested** - 90%+ code coverage
- ✅ **Lightweight** - Minimal dependencies

---

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  dynamic_ui_renderer: ^0.1.0
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
            "mainAxisAlignment": "center",
            "crossAxisAlignment": "center",
            "padding": 16
          },
          "children": [
            {
              "type": "text",
              "properties": {
                "text": "Hello from JSON! 👋",
                "fontSize": 24,
                "fontWeight": "bold",
                "color": "#2196F3",
                "textAlign": "center"
              }
            },
            {
              "type": "container",
              "properties": {
                "margin": [0, 20, 0, 0],
                "padding": 16,
                "color": "#E3F2FD",
                "borderRadius": 8
              },
              "children": [
                {
                  "type": "text",
                  "properties": {
                    "text": "This entire UI is rendered from JSON!",
                    "color": "#1565C0"
                  }
                }
              ]
            },
            {
              "type": "button",
              "properties": {
                "text": "Click Me",
                "backgroundColor": "#4CAF50",
                "foregroundColor": "#FFFFFF",
                "borderRadius": 8,
                "margin": [0, 20, 0, 0]
              },
              "actions": {
                "type": "showDialog",
                "parameters": {
                  "title": "Welcome! 🎉",
                  "message": "Button clicked successfully!",
                  "buttonText": "OK"
                }
              }
            }
          ]
        }
        ''', context),
      ),
    );
  }
}
```

---

## 📖 Documentation

### 📝 JSON Schema Reference

---

#### 🧾 Text Widget

```json
{
  "type": "text",
  "properties": {
    "text": "Your text here",        // Required
    "fontSize": 16,                   // Optional
    "fontWeight": "bold",              // Optional: bold, normal, w100-w900
    "color": "#FF0000",                // Optional: hex color (#RGB or #RRGGBB)
    "textAlign": "center"              // Optional: left, center, right
  }
}
```

---

#### 📦 Container Widget

```json
{
  "type": "container",
  "properties": {
    "padding": 16,                     // Optional: number or [L,T,R,B]
    "margin": [8, 16, 8, 16],          // Optional: number or [L,T,R,B]
    "color": "#F5F5F5",                 // Optional: hex color
    "width": 200,                       // Optional: number
    "height": 100,                       // Optional: number
    "borderRadius": 8                    // Optional: number
  },
  "children": []                         // Optional: child components
}
```

**Padding/Margin Examples:**
- Single value: `"padding": 16` → applies to all sides
- List: `"padding": [8, 16, 8, 16]` → [left, top, right, bottom]

---

#### 🔘 Button Widget with Actions

```json
{
  "type": "button",
  "properties": {
    "text": "Click Me",                  // Optional (use if no children)
    "backgroundColor": "#4CAF50",        // Optional: hex color
    "foregroundColor": "#FFFFFF",        // Optional: text/icon color
    "borderRadius": 8,                   // Optional: number
    "elevation": 4,                       // Optional: number
    "padding": [8, 16, 8, 16]             // Optional: number or list
  },
  "children": [                           // Optional: custom button content
    {
      "type": "text",
      "properties": {
        "text": "Click Me",
        "color": "#FFFFFF"
      }
    }
  ],
  "actions": {                            // Required for interactivity
    "type": "navigate",                    // Action type
    "parameters": {                         // Action-specific parameters
      "route": "/details",
      "type": "push",
      "arguments": {
        "id": 123,
        "name": "Product"
      }
    }
  }
}
```

### 🎬 Available Action Types

| Type | Description | Required Parameters | Example |
|------|-------------|---------------------|---------|
| `print` | Print to console | `message`, `level` (info/warning/error) | `{"message": "Hello", "level": "info"}` |
| `showDialog` | Show alert dialog | `title`, `message`, `buttonText` | `{"title": "Alert", "message": "Hello"}` |
| `showSnackbar` | Show snackbar | `message`, `duration`, `actionLabel` | `{"message": "Saved!", "duration": 3}` |
| `launchUrl` | Open URL in browser | `url`, `mode` (inApp/external) | `{"url": "https://flutter.dev"}` |
| `showBottomSheet` | Show modal bottom sheet | `title`, `message`, `buttonText` | `{"title": "Options", "message": "Choose"}` |
| `navigate` | Navigate to route | `route`, `type` (push/pushReplacement/pop) | `{"route": "/home", "type": "push"}` |

---

#### 📐 Column / Row Widget

```json
{
  "type": "column",  // or "row"
  "properties": {
    "mainAxisAlignment": "center",        // Optional: alignment along main axis
    "crossAxisAlignment": "stretch",      // Optional: alignment along cross axis
    "padding": 16,                        // Optional: padding around the whole column/row
    "margin": [8, 16, 8, 16]              // Optional: margin around the whole column/row
  },
  "children": []                           // Required: list of child components
}
```

**MainAxisAlignment Options:**
- `start` - Children at the start
- `center` - Children centered
- `end` - Children at the end
- `spaceBetween` - Space evenly between children
- `spaceAround` - Space evenly around children
- `spaceEvenly` - Space evenly including ends

**CrossAxisAlignment Options:**
- `start` - Children at the start
- `center` - Children centered
- `end` - Children at the end
- `stretch` - Children stretch to fill

---

## 🎯 Complete Examples

### 🔐 Login Form Example

```dart
String loginFormJson = '''
{
  "type": "column",
  "properties": {
    "crossAxisAlignment": "stretch",
    "padding": 20
  },
  "children": [
    {
      "type": "text",
      "properties": {
        "text": "Welcome Back! 👋",
        "fontSize": 28,
        "fontWeight": "bold",
        "color": "#1976D2",
        "textAlign": "center"
      }
    },
    {
      "type": "container",
      "properties": {
        "padding": 20,
        "margin": [0, 20, 0, 0],
        "color": "#FFFFFF",
        "borderRadius": 12
      },
      "children": [
        {
          "type": "column",
          "properties": {
            "crossAxisAlignment": "stretch"
          },
          "children": [
            {
              "type": "text",
              "properties": {
                "text": "Email",
                "fontSize": 14,
                "fontWeight": "bold",
                "color": "#757575"
              }
            },
            {
              "type": "container",
              "properties": {
                "padding": 16,
                "margin": [0, 4, 0, 16],
                "color": "#F5F5F5",
                "borderRadius": 8
              },
              "children": [
                {
                  "type": "text",
                  "properties": {
                    "text": "user@example.com",
                    "color": "#212121"
                  }
                }
              ]
            },
            {
              "type": "text",
              "properties": {
                "text": "Password",
                "fontSize": 14,
                "fontWeight": "bold",
                "color": "#757575"
              }
            },
            {
              "type": "container",
              "properties": {
                "padding": 16,
                "margin": [0, 4, 0, 0],
                "color": "#F5F5F5",
                "borderRadius": 8
              },
              "children": [
                {
                  "type": "text",
                  "properties": {
                    "text": "••••••••",
                    "color": "#212121"
                  }
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "type": "button",
      "properties": {
        "text": "Login",
        "backgroundColor": "#1976D2",
        "foregroundColor": "#FFFFFF",
        "borderRadius": 8,
        "margin": [0, 20, 0, 0],
        "padding": 16
      },
      "actions": {
        "type": "showDialog",
        "parameters": {
          "title": "Success! 🎉",
          "message": "Logged in successfully",
          "buttonText": "Continue"
        }
      }
    }
  ]
}
''';

Widget loginForm = DynamicUIRenderer.fromJsonString(loginFormJson, context);
```

### 🌐 Fetch UI from Server

```dart
import 'package:http/http.dart' as http;

Future<Widget> fetchUIFromServer(BuildContext context) async {
  try {
    final response = await http.get(
      Uri.parse('https://api.example.com/ui/home')
    );

    if (response.statusCode == 200) {
      return DynamicUIRenderer.fromJsonString(response.body, context);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text('Failed to load UI: ${response.statusCode}'),
        ],
      ),
    );
  } catch (e) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: Colors.orange, size: 48),
          const SizedBox(height: 16),
          Text('Network error: $e'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Retry logic
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
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
- ⚠️ **Error Handling Demo** - Graceful fallbacks for unsupported widgets

---

## 🏗 Architecture Overview

```
JSON → UIComponent (Model) → WidgetFactory → Flutter Widget
        ↓
    Properties Parser
        ↓
    Action Handler (Navigation, Dialogs, etc.)
```

The package follows a clean, modular architecture:
1. **JSON Parsing** - Converts JSON to type-safe models
2. **Widget Factory** - Maps component types to Flutter widgets
3. **Property Parsers** - Safely converts JSON values to Flutter types
4. **Action Handler** - Executes user interactions
5. **Context Propagation** - Automatically passes BuildContext for navigation

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

Please ensure your code:
- Passes all tests (`flutter test`)
- Follows Dart style guidelines (`dart format .`)
- Includes tests for new features
- Updates documentation as needed

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://pub.dev/packages/dynamic_ui_renderer/license) file for details.

---

## 🙏 Acknowledgments

- Inspired by server-driven UI patterns at **Airbnb**, **Lyft**, and **Prowork**
- Built with ❤️ for the Flutter community
- Thanks to all contributors and users

---

## 📊 Package Statistics

| Metric | Value |
|--------|-------|
| **Latest Version** | v0.1.0 |
| **Published** | February 2026 |
| **License** | MIT |
| **Platforms** | Android, iOS, Web, macOS, Linux, Windows |
| **Dependencies** | `url_launcher` (automatically included) |

---

## 📞 Support

- 📧 **Email**: [webdevjash6@gmail.com](mailto:webdevjash6@gmail.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/Jashwanth-Gowda-R/dynamic_ui_renderer/issues)
- ⭐ **Star**: [GitHub Repository](https://github.com/Jashwanth-Gowda-R/dynamic_ui_renderer)

---

## 🔮 Coming Soon 

- ✅ **Forms & Validation** - Form widgets with built-in validation
- ✅ **Network Fetching** - Load UI directly from URLs
- ✅ **Caching** - Cache UI definitions locally
- ✅ **Custom Widget Registry** - Register your own widgets
- ✅ **Theme Support** - Dynamic theming from JSON

---


**Made with ❤️ by [Jashwanth Gowda R](https://github.com/Jashwanth-Gowda-R)**

If you find this package useful, please consider:
- ⭐ **Starring** the [GitHub repository](https://github.com/Jashwanth-Gowda-R/dynamic_ui_renderer)
- 📢 **Sharing** it with others
- 🐛 **Reporting** issues
- 💡 **Suggesting** features

```