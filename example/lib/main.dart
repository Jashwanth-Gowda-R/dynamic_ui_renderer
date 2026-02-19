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
      title: 'Dynamic UI Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sample JSON that demonstrates all features
  final String _sampleJson = '''
  {
    "type": "column",
    "properties": {
      "mainAxisAlignment": "center",
      "crossAxisAlignment": "center"
    },
    "children": [
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "color": "#E3F2FD",
          "width": 300
        },
        "children": [
          {
            "type": "text",
            "properties": {
              "text": "🌟 Dynamic UI Renderer",
              "fontSize": 24,
              "fontWeight": "bold",
              "color": "#1565C0"
            }
          }
        ]
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "margin": [0, 16, 0, 0],
          "color": "#F5F5F5"
        },
        "children": [
          {
            "type": "column",
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Welcome to Server-Driven UI!",
                  "fontSize": 18,
                  "color": "#424242"
                }
              },
              {
                "type": "text",
                "properties": {
                  "text": "This entire UI is rendered from JSON.",
                  "fontSize": 14,
                  "color": "#757575"
                }
              }
            ]
          }
        ]
      },
      {
        "type": "row",
        "properties": {
          "mainAxisAlignment": "spaceEvenly",
          "margin": [0, 20, 0, 0]
        },
        "children": [
          {
            "type": "button",
            "properties": {
              "text": "Cancel",
                "color": "#1565C0"
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Cancel",
                  "color": "#FFFFFF"
                }
              }
            ],
            "actions": {
              "onTap": "showMessage",
              "message": "Cancel clicked!"
            }
          },
          {
            "type": "button",
            "properties": {
              "text": "Submit",
              "color": "#1565C0"
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Submit",
                  "color": "#FFFFFF"
                }
              }
            ],
            "actions": {
              "onTap": "showMessage",
              "message": "Submit clicked!"
            }
          }
        ]
      }
    ]
  }
  ''';

  // JSON for form example
  final String _formJson = '''
  {
    "type": "column",
    "children": [
      {
        "type": "text",
        "properties": {
          "text": "Login Form",
          "fontSize": 20,
          "fontWeight": "bold"
        }
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "color": "#FFFFFF",
          "margin": [0, 16, 0, 0]
        },
        "children": [
          {
            "type": "column",
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Email:",
                  "fontSize": 14
                }
              },
              {
                "type": "text",
                "properties": {
                  "text": "user@example.com",
                  "fontSize": 16,
                  "fontWeight": "bold"
                }
              },
              {
                "type": "text",
                "properties": {
                  "text": "Password:",
                  "fontSize": 14,
                  "margin": [0, 16, 0, 0]
                }
              },
              {
                "type": "text",
                "properties": {
                  "text": "••••••••",
                  "fontSize": 16,
                  "fontWeight": "bold"
                }
              }
            ]
          }
        ]
      }
    ]
  }
  ''';

  bool _showMainExample = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic UI Renderer Demo'),
        actions: [
          IconButton(
            icon: Icon(_showMainExample ? Icons.view_list : Icons.home),
            onPressed: () {
              setState(() {
                _showMainExample = !_showMainExample;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flutter_dash, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'dynamic_ui_renderer',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Version 0.0.1',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Rendered UI section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.brush, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Rendered UI:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: _showMainExample
                          ? DynamicUIRenderer.fromJsonString(_sampleJson)
                          : DynamicUIRenderer.fromJsonString(_formJson),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // JSON source section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.code, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'JSON Source:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _showMainExample ? _sampleJson : _formJson,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // How to use section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.help_outline, color: Colors.purple.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'How to Use:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '1. Add to pubspec.yaml:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: Colors.grey.shade300,
                            child: const Text(
                              'dependencies:\n  dynamic_ui_renderer: ^0.0.1',
                              style: TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '2. Import and use:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: Colors.grey.shade300,
                            child: const Text(
                              "import 'package:dynamic_ui_renderer/dynamic_ui_renderer.dart';\n\n"
                              "Widget myUI = DynamicUIRenderer.fromJsonString(jsonString);",
                              style: TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
