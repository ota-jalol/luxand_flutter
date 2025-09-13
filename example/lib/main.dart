import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:luxand_flutter/luxand_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _sdkInitialized = false;
  bool _sdkActivated = false;
  String _statusMessage = 'Ready';
  final bool _unknown = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await LuxandFlutter.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _initializeSDK() async {
    try {
      setState(() {
        _statusMessage = 'Initializing SDK...';
      });

      final result = await LuxandFlutter.initialize();
      
      setState(() {
        _sdkInitialized = result;
        _statusMessage = result ? 'SDK initialized successfully' : 'SDK initialization failed';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error initializing SDK: $e';
      });
    }
  }

  Future<void> _activateSDK() async {
    if (!_sdkInitialized) {
      setState(() {
        _statusMessage = 'Please initialize SDK first';
      });
      return;
    }

    try {
      setState(() {
        _statusMessage = 'Activating SDK...';
      });

      // Use a demo license key (in real app, this should be your actual license)
      const licenseKey = "YOUR_LUXAND_LICENSE_KEY_HERE";
      final result = await LuxandFlutter.activate(licenseKey);
      
      setState(() {
        _sdkActivated = result;
        _statusMessage = result ? 'SDK activated successfully' : 'SDK activation failed - check license key';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error activating SDK: $e';
      });
    }
  }

  Future<void> _testTemplateOperations() async {
    if (!_sdkActivated) {
      setState(() {
        _statusMessage = 'Please initialize and activate SDK first';
      });
      return;
    }

    try {
      setState(() {
        _statusMessage = 'Testing template operations...';
      });

      // Mock template extraction (in real app, you'd use actual image files)
      const mockImagePath = "path/to/test/image.jpg";
      final templateId = await LuxandFlutter.extractTemplate(mockImagePath);
      
      if (templateId != -1) {
        setState(() {
          _statusMessage = 'Template extracted successfully (ID: $templateId)';
        });
        
        // Test template saving
        const savePath = "path/to/save/template.dat";
        final saved = await LuxandFlutter.saveTemplate(templateId, savePath);
        
        if (saved) {
          setState(() {
            _statusMessage = 'Template saved successfully';
          });
        }
        
        // Clean up template
        await LuxandFlutter.freeTemplate(templateId);
      } else {
        setState(() {
          _statusMessage = 'Template extraction failed (this is expected without actual image)';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error testing template operations: $e';
      });
    }
  }

  Future<void> _finalizeSDK() async {
    try {
      setState(() {
        _statusMessage = 'Finalizing SDK...';
      });

      final result = await LuxandFlutter.finalize();
      
      setState(() {
        _sdkInitialized = false;
        _sdkActivated = false;
        _statusMessage = result ? 'SDK finalized successfully' : 'SDK finalization failed';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error finalizing SDK: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Luxand Flutter Plugin Example'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Platform Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('Running on: $_platformVersion'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SDK Status',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            _sdkInitialized ? Icons.check_circle : Icons.cancel,
                            color: _sdkInitialized ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text('Initialized: ${_sdkInitialized ? "Yes" : "No"}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            _sdkActivated ? Icons.check_circle : Icons.cancel,
                            color: _sdkActivated ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text('Activated: ${_sdkActivated ? "Yes" : "No"}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: _sdkInitialized ? null : _initializeSDK,
                            child: const Text('Initialize SDK'),
                          ),
                          ElevatedButton(
                            onPressed: (_sdkInitialized && !_sdkActivated) ? _activateSDK : null,
                            child: const Text('Activate SDK'),
                          ),
                          ElevatedButton(
                            onPressed: _sdkActivated ? _testTemplateOperations : null,
                            child: const Text('Test Templates'),
                          ),
                          ElevatedButton(
                            onPressed: _sdkInitialized ? _finalizeSDK : null,
                            child: const Text('Finalize SDK'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(_statusMessage),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Note',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This is a demo implementation. To use with actual Luxand SDK:\n'
                        '1. Install Luxand FaceSDK\n'
                        '2. Update Windows C++ code to include actual Luxand SDK headers\n'
                        '3. Link with Luxand SDK libraries\n'
                        '4. Replace mock implementations with actual SDK calls\n'
                        '5. Obtain and use a valid Luxand license key',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}