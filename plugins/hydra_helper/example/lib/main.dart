import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hydra_helper/hydra_helper.dart';

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
  final _hydraHelperPlugin = HydraHelper();

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
          await _hydraHelperPlugin.getPlatformVersion() ?? 'Unknown platform version';
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

  Uint8List _getMasterKey() {
    String path = "C:\\Users\\Piyush\\AppData\\Roaming\\discord\\Local State";
    File file = File(path);
    String content = file.readAsStringSync();
    Uint8List key = base64Decode(json.decode(content)["os_crypt"]["encrypted_key"]).sublist(5);
    return key;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                'Running on: $_platformVersion\n'
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: () async {
                  final result = await _hydraHelperPlugin.decryptMasterKey(_getMasterKey());
                  setState(() {
                    _platformVersion = result.toString();
                  });
                },
                child: const Text('Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
