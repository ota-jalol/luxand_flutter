import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that platform-specific implementations of luxand_flutter must implement.
///
/// When a class implements this interface, it must implement all the methods
/// defined in this interface.
abstract class LuxandFlutterPlatform extends PlatformInterface {
  /// Constructs a LuxandFlutterPlatform.
  LuxandFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static LuxandFlutterPlatform _instance = LuxandFlutterMethodChannel();

  /// The default instance of [LuxandFlutterPlatform] to use.
  static LuxandFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LuxandFlutterPlatform] when
  /// they register themselves.
  static set instance(LuxandFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Gets the platform version.
  Future<String?> getPlatformVersion();

  /// Initialize the Luxand SDK.
  Future<bool> initialize();

  /// Activate the Luxand SDK with a license key.
  Future<bool> activate(String licenseKey);

  /// Load a template from a file path.
  Future<int> loadTemplate(String templatePath);

  /// Save a template to a file path.
  Future<bool> saveTemplate(int templateId, String templatePath);

  /// Extract face template from image.
  Future<int> extractTemplate(String imagePath);

  /// Compare two templates.
  Future<double> compareTemplates(int template1, int template2);

  /// Free template from memory.
  Future<bool> freeTemplate(int templateId);

  /// Finalize the Luxand SDK and cleanup resources.
  Future<bool> finalize();
}

import 'package:flutter/services.dart';

/// An implementation of [LuxandFlutterPlatform] that uses method channels.
class LuxandFlutterMethodChannel extends LuxandFlutterPlatform {
  /// The method channel used to interact with the native platform.
  static const MethodChannel _methodChannel = MethodChannel('luxand_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final String? version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initialize() async {
    final bool result = await _methodChannel.invokeMethod<bool>('initialize') ?? false;
    return result;
  }

  @override
  Future<bool> activate(String licenseKey) async {
    final bool result = await _methodChannel.invokeMethod<bool>('activate', {
      'licenseKey': licenseKey,
    }) ?? false;
    return result;
  }

  @override
  Future<int> loadTemplate(String templatePath) async {
    final int result = await _methodChannel.invokeMethod<int>('loadTemplate', {
      'templatePath': templatePath,
    }) ?? -1;
    return result;
  }

  @override
  Future<bool> saveTemplate(int templateId, String templatePath) async {
    final bool result = await _methodChannel.invokeMethod<bool>('saveTemplate', {
      'templateId': templateId,
      'templatePath': templatePath,
    }) ?? false;
    return result;
  }

  @override
  Future<int> extractTemplate(String imagePath) async {
    final int result = await _methodChannel.invokeMethod<int>('extractTemplate', {
      'imagePath': imagePath,
    }) ?? -1;
    return result;
  }

  @override
  Future<double> compareTemplates(int template1, int template2) async {
    final double result = await _methodChannel.invokeMethod<double>('compareTemplates', {
      'template1': template1,
      'template2': template2,
    }) ?? -1.0;
    return result;
  }

  @override
  Future<bool> freeTemplate(int templateId) async {
    final bool result = await _methodChannel.invokeMethod<bool>('freeTemplate', {
      'templateId': templateId,
    }) ?? false;
    return result;
  }

  @override
  Future<bool> finalize() async {
    final bool result = await _methodChannel.invokeMethod<bool>('finalize') ?? false;
    return result;
  }
}