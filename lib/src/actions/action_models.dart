/// Types of actions that can be performed
enum ActionType {
  /// Navigate to a new screen
  navigate,
  
  /// Show a dialog
  showDialog,
  
  /// Show a bottom sheet
  showBottomSheet,
  
  /// Show a snackbar
  showSnackbar,
  
  /// Print to console (for debugging)
  print,
  
  /// Open a URL in browser
  launchUrl,
  
  /// Call a custom function
  custom,
}

/// Model for handling button actions
class ButtonAction {
  final ActionType type;
  final Map<String, dynamic> parameters;
  final Function? customCallback;

  ButtonAction({
    required this.type,
    this.parameters = const {},
    this.customCallback,
  });

  /// Creates a ButtonAction from JSON
  factory ButtonAction.fromJson(Map<String, dynamic> json) {
    return ButtonAction(
      type: _parseActionType(json['type']),
      parameters: json['parameters'] as Map<String, dynamic>? ?? {},
    );
  }

  static ActionType _parseActionType(String? type) {
    if (type == null) return ActionType.print;
    
    switch (type.toLowerCase()) {
      case 'navigate':
        return ActionType.navigate;
      case 'showdialog':
        return ActionType.showDialog;
      case 'showbottomsheet':
        return ActionType.showBottomSheet;
      case 'showsnackbar':
        return ActionType.showSnackbar;
      case 'launchurl':
        return ActionType.launchUrl;
      case 'custom':
        return ActionType.custom;
      default:
        return ActionType.print;
    }
  }
}