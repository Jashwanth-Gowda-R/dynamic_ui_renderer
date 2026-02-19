# dynamic_ui_renderer

[![pub package](https://img.shields.io/pub/v/dynamic_ui_renderer.svg)](https://pub.dev/packages/dynamic_ui_renderer)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

A powerful Flutter package for rendering UI dynamically from JSON responses.

Build forms, screens, and components from server-driven JSON — without requiring app updates.

---

## ✨ Features

* ✅ Render UI dynamically from JSON
* ✅ Build dynamic forms with validation
* ✅ Server-Driven UI (update without releasing new app versions)
* ✅ Extensible architecture (add custom widgets easily)
* ✅ Type-safe Dart implementation
* ✅ Lightweight (minimal dependencies)
* ✅ Well tested with strong coverage
* ✅ Production ready — reusable across multiple apps

---

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  dynamic_ui_renderer: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

```dart
import 'package:dynamic_ui_renderer/dynamic_ui_renderer.dart';

String json = '''
{
  "type": "column",
  "children": [
    {
      "type": "text",
      "properties": {
        "text": "Hello from Server!",
        "fontSize": 24,
        "color": "#2196F3",
        "fontWeight": "bold"
      }
    },
    {
      "type": "button",
      "children": [
        {
          "type": "text",
          "properties": {
            "text": "Click Me",
            "color": "#FFFFFF"
          }
        }
      ]
    }
  ]
}
''';

Widget myUI = DynamicUIRenderer.fromJsonString(json);
```

---

# 📖 Documentation

## 📝 JSON Schema Reference

---

## 🧾 Text Widget

```json
{
  "type": "text",
  "properties": {
    "text": "Your text here",
    "fontSize": 16,
    "fontWeight": "bold",
    "color": "#FF0000",
    "textAlign": "center"
  }
}
```

### Supported Properties

| Property   | Type   | Description             |
| ---------- | ------ | ----------------------- |
| text       | String | Required                |
| fontSize   | Number | Optional                |
| fontWeight | String | bold, normal, w100–w900 |
| color      | String | Hex color               |
| textAlign  | String | left, center, right     |

---

## 📦 Container Widget

```json
{
  "type": "container",
  "properties": {
    "padding": 16,
    "margin": [8, 16, 8, 16],
    "color": "#F5F5F5",
    "width": 200,
    "height": 100
  },
  "children": []
}
```

### Notes

* `padding` and `margin` can be:

  * Single number → applied to all sides
  * List `[L, T, R, B]`

---

## 🔘 Button Widget

```json
{
  "type": "button",
  "children": [
    {
      "type": "text",
      "properties": {
        "text": "Submit"
      }
    }
  ],
  "actions": {
    "type": "navigate",
    "route": "/details"
  }
}
```

### Supported Actions

| Action Type | Description             |
| ----------- | ----------------------- |
| navigate    | Navigate to a route     |
| callback    | Trigger custom callback |

---

## 📐 Column / Row Widget

```json
{
  "type": "column",
  "properties": {
    "mainAxisAlignment": "center",
    "crossAxisAlignment": "stretch"
  },
  "children": []
}
```

### Supported Alignments

**Main Axis**

* start
* center
* end
* spaceBetween
* spaceAround
* spaceEvenly

**Cross Axis**

* start
* center
* end
* stretch

---

# 🧩 Advanced Usage

## 🔐 Example: Login Form

```dart
String loginFormJson = '''
{
  "type": "column",
  "children": [
    {
      "type": "text",
      "properties": {
        "text": "Welcome Back!",
        "fontSize": 28,
        "fontWeight": "bold",
        "color": "#1976D2"
      }
    },
    {
      "type": "container",
      "properties": {
        "padding": 20,
        "margin": [0, 20, 0, 0],
        "color": "#FFFFFF"
      },
      "children": [
        {
          "type": "column",
          "children": [
            {
              "type": "text",
              "properties": {
                "text": "Email",
                "fontSize": 14
              }
            },
            {
              "type": "container",
              "properties": {
                "padding": 12,
                "color": "#F5F5F5"
              },
              "children": [
                {
                  "type": "text",
                  "properties": {
                    "text": "user@example.com"
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
''';

Widget loginForm = DynamicUIRenderer.fromJsonString(loginFormJson);
```

---

## 🌐 Fetch UI from Server

```dart
Future<Widget> fetchUIFromServer() async {
  try {
    final response = await http.get(
      Uri.parse('https://api.example.com/ui/home')
    );

    if (response.statusCode == 200) {
      return DynamicUIRenderer.fromJsonString(response.body);
    }

    return const Text('Failed to load UI');
  } catch (e) {
    return Text('Network error: $e');
  }
}
```

---

# 🧪 Testing

Run tests:

```bash
flutter test
```

Run with coverage:

```bash
flutter test --coverage
```

---

# 🏗 Architecture Overview

* JSON → Parsed into internal model
* Widget Factory → Maps type to Flutter widgets
* Properties Parser → Converts JSON values safely
* Action Handler → Handles navigation and callbacks

Extensible architecture allows registering custom widgets easily.

---

# 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create your feature branch

   ```bash
   git checkout -b feature/amazing-feature
   ```
3. Commit your changes

   ```bash
   git commit -m "Add amazing feature"
   ```
4. Push to branch

   ```bash
   git push origin feature/amazing-feature
   ```
5. Open a Pull Request

---

# 📄 License

This project is licensed under the MIT License.
See the [LICENSE](https://opensource.org/licenses/MIT) file for details.

---

# 🙏 Acknowledgments

Inspired by server-driven UI patterns used at Prowork, Airbnb, Lyft, and other tech companies.

Built with ❤️ for the Flutter community.

---

# 📞 Support

* 📧 Email: [webdevjash6@gmail.com](mailto:webdevjash6@gmail.com)
* 🐛 Issues: [https://github.com/Jashwanth-Gowda-R/dynamic_ui_renderer/issues](https://github.com/Jashwanth-Gowda-R/dynamic_ui_renderer/issues)

---
