# Changelog

## [0.2.0] - 2024-02-28 📝

### ✨ Major New Features - Forms & Validation System

#### Dynamic Forms
- **Complete Form Widget** - Full-featured form container with validation support
- **Multiple Field Types** - Text, Email, Password, Number, Phone, Dropdown, Checkbox, Date, Textarea, Radio
- **Form Controller** - Advanced state management with dirty/touched/submitting states
- **Multi-Form Support** - Register and handle multiple independent forms with unique IDs
- **Form Callbacks** - Global and per-form submission callbacks with form data

#### Validation System
- **Required Fields** - Mark any field as required with custom error messages
- **Email Validation** - Built-in email format validation
- **Min/Max Length** - Control text field character limits
- **Min/Max Value** - Numeric range validation for number fields
- **Pattern Matching** - Regex pattern validation with custom patterns
- **Field Matching** - Compare fields (e.g., password confirmation)
- **Phone Validation** - Phone number format validation
- **URL Validation** - URL format validation
- **Date Validation** - Date format validation (YYYY-MM-DD)
- **Real-time Validation** - Validate as users type with instant feedback

#### Form State Management
- **Touched State** - Track which fields have been interacted with
- **Dirty State** - Track if form has been modified
- **Error State** - Per-field error messages with automatic clearing
- **Submitting State** - Loading indicator during form submission
- **Conditional Visibility** - Show/hide fields based on other field values
- **Form Reset** - Complete form reset with all field types (text, checkbox, dropdown, date)

#### Enhanced Field Widgets
- **Text Field** - With prefix icons, custom styling, and validation
- **Email Field** - Email-specific keyboard and validation
- **Password Field** - Toggle password visibility, strength validation
- **Number Field** - Numeric keyboard with min/max validation
- **Phone Field** - Phone keyboard with format validation
- **Dropdown Field** - Custom options with icons and disabled states
- **Checkbox Field** - Required validation with custom colors
- **Date Field** - Date picker with custom format support
- **Textarea** - Multi-line text input with min/max lines

### 🏗️ Architecture
- Created `FormFieldConfig` model for type-safe field definitions
- Implemented `FormController` with comprehensive state management
- Added validation rule system with 12+ validation types
- Built modular field widgets for easy expansion
- Added form ID system for multiple form support
- Implemented form submission callbacks and listeners

### 📚 Documentation
- Added comprehensive form JSON schema documentation
- Created validation rule reference with examples
- Updated example app with multi-form demo section
- Added form submission guide with callback examples
- Documented all field types and their properties

### ✅ Testing
- Form field configuration tests
- Form controller unit tests
- Validation rule tests for all types
- Field widget rendering tests
- Form submission and reset tests
- Multi-form callback tests
- 95%+ code coverage

### 📱 Example App Enhancements
- **Multi-Form Demo Section** - Three independent forms in one screen
- **Registration Form** - Complete user registration with all field types
- **Contact Form** - Contact form with dropdown, textarea, and radio
- **Dynamic Layout Form** - Fields that rearrange based on order property
- **Real-time Data Display** - Shows submitted form data below each form
- **Toggle Layout Button** - Switch between different field orders dynamically
- **Color-coded Forms** - Each form has its own theme color

### 🔧 Technical Details
- Added `formId` parameter to `DynamicUIRenderer.fromJsonString`
- Implemented `registerFormCallback` for multi-form support
- Created `FormSubmitListener` type for form submission callbacks
- Added proper checkbox reset handling with controller listeners
- Fixed text field cursor jumping issues during typing
- Improved error message display timing and styling
- Added support for 3-digit and 4-digit hex colors

### 🐛 Bug Fixes
- Fixed checkbox not resetting after form submission
- Fixed text field cursor jumping on each keystroke
- Fixed dropdown not updating on external value changes
- Fixed date field not clearing on form reset
- Fixed validation errors showing before field interaction
- Fixed form data not being passed to callbacks
- Fixed multiple form callback interference

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