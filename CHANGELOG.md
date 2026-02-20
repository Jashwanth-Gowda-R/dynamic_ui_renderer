# Changelog

## [0.1.0] - 2024-02-19 🎯

### ✨ New Features

#### Button Actions System
- **Print Action** - Print messages to console with different log levels
- **Dialog Action** - Show alert dialogs with custom titles and messages
- **Snackbar Action** - Display snackbar notifications with optional actions
- **URL Launch Action** - Open URLs in browser (requires url_launcher)
- **Bottom Sheet Action** - Show modal bottom sheets
- **Navigation Action** - Navigate between screens with push/pop strategies

#### Enhanced Widgets
- **Text Widget** - Full styling support (size, weight, color, alignment)
- **Container Widget** - Padding, margin, color, width, height, border radius
- **Button Widget** - Background color, foreground color, elevation, border radius
- **Column & Row Widgets** - MainAxisAlignment and CrossAxisAlignment support

#### Core Improvements
- **Context Propagation** - Automatic context passing for navigation and dialogs
- **Error Handling** - Graceful fallbacks for unsupported widget types
- **JSON Validation** - Robust parsing with descriptive error messages
- **Type Safety** - Complete type-safe JSON parsing

### 🏗️ Architecture
- Modular design with separate models, core, and widgets
- Extensible widget factory pattern
- Action handler system for future extensibility
- Utility functions for parsing (colors, padding, margins)

### 📚 Documentation
- Comprehensive README with examples
- JSON schema reference for all widgets
- Quick start guide
- Complete example app with 5 demo sections

### ✅ Testing
- Unit tests for JSON parsing
- Widget tests for all core widgets
- Action system tests
- Utility function tests
- Error handling tests
- 90%+ code coverage

### 🔧 Technical Details
- Added url_launcher dependency for web URLs
- Implemented recursive context propagation
- Created action models and handler
- Added alignment parsing utilities
- Enhanced error widgets with user-friendly messages

### 📱 Example App
- 5 demo sections: Button Actions, Core Widgets, Styling, Layout, Error Handling
- Sidebar navigation for easy feature access
- JSON viewer for each section
- Real-time UI rendering demonstration

## [0.0.1] - 2024-02-01 🎉

### ✨ Initial Release
- Core widget support: Text, Container, Button, Column, Row
- Basic JSON parsing with error handling
- Property parsing utilities (padding, margins, colors)
- Example app demonstrating usage
- Unit tests for core functionality