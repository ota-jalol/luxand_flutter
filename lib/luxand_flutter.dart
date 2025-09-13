import 'dart:async';
import 'package:flutter/services.dart';
import 'luxand_flutter_platform_interface.dart';

/// A Flutter plugin for Luxand SDK integration.
class LuxandFlutter {
  /// The method channel used to interact with the native platform.
  static const MethodChannel _channel = MethodChannel('luxand_flutter');

  /// Gets the platform version.
  /// 
  /// Returns a string containing the platform version.
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Initialize the Luxand SDK.
  /// 
  /// Returns true if initialization was successful, false otherwise.
  static Future<bool> initialize() async {
    final bool result = await _channel.invokeMethod('initialize') ?? false;
    return result;
  }

  /// Activate the Luxand SDK with a license key.
  /// 
  /// [licenseKey] The license key for the Luxand SDK.
  /// Returns true if activation was successful, false otherwise.
  static Future<bool> activate(String licenseKey) async {
    final bool result = await _channel.invokeMethod('activate', {
      'licenseKey': licenseKey,
    }) ?? false;
    return result;
  }

  /// Load a template from a file path.
  /// 
  /// [templatePath] Path to the template file.
  /// Returns the template ID if successful, -1 otherwise.
  static Future<int> loadTemplate(String templatePath) async {
    final int result = await _channel.invokeMethod('loadTemplate', {
      'templatePath': templatePath,
    }) ?? -1;
    return result;
  }

  /// Save a template to a file path.
  /// 
  /// [templateId] The template ID to save.
  /// [templatePath] Path where to save the template file.
  /// Returns true if successful, false otherwise.
  static Future<bool> saveTemplate(int templateId, String templatePath) async {
    final bool result = await _channel.invokeMethod('saveTemplate', {
      'templateId': templateId,
      'templatePath': templatePath,
    }) ?? false;
    return result;
  }

  /// Extract face template from image.
  /// 
  /// [imagePath] Path to the image file.
  /// Returns the template ID if successful, -1 otherwise.
  static Future<int> extractTemplate(String imagePath) async {
    final int result = await _channel.invokeMethod('extractTemplate', {
      'imagePath': imagePath,
    }) ?? -1;
    return result;
  }

  /// Compare two templates.
  /// 
  /// [template1] First template ID.
  /// [template2] Second template ID.
  /// Returns the similarity value (0.0 to 1.0), or -1.0 if error.
  static Future<double> compareTemplates(int template1, int template2) async {
    final double result = await _channel.invokeMethod('compareTemplates', {
      'template1': template1,
      'template2': template2,
    }) ?? -1.0;
    return result;
  }

  /// Free template from memory.
  /// 
  /// [templateId] The template ID to free.
  /// Returns true if successful, false otherwise.
  static Future<bool> freeTemplate(int templateId) async {
    final bool result = await _channel.invokeMethod('freeTemplate', {
      'templateId': templateId,
    }) ?? false;
    return result;
  }

  /// Finalize the Luxand SDK and cleanup resources.
  /// 
  /// Returns true if finalization was successful, false otherwise.
  static Future<bool> finalize() async {
    final bool result = await _channel.invokeMethod('finalize') ?? false;
    return result;
  }
}