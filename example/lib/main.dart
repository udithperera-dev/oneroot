import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:oneroot/oneroot.dart';

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
  String _platformRootStatus = 'Unknown';
  final _onerootPlugin = Oneroot();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    String platformRootStatus;
    try {
      platformVersion =
          await _onerootPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      platformRootStatus =
          await _onerootPlugin.getRootChecker() ?? 'NOT ROOTED';
      if(platformRootStatus==''){platformRootStatus='NOT ROOTED';}
    } on PlatformException {
      platformRootStatus = 'Failed to get platform root status.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _platformRootStatus = platformRootStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Picker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('One Root'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('Root Status: $_platformRootStatus\n')
            ],
          ),
        ),
      ),
    );
  }
}
