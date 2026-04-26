import 'package:example_dynamic_ui_renderer_app/details_screen.dart';
import 'package:example_dynamic_ui_renderer_app/second_screen.dart';
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

  // State for multi-form section
  Map<String, dynamic>? _registrationFormData;
  Map<String, dynamic>? _contactFormData;
  Map<String, dynamic>? _layoutFormData;
  bool _useAlternateOrder = false;

  // Network demo state
  String? _networkDemoScenario;
  int _networkDemoKey = 0;

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
      title: '📝 Multi-Form Demo',
      description: 'Multiple forms with real-time data display',
      isMultiForm: true,
    ),
    DemoSection(
      title: '🌐 Network Loading',
      description: 'Load UI dynamically from a URL (v0.3.0)',
      isNetworkDemo: true,
    ),
    DemoSection(
      title: '⚠️ Error Handling',
      description: 'Unsupported widget types',
      json: _buildErrorHandlingJson(),
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Register form callbacks
    DynamicUIRenderer.registerFormCallback('registration_form', (
      formId,
      formData,
    ) {
      debugPrint('📝 Registration Form Submitted: $formData');
      setState(() {
        _registrationFormData = formData;
      });
    });

    DynamicUIRenderer.registerFormCallback('contact_form', (formId, formData) {
      debugPrint('📧 Contact Form Submitted: $formData');
      setState(() {
        _contactFormData = formData;
      });
    });

    DynamicUIRenderer.registerFormCallback('dynamic_layout_form', (
      formId,
      formData,
    ) {
      debugPrint('🎨 Dynamic Layout Form Submitted: $formData');
      setState(() {
        _layoutFormData = formData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic UI Renderer v0.3.0'),
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
          if (_sections[_selectedIndex].json != null)
            IconButton(
              icon: const Icon(Icons.code),
              onPressed: () {
                _showJsonDialog(context, _sections[_selectedIndex].json!);
              },
              tooltip: 'View JSON',
            ),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar - Navigation
          _buildSidebar(),
          // Right Side - Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(),
                    _buildSectionContent(context),
                    const SizedBox(height: 24),
                    _buildFeatureStatus(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
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
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
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
              'All features working in v0.3.0',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
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
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context) {
    if (_sections[_selectedIndex].isMultiForm) {
      return _buildMultiFormContent(context);
    } else if (_sections[_selectedIndex].isNetworkDemo) {
      return _buildNetworkDemoContent(context);
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DynamicUIRenderer.fromJsonString(
          _sections[_selectedIndex].json!,
          context,
        ),
      );
    }
  }

  static const _rawJsonUrl =
      'https://raw.githubusercontent.com/Jashwanth-Gowda-R/dynamic_ui_renderer/master/example/assets/network_demo.json';
  static const _badUrl =
      'https://raw.githubusercontent.com/Jashwanth-Gowda-R/dynamic_ui_renderer/master/example/assets/notfound.json';

  Widget _buildNetworkDemoContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNetworkHeader(),
        const SizedBox(height: 20),
        _buildScenarioButtons(),
        const SizedBox(height: 14),
        _buildLiveResultPanel(context),
        const SizedBox(height: 24),
        _buildNetworkCodeSnippet(),
        const SizedBox(height: 16),
        _buildExceptionTable(),
      ],
    );
  }

  Widget _buildNetworkHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade800, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.cloud_download_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Network Demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Real HTTP requests to GitHub. Pick a scenario to see all 3 states in action.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioButtons() {
    return Row(
      children: [
        _scenarioButton(
          label: 'Load UI',
          icon: Icons.cloud_done_outlined,
          color: Colors.green,
          scenario: 'success',
        ),
        const SizedBox(width: 10),
        _scenarioButton(
          label: 'Simulate\nError',
          icon: Icons.error_outline_rounded,
          color: Colors.red,
          scenario: 'error',
        ),
        const SizedBox(width: 10),
        _scenarioButton(
          label: 'Simulate\nTimeout',
          icon: Icons.timer_off_outlined,
          color: Colors.orange,
          scenario: 'timeout',
        ),
      ],
    );
  }

  Widget _scenarioButton({
    required String label,
    required IconData icon,
    required MaterialColor color,
    required String scenario,
  }) {
    final isActive = _networkDemoScenario == scenario;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _networkDemoScenario = scenario;
          _networkDemoKey++;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? color : color.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? color.shade700 : color.shade200,
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : color.shade600,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : color.shade700,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveResultPanel(BuildContext context) {
    NetworkRequest? request;
    if (_networkDemoScenario == 'success') {
      request = const NetworkRequest(url: _rawJsonUrl, maxRetries: 1);
    } else if (_networkDemoScenario == 'error') {
      request = const NetworkRequest(url: _badUrl, maxRetries: 1);
    } else if (_networkDemoScenario == 'timeout') {
      request = NetworkRequest(
        url: _rawJsonUrl,
        timeout: const Duration(milliseconds: 1),
        maxRetries: 1,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'LIVE RESULT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: Colors.black45,
              ),
            ),
            if (_networkDemoScenario != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _scenarioColor().shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _scenarioLabel(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _scenarioColor().shade800,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(minHeight: 260),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          clipBehavior: Clip.hardEdge,
          child: request == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 44,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Tap a scenario above',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'A real HTTP request fires and you\'ll see\nloading → success / error states live.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : NetworkLoader(key: ValueKey(_networkDemoKey), request: request),
        ),
      ],
    );
  }

  MaterialColor _scenarioColor() {
    switch (_networkDemoScenario) {
      case 'success':
        return Colors.green;
      case 'error':
        return Colors.red;
      case 'timeout':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _scenarioLabel() {
    switch (_networkDemoScenario) {
      case 'success':
        return '✅  Load UI';
      case 'error':
        return '❌  Simulate Error';
      case 'timeout':
        return '⏱  Simulate Timeout';
      default:
        return '';
    }
  }

  Widget _buildNetworkCodeSnippet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'USAGE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.black45,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '// One line to load UI from a URL\n'
            "DynamicUIRenderer.fromNetwork(\n"
            "  'https://api.example.com/ui/home',\n"
            '  context,\n'
            ');',
            style: TextStyle(
              fontFamily: 'monospace',
              color: Colors.white70,
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExceptionTable() {
    final rows = [
      (
        Colors.blue,
        'TimeoutException',
        'Request exceeded the timeout duration',
      ),
      (Colors.red, 'NoInternetException', 'No network connectivity detected'),
      (Colors.orange, 'HttpException', 'Server returned a non-2xx status code'),
      (
        Colors.purple,
        'InvalidJsonException',
        'Response body is not valid JSON',
      ),
      (
        Colors.teal,
        'MaxRetriesExceededException',
        'All retry attempts exhausted',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TYPED EXCEPTIONS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Colors.black45,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: rows.asMap().entries.map((entry) {
              final i = entry.key;
              final (color, name, desc) = entry.value;
              final isFirst = i == 0;
              final isLast = i == rows.length - 1;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: i.isEven ? Colors.white : Colors.grey.shade50,
                  borderRadius: BorderRadius.vertical(
                    top: isFirst ? const Radius.circular(12) : Radius.zero,
                    bottom: isLast ? const Radius.circular(12) : Radius.zero,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 5,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 6,
                      child: Text(
                        desc,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureStatus() {
    return Container(
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
    );
  }

  // ============= MULTI-FORM SECTION =============
  Widget _buildMultiFormContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle Order Button for Dynamic Layout
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _useAlternateOrder = !_useAlternateOrder;
                    });
                  },
                  icon: Icon(
                    _useAlternateOrder ? Icons.swap_vert : Icons.swap_horiz,
                  ),
                  label: Text(
                    _useAlternateOrder
                        ? 'Switch to Default Order'
                        : 'Switch to Alternate Order',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Registration Form
        _buildFormCard(
          title: 'Form 1: User Registration',
          icon: Icons.app_registration,
          color: Colors.green,
          formJson: _buildRegistrationFormJson(),
          formId: 'registration_form',
          formData: _registrationFormData,
          context: context,
        ),

        // Contact Form
        _buildFormCard(
          title: 'Form 2: Contact Us',
          icon: Icons.contact_mail,
          color: Colors.blue,
          formJson: _buildContactFormJson(),
          formId: 'contact_form',
          formData: _contactFormData,
          context: context,
        ),

        // Dynamic Layout Form
        _buildFormCard(
          title: 'Form 3: Dynamic Layout',
          subtitle: _useAlternateOrder ? 'Alternate Order' : 'Default Order',
          icon: Icons.swap_vert,
          color: Colors.purple,
          formJson: _buildDynamicLayoutFormJson(),
          formId: 'dynamic_layout_form',
          formData: _layoutFormData,
          context: context,
        ),
      ],
    );
  }

  Widget _buildFormCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required MaterialColor color,
    required String formJson,
    required String formId,
    required Map<String, dynamic>? formData,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: color.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          DynamicUIRenderer.fromJsonString(formJson, context, formId: formId),
          if (formData != null) ...[
            const SizedBox(height: 16),
            _buildDataDisplayCard('Submitted Data', formData, color),
          ],
        ],
      ),
    );
  }

  Widget _buildDataDisplayCard(
    String title,
    Map<String, dynamic> data,
    MaterialColor color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: color.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...data.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      '${e.key}:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value?.toString() ?? 'null',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ),
                ],
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

  //   // ============= FORM JSON BUILDERS =============
  //   String _buildRegistrationFormJson() {
  //     return '''
  // {
  //   "type": "form",
  //   "properties": {
  //     "title": "Create Account",
  //     "titleFontSize": 16,
  //     "titleColor": "#4CAF50",
  //     "backgroundColor": "#FFFFFF",
  //     "padding": 16,
  //     "borderRadius": 8,
  //     "elevation": 2,
  //     "submitText": "Register",
  //     "submitButtonColor": "#4CAF50",
  //     "submitButtonTextColor": "#FFFFFF",
  //     "submitButtonRadius": 8,
  //     "submitButtonHeight": 44,
  //     "showValidationMessage": true
  //   },
  //   "fields": [
  //     {
  //       "name": "username",
  //       "type": "text",
  //       "label": "Username",
  //       "hint": "Choose a username",
  //       "required": true,
  //       "order": 1,
  //       "validations": [
  //         {
  //           "type": "minLength",
  //           "value": 3,
  //           "message": "Username must be at least 3 characters"
  //         }
  //       ]
  //     },
  //     {
  //       "name": "email",
  //       "type": "email",
  //       "label": "Email",
  //       "hint": "Enter your email",
  //       "required": true,
  //       "order": 2,
  //       "validations": [
  //         {
  //           "type": "email",
  //           "message": "Enter a valid email"
  //         }
  //       ]
  //     },
  //     {
  //       "name": "password",
  //       "type": "password",
  //       "label": "Password",
  //       "hint": "Create a password",
  //       "required": true,
  //       "order": 3,
  //       "validations": [
  //         {
  //           "type": "minLength",
  //           "value": 6,
  //           "message": "Password must be at least 6 characters"
  //         }
  //       ]
  //     },
  //     {
  //       "name": "newsletter",
  //       "type": "checkbox",
  //       "label": "Subscribe to newsletter",
  //       "order": 4
  //     }
  //   ],
  //   "actions": {
  //     "onSubmit": {
  //       "type": "print",
  //       "parameters": {
  //         "message": "Registration submitted"
  //       }
  //     }
  //   }
  // }
  // ''';
  //   }

  // ============= NEW: Forms JSON Builder =============
  static String _buildRegistrationFormJson() {
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
        "text": "📝 Dynamic Forms Demo",
        "fontSize": 20,
        "fontWeight": "bold",
        "color": "#1976D2"
      }
    },
    {
      "type": "text",
      "properties": {
        "text": "Complete form with validation and all field types",
        "fontSize": 14,
        "color": "#757575",
        "margin": [0, 8, 0, 16]
      }
    },
    {
      "type": "form",
      "properties": {
       "formId": "registration_form",
        "title": "📝 User Registration",
        "titleFontSize": 18,
        "titleColor": "#1976D2",
        "backgroundColor": "#FFFFFF",
        "padding": 20,
        "borderRadius": 12,
        "elevation": 4,
        "submitText": "Create Account",
        "submitButtonColor": "#4CAF50",
        "submitButtonTextColor": "#FFFFFF",
        "submitButtonRadius": 8,
        "submitButtonHeight": 48,
        "showValidationMessage": true,
        "validationMessage": "Please fix the errors and try again"
      },
      "fields": [
        {
          "name": "fullName",
          "type": "text",
          "label": "Full Name",
          "hint": "Enter your full name",
          "placeholder": "John Doe",
          "required": true,
          "requiredMessage": "Name is required",
          "order": 1,
          "validations": [
            {
              "type": "minLength",
              "value": 3,
              "message": "Name must be at least 3 characters"
            },
            {
              "type": "maxLength",
              "value": 50,
              "message": "Name cannot exceed 50 characters"
            }
          ],
          "uiProperties": {
            "borderRadius": 8,
            "filled": true,
            "fillColor": "#F5F5F5",
            "fontSize": 16,
            "prefixIcon": "person"
          }
        },
        {
          "name": "email",
          "type": "email",
          "label": "Email Address",
          "hint": "Enter your email",
          "placeholder": "john@example.com",
          "required": true,
          "requiredMessage": "Email is required",
          "order": 2,
          "validations": [
            {
              "type": "email",
              "message": "Please enter a valid email address"
            }
          ],
          "uiProperties": {
            "borderRadius": 8,
            "filled": true,
            "fillColor": "#F5F5F5",
            "prefixIcon": "email"
          }
        },
        {
          "name": "password",
          "type": "password",
          "label": "Password",
          "hint": "Create a strong password",
          "required": true,
          "requiredMessage": "Password is required",
          "order": 3,
          "validations": [
            {
              "type": "minLength",
              "value": 8,
              "message": "Password must be at least 8 characters"
            },
            {
              "type": "pattern",
              "pattern": "^[A-Za-z0-9.@!-]{8,}",
              "message": "Password must be at least 8 characters and can include letters, numbers, and special characters (. @ ! -)"
            }
          ],
          "uiProperties": {
            "borderRadius": 8,
            "filled": true,
            "fillColor": "#F5F5F5",
            "prefixIcon": "lock"
          }
        },
        {
          "name": "confirmPassword",
          "type": "password",
          "label": "Confirm Password",
          "hint": "Re-enter your password",
          "required": true,
          "requiredMessage": "Please confirm your password",
          "order": 4,
          "validations": [
            {
              "type": "match",
              "value": "password",
              "message": "Passwords do not match"
            }
          ],
          "uiProperties": {
            "borderRadius": 8,
            "filled": true,
            "fillColor": "#F5F5F5",
            "prefixIcon": "lock"
          }
        },
        {
          "name": "phone",
          "type": "phone",
          "label": "Phone Number",
          "hint": "Enter your phone number",
          "placeholder": "+1 234 567 8900",

          "order": 5,
          "validations": [
            {
              "type": "phone",
              "message": "Please enter a valid phone number"
            }
          ],
          "uiProperties": {
            "borderRadius": 8,
            "filled": true,
            "fillColor": "#F5F5F5",
            "prefixIcon": "phone"
          }
        },
        {
          "name": "age",
          "type": "number",
          "label": "Age",
          "hint": "Enter your age",
          "required": false,
          "order": 6,
          "validations": [
            {
              "type": "minValue",
              "value": 18,
              "message": "You must be at least 18 years old"
            },
            {
              "type": "maxValue",
              "value": 120,
              "message": "Please enter a valid age"
            }
          ],
          "uiProperties": {
            "borderRadius": 8,
            "filled": true,
            "fillColor": "#F5F5F5"
          }
        },
        {
          "name": "country",
          "type": "dropdown",
          "label": "Country",
          "hint": "Select your country",
          "required": true,
          "requiredMessage": "Please select a country",
          "order": 7,
          "options": [
            {
              "label": "United States",
              "value": "us",
              "icon": {"name": "home"}
            },
            {
              "label": "United Kingdom",
              "value": "uk",
              "icon": {"name": "home"}
            },
            {
              "label": "Canada",
              "value": "ca",
              "icon": {"name": "home"}
            },
            {
              "label": "Australia",
              "value": "au",
              "icon": {"name": "home"}
            },
            {
              "label": "India",
              "value": "in",
              "icon": {"name": "home"}
            }
          ],
          "uiProperties": {
            "borderRadius": 8,
            "filled": true,
            "fillColor": "#F5F5F5"
          }
        },
        {
          "name": "birthDate",
          "type": "date",
          "label": "Birth Date",
          "hint": "Select your birth date",
          "required": false,
          "order": 8,
          "uiProperties": {
            "borderRadius": 8,
            "filled": true,
            "fillColor": "#F5F5F5",
            "format": "dd/MM/yyyy",
            "iconColor": "#1976D2"
          }
        },
        {
          "name": "termsAccepted",
          "type": "checkbox",
          "label": "I accept the Terms and Conditions*",
          "required": true,
          "requiredMessage": "You must accept the terms to continue",
          "order": 9,
          "uiProperties": {
            "activeColor": "#4CAF50",
            "checkColor": "#FFFFFF"
          }
        }
      ],
      "actions": {
        "onSubmit": {
          "type": "showDialog",
          "parameters": {
            "title": "Registration Successful! 🎉",
            "message": "Your account has been created successfully.\\n\\nCheck the console for form data.",
            "buttonText": "OK"
          }
        }
      }
    },
    {
      "type": "container",
      "properties": {
        "padding": 16,
        "margin": [0, 24, 0, 0],
        "color": "#E3F2FD",
        "borderRadius": 8
      },
      "children": [
        {
          "type": "column",
          "children": [
            {
              "type": "text",
              "properties": {
                "text": "📋 Form Features Demonstrated:",
                "fontWeight": "bold",
                "color": "#1565C0"
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Text field with min/max length validation",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Email field with email format validation",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Password with pattern validation (letter + number)",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Password match validation",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Phone number validation",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Number field with min/max value validation",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Dropdown with options",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Date picker with custom format",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Checkbox with required validation",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Real-time validation",
                "color": "#1565C0",
                "fontSize": 13
              }
            },
            {
              "type": "text",
              "properties": {
                "text": "• Error messages below fields",
                "color": "#1565C0",
                "fontSize": 13
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

  String _buildContactFormJson() {
    return '''
{
  "type": "form",
  "properties": {
    "title": "Get in Touch",
    "titleFontSize": 16,
    "titleColor": "#2196F3",
    "backgroundColor": "#FFFFFF",
    "padding": 16,
    "borderRadius": 8,
    "elevation": 2,
    "submitText": "Send Message",
    "submitButtonColor": "#2196F3",
    "submitButtonTextColor": "#FFFFFF",
    "submitButtonRadius": 8,
    "submitButtonHeight": 44,
    "showValidationMessage": true
  },
  "fields": [
    {
      "name": "name",
      "type": "text",
      "label": "Your Name",
      "hint": "Enter your full name",
      "required": true,
      "order": 1,
      "uiProperties": {
        "prefixIcon": "person"
      }
    },
    {
      "name": "email",
      "type": "email",
      "label": "Email",
      "hint": "Enter your email",
      "required": true,
      "order": 2,
      "uiProperties": {
        "prefixIcon": "email"
      }
    },
    {
      "name": "subject",
      "type": "dropdown",
      "label": "Subject",
      "required": true,
      "order": 3,
      "options": [
        {"label": "General Inquiry", "value": "general"},
        {"label": "Technical Support", "value": "support"},
        {"label": "Feedback", "value": "feedback"},
        {"label": "Business", "value": "business"}
      ]
    },
    {
      "name": "message",
      "type": "textarea",
      "label": "Message",
      "hint": "Type your message here",
      "required": true,
      "order": 4,
      "uiProperties": {
        "minLines": 3,
        "maxLines": 5
      }
    },
    {
      "name": "priority",
      "type": "radio",
      "label": "Priority",
      "order": 5,
      "options": [
        {"label": "Low", "value": "low"},
        {"label": "Medium", "value": "medium"},
        {"label": "High", "value": "high"}
      ]
    }
  ],
  "actions": {
    "onSubmit": {
      "type": "print",
      "parameters": {
        "message": "Contact form submitted"
      }
    }
  }
}
''';
  }

  String _buildDynamicLayoutFormJson() {
    if (_useAlternateOrder) {
      return '''
{
  "type": "form",
  "properties": {
    "title": "Dynamic Layout (Alternate Order)",
    "titleFontSize": 16,
    "titleColor": "#9C27B0",
    "backgroundColor": "#FFFFFF",
    "padding": 16,
    "borderRadius": 8,
    "elevation": 2,
    "submitText": "Submit",
    "submitButtonColor": "#9C27B0",
    "submitButtonTextColor": "#FFFFFF",
    "submitButtonRadius": 8,
    "submitButtonHeight": 44,
    "showValidationMessage": true
  },
  "fields": [
    {
      "name": "feedback",
      "type": "textarea",
      "label": "Your Feedback",
      "hint": "Tell us what you think",
      "required": true,
      "order": 4,
      "uiProperties": {
        "minLines": 2,
        "maxLines": 4
      }
    },
    {
      "name": "country",
      "type": "dropdown",
      "label": "Country",
      "required": true,
      "order": 2,
      "options": [
        {"label": "USA", "value": "us"},
        {"label": "UK", "value": "uk"},
        {"label": "Canada", "value": "ca"},
        {"label": "Australia", "value": "au"}
      ]
    },
    {
      "name": "rating",
      "type": "dropdown",
      "label": "Rating",
      "required": true,
      "order": 3,
      "options": [
        {"label": "⭐⭐⭐⭐⭐ Excellent", "value": "5"},
        {"label": "⭐⭐⭐⭐ Very Good", "value": "4"},
        {"label": "⭐⭐⭐ Good", "value": "3"},
        {"label": "⭐⭐ Fair", "value": "2"},
        {"label": "⭐ Poor", "value": "1"}
      ]
    },
    {
      "name": "fullName",
      "type": "text",
      "label": "Full Name",
      "hint": "Enter your name",
      "required": true,
      "order": 1
    },
    {
      "name": "subscribe",
      "type": "checkbox",
      "label": "Subscribe to updates",
      "order": 5
    }
  ],
  "actions": {
    "onSubmit": {
      "type": "print",
      "parameters": {
        "message": "Dynamic layout form submitted"
      }
    }
  }
}
''';
    } else {
      return '''
{
  "type": "form",
  "properties": {
    "title": "Dynamic Layout (Default Order)",
    "titleFontSize": 16,
    "titleColor": "#9C27B0",
    "backgroundColor": "#FFFFFF",
    "padding": 16,
    "borderRadius": 8,
    "elevation": 2,
    "submitText": "Submit",
    "submitButtonColor": "#9C27B0",
    "submitButtonTextColor": "#FFFFFF",
    "submitButtonRadius": 8,
    "submitButtonHeight": 44,
    "showValidationMessage": true
  },
  "fields": [
    {
      "name": "fullName",
      "type": "text",
      "label": "Full Name",
      "hint": "Enter your name",
      "required": true,
      "order": 1
    },
    {
      "name": "country",
      "type": "dropdown",
      "label": "Country",
      "required": true,
      "order": 2,
      "options": [
        {"label": "USA", "value": "us"},
        {"label": "UK", "value": "uk"},
        {"label": "Canada", "value": "ca"},
        {"label": "Australia", "value": "au"}
      ]
    },
    {
      "name": "rating",
      "type": "dropdown",
      "label": "Rating",
      "required": true,
      "order": 3,
      "options": [
        {"label": "⭐⭐⭐⭐⭐ Excellent", "value": "5"},
        {"label": "⭐⭐⭐⭐ Very Good", "value": "4"},
        {"label": "⭐⭐⭐ Good", "value": "3"},
        {"label": "⭐⭐ Fair", "value": "2"},
        {"label": "⭐ Poor", "value": "1"}
      ]
    },
    {
      "name": "feedback",
      "type": "textarea",
      "label": "Your Feedback",
      "hint": "Tell us what you think",
      "required": true,
      "order": 4,
      "uiProperties": {
        "minLines": 2,
        "maxLines": 4
      }
    },
    {
      "name": "subscribe",
      "type": "checkbox",
      "label": "Subscribe to updates",
      "order": 5
    }
  ],
  "actions": {
    "onSubmit": {
      "type": "print",
      "parameters": {
        "message": "Dynamic layout form submitted"
      }
    }
  }
}
''';
    }
  }

  // ============= EXISTING JSON BUILDERS =============
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
  final String? json;
  final bool isMultiForm;
  final bool isNetworkDemo;

  DemoSection({
    required this.title,
    required this.description,
    this.json,
    this.isMultiForm = false,
    this.isNetworkDemo = false,
  });
}
