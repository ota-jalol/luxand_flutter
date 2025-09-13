import 'package:flutter_test/flutter_test.dart';
import 'package:luxand_flutter/luxand_flutter.dart';
import 'package:luxand_flutter/luxand_flutter_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLuxandFlutterPlatform
    with MockPlatformInterfaceMixin
    implements LuxandFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('Test Platform Version');

  @override
  Future<bool> initialize() => Future.value(true);

  @override
  Future<bool> activate(String licenseKey) => Future.value(true);

  @override
  Future<int> loadTemplate(String templatePath) => Future.value(1);

  @override
  Future<bool> saveTemplate(int templateId, String templatePath) => Future.value(true);

  @override
  Future<int> extractTemplate(String imagePath) => Future.value(1);

  @override
  Future<double> compareTemplates(int template1, int template2) => Future.value(0.85);

  @override
  Future<bool> freeTemplate(int templateId) => Future.value(true);

  @override
  Future<bool> finalize() => Future.value(true);
}

void main() {
  final LuxandFlutterPlatform initialPlatform = LuxandFlutterPlatform.instance;

  test('$LuxandFlutterMethodChannel is the default instance', () {
    expect(initialPlatform, isInstanceOf<LuxandFlutterMethodChannel>());
  });

  test('getPlatformVersion', () async {
    MockLuxandFlutterPlatform fakePlatform = MockLuxandFlutterPlatform();
    LuxandFlutterPlatform.instance = fakePlatform;

    expect(await LuxandFlutter.platformVersion, 'Test Platform Version');
  });

  test('initialize returns true', () async {
    MockLuxandFlutterPlatform fakePlatform = MockLuxandFlutterPlatform();
    LuxandFlutterPlatform.instance = fakePlatform;

    expect(await LuxandFlutter.initialize(), true);
  });

  test('activate returns true with valid license', () async {
    MockLuxandFlutterPlatform fakePlatform = MockLuxandFlutterPlatform();
    LuxandFlutterPlatform.instance = fakePlatform;

    expect(await LuxandFlutter.activate('test-license'), true);
  });

  test('extractTemplate returns valid template ID', () async {
    MockLuxandFlutterPlatform fakePlatform = MockLuxandFlutterPlatform();
    LuxandFlutterPlatform.instance = fakePlatform;

    expect(await LuxandFlutter.extractTemplate('test-image.jpg'), 1);
  });

  test('compareTemplates returns similarity value', () async {
    MockLuxandFlutterPlatform fakePlatform = MockLuxandFlutterPlatform();
    LuxandFlutterPlatform.instance = fakePlatform;

    expect(await LuxandFlutter.compareTemplates(1, 2), 0.85);
  });

  test('template management operations', () async {
    MockLuxandFlutterPlatform fakePlatform = MockLuxandFlutterPlatform();
    LuxandFlutterPlatform.instance = fakePlatform;

    expect(await LuxandFlutter.loadTemplate('test-template.dat'), 1);
    expect(await LuxandFlutter.saveTemplate(1, 'output-template.dat'), true);
    expect(await LuxandFlutter.freeTemplate(1), true);
  });

  test('finalize returns true', () async {
    MockLuxandFlutterPlatform fakePlatform = MockLuxandFlutterPlatform();
    LuxandFlutterPlatform.instance = fakePlatform;

    expect(await LuxandFlutter.finalize(), true);
  });
}