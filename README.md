# Luxand Flutter

A Flutter plugin for integrating Luxand FaceSDK with Windows platform support.

## Features

- **Face Recognition**: Extract and compare face templates from images
- **Template Management**: Save and load face templates for persistent storage  
- **SDK Integration**: Full integration with Luxand FaceSDK for Windows
- **Memory Management**: Proper cleanup and resource management
- **Easy API**: Simple Dart interface for complex face recognition operations

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  luxand_flutter:
    git:
      url: https://github.com/ota-jalol/luxand_flutter.git
```

## Prerequisites

Before using this plugin, you need:

1. **Luxand FaceSDK**: Download and install from [Luxand website](https://www.luxand.com)
2. **Valid License Key**: Obtain a license key for the Luxand FaceSDK
3. **Windows Development Environment**: Visual Studio with C++ support

## Setup

### 1. Install Luxand FaceSDK

Download and install the Luxand FaceSDK for Windows from the official website.

### 2. Configure Native Dependencies

Update the Windows C++ implementation to include actual Luxand SDK headers and libraries:

1. Copy Luxand SDK headers to `windows/include/luxand/`
2. Update `windows/CMakeLists.txt` to link with Luxand libraries
3. Uncomment Luxand SDK function calls in `windows/luxand_flutter_plugin.cpp`

### 3. License Key

Replace the placeholder license key in your application with your actual Luxand license key.

## Usage

### Basic Example

```dart
import 'package:luxand_flutter/luxand_flutter.dart';

// Initialize the SDK
bool initialized = await LuxandFlutter.initialize();
if (!initialized) {
  print('Failed to initialize Luxand SDK');
  return;
}

// Activate with license key
bool activated = await LuxandFlutter.activate('YOUR_LICENSE_KEY');
if (!activated) {
  print('Failed to activate Luxand SDK');
  return;
}

// Extract face template from image
int templateId = await LuxandFlutter.extractTemplate('path/to/image.jpg');
if (templateId != -1) {
  print('Face template extracted successfully: $templateId');
  
  // Save template to file
  bool saved = await LuxandFlutter.saveTemplate(templateId, 'path/to/template.dat');
  if (saved) {
    print('Template saved successfully');
  }
  
  // Clean up template from memory
  await LuxandFlutter.freeTemplate(templateId);
}

// Finalize SDK when done
await LuxandFlutter.finalize();
```

### Face Comparison

```dart
// Extract templates from two images
int template1 = await LuxandFlutter.extractTemplate('image1.jpg');
int template2 = await LuxandFlutter.extractTemplate('image2.jpg');

if (template1 != -1 && template2 != -1) {
  // Compare the templates
  double similarity = await LuxandFlutter.compareTemplates(template1, template2);
  
  if (similarity > 0.7) {
    print('Faces match! Similarity: $similarity');
  } else {
    print('Faces do not match. Similarity: $similarity');
  }
  
  // Clean up
  await LuxandFlutter.freeTemplate(template1);
  await LuxandFlutter.freeTemplate(template2);
}
```

### Loading Existing Templates

```dart
// Load previously saved template
int templateId = await LuxandFlutter.loadTemplate('path/to/saved/template.dat');
if (templateId != -1) {
  print('Template loaded successfully: $templateId');
  
  // Use the template for comparison
  int newTemplate = await LuxandFlutter.extractTemplate('new_image.jpg');
  double similarity = await LuxandFlutter.compareTemplates(templateId, newTemplate);
  
  // Clean up
  await LuxandFlutter.freeTemplate(templateId);
  await LuxandFlutter.freeTemplate(newTemplate);
}
```

## API Reference

### Methods

#### `initialize()` → `Future<bool>`
Initialize the Luxand SDK. Must be called before any other operations.

#### `activate(String licenseKey)` → `Future<bool>`
Activate the SDK with a valid license key. Required after initialization.

#### `extractTemplate(String imagePath)` → `Future<int>`
Extract face template from an image file. Returns template ID or -1 if failed.

#### `loadTemplate(String templatePath)` → `Future<int>`
Load a previously saved template from file. Returns template ID or -1 if failed.

#### `saveTemplate(int templateId, String templatePath)` → `Future<bool>`
Save a template to a file for later use.

#### `compareTemplates(int template1, int template2)` → `Future<double>`
Compare two face templates. Returns similarity value (0.0 to 1.0) or -1.0 if error.

#### `freeTemplate(int templateId)` → `Future<bool>`
Free template from memory. Important for memory management.

#### `finalize()` → `Future<bool>`
Finalize the SDK and clean up all resources.

#### `platformVersion` → `Future<String?>`
Get the current platform version.

## Platform Support

| Platform | Support |
|----------|---------|
| Windows  | ✅      |
| Android  | ❌      |
| iOS      | ❌      |
| macOS    | ❌      |
| Linux    | ❌      |
| Web      | ❌      |

## Current Implementation Status

This plugin currently provides a **mock implementation** for development and testing purposes. To use with the actual Luxand FaceSDK:

1. Install the Luxand FaceSDK
2. Uncomment the Luxand SDK function calls in the Windows C++ implementation
3. Configure proper linking with Luxand libraries
4. Test with actual images and license keys

## Example App

A complete example application is included in the `example/` directory. Run it with:

```bash
cd example
flutter run -d windows
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This plugin is not affiliated with Luxand, Inc. You need to obtain proper licensing from Luxand to use their FaceSDK in production applications.