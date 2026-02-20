import 'package:dynamic_ui_renderer/dynamic_ui_renderer.dart';
import 'package:example_dynamic_ui_renderer_app/details_screen.dart';
import 'package:example_dynamic_ui_renderer_app/second_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic UI Renderer - Complete Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
      routes: {
        '/second': (context) => const SecondScreen(),
        '/details': (context) => const DetailsScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<DemoSection> _sections = [
    DemoSection(
      title: '🎯 Button Actions',
      description: 'Test all button action types',
      json: _buildButtonActionsJson(),
    ),
    DemoSection(
      title: '📱 Core Widgets',
      description: 'Basic widgets: Text, Container, Button, Column, Row',
      json: _buildCoreWidgetsJson(),
    ),
    DemoSection(
      title: '🎨 Styling Properties',
      description: 'Colors, padding, margins, font styles',
      json: _buildStylingJson(),
    ),
    DemoSection(
      title: '📐 Layout Examples',
      description: 'Different alignments and arrangements',
      json: _buildLayoutJson(),
    ),
    DemoSection(
      title: '⚠️ Error Handling',
      description: 'Unsupported widget types',
      json: _buildErrorHandlingJson(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic UI Renderer v0.1.0'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Refresh to rebuild UI
            },
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: () {
              _showJsonDialog(context, _sections[_selectedIndex].json);
            },
            tooltip: 'View JSON',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar - Navigation
          Container(
            width: 280,
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📦 dynamic_ui_renderer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Complete Feature Demo',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedIndex == index;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected ? Colors.blue.shade50 : null,
                        ),
                        child: ListTile(
                          leading: Text(
                            _sections[index].title.split(' ')[0],
                            style: TextStyle(
                              fontSize: 20,
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                          ),
                          title: Text(
                            _sections[index].title,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.blue : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            _sections[index].description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.blue.shade300
                                  : Colors.grey.shade600,
                            ),
                          ),
                          selected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '✓',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'All features working in v0.1.0',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right Side - Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _sections[_selectedIndex].title.split(' ')[0],
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _sections[_selectedIndex].title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _sections[_selectedIndex].description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Rendered UI from JSON
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DynamicUIRenderer.fromJsonString(
                        _sections[_selectedIndex].json,
                        context,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Feature Status
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This section demonstrates ${_sections[_selectedIndex].description.toLowerCase()}. '
                              'All widgets are rendered dynamically from JSON.',
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showJsonDialog(BuildContext context, String json) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.code, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'JSON Source',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    json,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============= JSON BUILDERS =============

  static String _buildButtonActionsJson() {
    return '''
  {
    "type": "column",
    "properties": {
      "crossAxisAlignment": "stretch"
    },
    "children": [
      {
        "type": "text",
        "properties": {
          "text": "🎯 Button Actions",
          "fontSize": 20,
          "fontWeight": "bold",
          "color": "#1976D2"
        }
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "margin": [0, 16, 0, 0],
          "color": "#FFFFFF",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "column",
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Print Action",
                  "fontSize": 16,
                  "fontWeight": "bold"
                }
              },
              {
                "type": "button",
                "properties": {
                  "text": "Print to Console",
                  "backgroundColor": "#4CAF50",
                  "foregroundColor": "#FFFFFF",
                  "borderRadius": 8
                },
                "actions": {
                  "type": "print",
                  "parameters": {
                    "message": "Hello from dynamic button!",
                    "level": "info"
                  }
                }
              }
            ]
          }
        ]
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "margin": [0, 8, 0, 0],
          "color": "#FFFFFF",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "column",
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Dialog Action",
                  "fontSize": 16,
                  "fontWeight": "bold"
                }
              },
              {
                "type": "button",
                "properties": {
                  "text": "Show Dialog",
                  "backgroundColor": "#FF9800",
                  "foregroundColor": "#FFFFFF",
                  "borderRadius": 8
                },
                "actions": {
                  "type": "showDialog",
                  "parameters": {
                    "title": "Welcome!",
                    "message": "This dialog was created dynamically from JSON.",
                    "buttonText": "Got it"
                  }
                }
              }
            ]
          }
        ]
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "margin": [0, 8, 0, 0],
          "color": "#FFFFFF",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "column",
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Snackbar Action",
                  "fontSize": 16,
                  "fontWeight": "bold"
                }
              },
              {
                "type": "button",
                "properties": {
                  "text": "Show Snackbar",
                  "backgroundColor": "#2196F3",
                  "foregroundColor": "#FFFFFF",
                  "borderRadius": 8
                },
                "actions": {
                  "type": "showSnackbar",
                  "parameters": {
                    "message": "This is a snackbar message!",
                    "duration": 3,
                    "actionLabel": "UNDO"
                  }
                }
              }
            ]
          }
        ]
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "margin": [0, 8, 0, 0],
          "color": "#FFFFFF",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "column",
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "URL Launch Action",
                  "fontSize": 16,
                  "fontWeight": "bold"
                }
              },
              {
                "type": "button",
                "properties": {
                  "text": "Open Flutter Website",
                  "backgroundColor": "#9C27B0",
                  "foregroundColor": "#FFFFFF",
                  "borderRadius": 8
                },
                "actions": {
                  "type": "launchUrl",
                  "parameters": {
                    "url": "https://flutter.dev",
                    "mode": "external"
                  }
                }
              }
            ]
          }
        ]
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "margin": [0, 8, 0, 0],
          "color": "#FFFFFF",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "column",
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Bottom Sheet Action",
                  "fontSize": 16,
                  "fontWeight": "bold"
                }
              },
              {
                "type": "button",
                "properties": {
                  "text": "Show Bottom Sheet",
                  "backgroundColor": "#E91E63",
                  "foregroundColor": "#FFFFFF",
                  "borderRadius": 8
                },
                "actions": {
                  "type": "showBottomSheet",
                  "parameters": {
                    "title": "Dynamic Bottom Sheet",
                    "message": "This bottom sheet was created from JSON!",
                    "buttonText": "Close"
                  }
                }
              }
            ]
          }
        ]
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "margin": [0, 8, 0, 0],
          "color": "#FFFFFF",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "column",
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Navigation Action",
                  "fontSize": 16,
                  "fontWeight": "bold"
                }
              },
              {
                "type": "button",
                "properties": {
                  "text": "Go to Second Screen",
                  "backgroundColor": "#3F51B5",
                  "foregroundColor": "#FFFFFF",
                  "borderRadius": 8
                },
                "actions": {
                  "type": "navigate",
                  "parameters": {
                    "route": "/second",
                    "type": "push",
                    "arguments": {
                      "message": "From Dynamic Button!"
                    }
                  }
                }
              },
              {
              "type": "container",
                "properties": {
                  "padding": 16,
                  "margin": [0, 8, 0, 0],
                  "color": "#FFFFFF",
                  "borderRadius": 8
                }
              },
              {
                "type": "button",
                "properties": {
                  "text": "Go to Details Screen",
                  "backgroundColor": "#3F51B5",
                  "foregroundColor": "#FFFFFF",
                  "borderRadius": 8
                },
                "actions": {
                  "type": "navigate",
                  "parameters": {
                    "route": "/details",
                    "type": "push",
                    "arguments": {
                      "message": "From Dynamic Button!"
                    }
                  }
                }
              }
            ]
          }
        ]
      }
    ]
  }
  ''';
  }

  static String _buildCoreWidgetsJson() {
    return '''
  {
    "type": "column",
    "properties": {
      "crossAxisAlignment": "stretch"
    },
    "children": [
      {
        "type": "text",
        "properties": {
          "text": "📱 Core Widgets",
          "fontSize": 20,
          "fontWeight": "bold",
          "color": "#1976D2"
        }
      },
      {
        "type": "text",
        "properties": {
          "text": "This is a Text widget rendered from JSON",
          "fontSize": 14,
          "color": "#757575"
        }
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "margin": [0, 16, 0, 0],
          "color": "#E3F2FD",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "text",
            "properties": {
              "text": "This is a Container with Text inside",
              "color": "#1565C0"
            }
          }
        ]
      },
      {
        "type": "button",
        "properties": {
          "text": "Click Me - I'm a Button",
          "backgroundColor": "#4CAF50",
          "foregroundColor": "#FFFFFF",
          "borderRadius": 8,
          "margin": [0, 16, 0, 0]
        },
        "actions": {
          "type": "print",
          "parameters": {
            "message": "Button clicked!",
            "level": "info"
          }
        }
      },
      {
        "type": "row",
        "properties": {
          "mainAxisAlignment": "spaceEvenly",
          "margin": [0, 16, 0, 0]
        },
        "children": [
          {
            "type": "container",
            "properties": {
              "padding": 12,
              "color": "#FF5252",
              "borderRadius": 4
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Left",
                  "color": "#FFFFFF"
                }
              }
            ]
          },
          {
            "type": "container",
            "properties": {
              "padding": 12,
              "color": "#4CAF50",
              "borderRadius": 4
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Center",
                  "color": "#FFFFFF"
                }
              }
            ]
          },
          {
            "type": "container",
            "properties": {
              "padding": 12,
              "color": "#2196F3",
              "borderRadius": 4
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Right",
                  "color": "#FFFFFF"
                }
              }
            ]
          }
        ]
      }
    ]
  }
  ''';
  }

  static String _buildStylingJson() {
    return '''
  {
    "type": "column",
    "properties": {
      "crossAxisAlignment": "stretch"
    },
    "children": [
      {
        "type": "text",
        "properties": {
          "text": "🎨 Styling Properties",
          "fontSize": 20,
          "fontWeight": "bold",
          "color": "#1976D2"
        }
      },
      {
        "type": "text",
        "properties": {
          "text": "Font Sizes",
          "fontSize": 16,
          "fontWeight": "bold",
          "margin": [0, 16, 0, 4]
        }
      },
      {
        "type": "row",
        "properties": {
          "mainAxisAlignment": "spaceEvenly"
        },
        "children": [
          {
            "type": "text",
            "properties": {
              "text": "Small",
              "fontSize": 12
            }
          },
          {
            "type": "text",
            "properties": {
              "text": "Medium",
              "fontSize": 16
            }
          },
          {
            "type": "text",
            "properties": {
              "text": "Large",
              "fontSize": 20
            }
          }
        ]
      },
      {
        "type": "text",
        "properties": {
          "text": "Font Weights",
          "fontSize": 16,
          "fontWeight": "bold",
          "margin": [0, 16, 0, 4]
        }
      },
      {
        "type": "column",
        "children": [
          {
            "type": "text",
            "properties": {
              "text": "Normal weight",
              "fontWeight": "normal"
            }
          },
          {
            "type": "text",
            "properties": {
              "text": "Bold weight",
              "fontWeight": "bold"
            }
          },
          {
            "type": "text",
            "properties": {
              "text": "W500 weight",
              "fontWeight": "w500"
            }
          }
        ]
      },
      {
        "type": "text",
        "properties": {
          "text": "Colors",
          "fontSize": 16,
          "fontWeight": "bold",
          "margin": [0, 16, 0, 4]
        }
      },
      {
        "type": "row",
        "properties": {
          "mainAxisAlignment": "spaceEvenly"
        },
        "children": [
          {
            "type": "container",
            "properties": {
              "padding": 12,
              "color": "#FF5252",
              "borderRadius": 8
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Red",
                  "color": "#FFFFFF"
                }
              }
            ]
          },
          {
            "type": "container",
            "properties": {
              "padding": 12,
              "color": "#4CAF50",
              "borderRadius": 8
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Green",
                  "color": "#FFFFFF"
                }
              }
            ]
          },
          {
            "type": "container",
            "properties": {
              "padding": 12,
              "color": "#2196F3",
              "borderRadius": 8
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Blue",
                  "color": "#FFFFFF"
                }
              }
            ]
          }
        ]
      },
      {
        "type": "text",
        "properties": {
          "text": "Padding & Margin",
          "fontSize": 16,
          "fontWeight": "bold",
          "margin": [0, 16, 0, 4]
        }
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "color": "#E0E0E0",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "container",
            "properties": {
              "padding": [8, 4, 8, 4],
              "color": "#2196F3",
              "borderRadius": 4
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Container with 16 padding",
                  "color": "#FFFFFF"
                }
              }
            ]
          }
        ]
      }
    ]
  }
  ''';
  }

  static String _buildLayoutJson() {
    return '''
  {
    "type": "column",
    "properties": {
      "crossAxisAlignment": "stretch"
    },
    "children": [
      {
        "type": "text",
        "properties": {
          "text": "📐 Layout Examples",
          "fontSize": 20,
          "fontWeight": "bold",
          "color": "#1976D2"
        }
      },
      {
        "type": "text",
        "properties": {
          "text": "Column with different alignments",
          "fontSize": 16,
          "fontWeight": "bold",
          "margin": [0, 16, 0, 8]
        }
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "color": "#F5F5F5",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "column",
            "properties": {
              "crossAxisAlignment": "start"
            },
            "children": [
              {
                "type": "container",
                "properties": {
                  "padding": 8,
                  "color": "#FF5252",
                  "borderRadius": 4
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "text": "Start",
                      "color": "#FFFFFF"
                    }
                  }
                ]
              },
              {
                "type": "container",
                "properties": {
                  "padding": 8,
                  "color": "#4CAF50",
                  "borderRadius": 4
                },
                "children": [
                  {
                    "type": "text",
                    "properties": {
                      "text": "Center",
                      "color": "#FFFFFF"
                    }
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "type": "text",
        "properties": {
          "text": "Row with space between",
          "fontSize": 16,
          "fontWeight": "bold",
          "margin": [0, 16, 0, 8]
        }
      },
      {
        "type": "row",
        "properties": {
          "mainAxisAlignment": "spaceBetween"
        },
        "children": [
          {
            "type": "container",
            "properties": {
              "padding": 12,
              "color": "#2196F3",
              "borderRadius": 4
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Left",
                  "color": "#FFFFFF"
                }
              }
            ]
          },
          {
            "type": "container",
            "properties": {
              "padding": 12,
              "color": "#9C27B0",
              "borderRadius": 4
            },
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Right",
                  "color": "#FFFFFF"
                }
              }
            ]
          }
        ]
      },
      {
        "type": "text",
        "properties": {
          "text": "Nested Layouts",
          "fontSize": 16,
          "fontWeight": "bold",
          "margin": [0, 16, 0, 8]
        }
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "color": "#FFE0B2",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "column",
            "children": [
              {
                "type": "text",
                "properties": {
                  "text": "Parent Container",
                  "fontWeight": "bold"
                }
              },
              {
                "type": "row",
                "properties": {
                  "mainAxisAlignment": "spaceEvenly",
                  "margin": [0, 8, 0, 0]
                },
                "children": [
                  {
                    "type": "container",
                    "properties": {
                      "padding": 8,
                      "color": "#FF7043",
                      "borderRadius": 4
                    },
                    "children": [
                      {
                        "type": "text",
                        "properties": {
                          "text": "Child 1",
                          "color": "#FFFFFF"
                        }
                      }
                    ]
                  },
                  {
                    "type": "container",
                    "properties": {
                      "padding": 8,
                      "color": "#7E57C2",
                      "borderRadius": 4
                    },
                    "children": [
                      {
                        "type": "text",
                        "properties": {
                          "text": "Child 2",
                          "color": "#FFFFFF"
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
    ]
  }
  ''';
  }

  static String _buildErrorHandlingJson() {
    return '''
  {
    "type": "column",
    "properties": {
      "crossAxisAlignment": "stretch"
    },
    "children": [
      {
        "type": "text",
        "properties": {
          "text": "⚠️ Error Handling",
          "fontSize": 20,
          "fontWeight": "bold",
          "color": "#F44336"
        }
      },
      {
        "type": "text",
        "properties": {
          "text": "Supported widgets work normally:",
          "margin": [0, 16, 0, 8]
        }
      },
      {
        "type": "button",
        "properties": {
          "text": "Working Button",
          "backgroundColor": "#4CAF50",
          "foregroundColor": "#FFFFFF"
        },
        "actions": {
          "type": "print",
          "parameters": {
            "message": "This button works!"
          }
        }
      },
      {
        "type": "text",
        "properties": {
          "text": "Unsupported widget shows fallback:",
          "margin": [0, 16, 0, 8]
        }
      },
      {
        "type": "unsupportedWidget",
        "properties": {
          "text": "This will not render"
        }
      },
      {
        "type": "anotherUnsupported",
        "properties": {
          "text": "This will also show error"
        }
      },
      {
        "type": "text",
        "properties": {
          "text": "Invalid JSON handling:",
          "margin": [0, 16, 0, 8]
        }
      },
      {
        "type": "container",
        "properties": {
          "padding": 16,
          "color": "#FFCDD2",
          "borderRadius": 8
        },
        "children": [
          {
            "type": "text",
            "properties": {
              "text": "If you pass invalid JSON, the package shows a friendly error message",
              "color": "#B71C1C"
            }
          }
        ]
      }
    ]
  }
  ''';
  }
}

class DemoSection {
  final String title;
  final String description;
  final String json;

  DemoSection({
    required this.title,
    required this.description,
    required this.json,
  });
}
