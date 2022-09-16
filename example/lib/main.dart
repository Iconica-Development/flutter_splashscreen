import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: FlutterSplashscreenDemo()));
}

class FlutterSplashscreenDemo extends StatelessWidget {
  const FlutterSplashscreenDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('FlutterSplashscreenDemo'));
  }
}
