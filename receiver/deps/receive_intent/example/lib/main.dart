import 'dart:async';

import 'package:flutter/material.dart' hide Intent;
import 'package:receive_intent/receive_intent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Intent _initialIntent;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final receivedIntent = await ReceiveIntent.getInitialIntent();

    if (!mounted) return;

    setState(() {
      _initialIntent = receivedIntent;
    });
  }

  Widget _buildFromIntent(String label, Intent intent) {
    return Center(
      child: Column(
        children: [
          Text(label),
          Text(
              "fromPackage: ${intent?.fromPackageName}\nfromSignatures: ${_initialIntent?.fromSignatures}"),
          Text(
              'action: ${_initialIntent?.action}\ndata: ${_initialIntent?.data}\ncategories: ${_initialIntent?.categories}'),
          Text("extras: ${_initialIntent?.extra}")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFromIntent("INITIAL", _initialIntent),
              StreamBuilder<Intent>(
                stream: ReceiveIntent.receivedIntentStream,
                builder: (context, snapshot) =>
                    _buildFromIntent("STREAMED", snapshot.data),
              )
            ],
          ),
        ),
      ),
    );
  }
}
