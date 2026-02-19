/// Represents a UI component parsed from JSON
/// This is the core data structure that represents any UI element
class UIComponent {
  final String type; // e.g., 'text', 'button', 'container'
  final Map<String, dynamic> properties; // Styling, text, etc.
  final List<UIComponent> children; // Nested components
  final Map<String, dynamic> actions; // What happens on interaction

  UIComponent({
    required this.type,
    this.properties = const {},
    this.children = const [],
    this.actions = const {},
  });

  /// Creates a UIComponent from JSON
  /// This is where JSON becomes a Dart object
  factory UIComponent.fromJson(Map<String, dynamic> json) {
    return UIComponent(
      type: json['type'] as String,
      properties: json['properties'] as Map<String, dynamic>? ?? {},
      children:
          (json['children'] as List?)
              ?.map((c) => UIComponent.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      actions: json['actions'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts component back to JSON (useful for debugging)
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'properties': properties,
      'children': children.map((c) => c.toJson()).toList(),
      'actions': actions,
    };
  }
}
