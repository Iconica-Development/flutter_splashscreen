import 'package:flutter/material.dart';
import 'package:flutter_splashscreen/flutter_splashscreen.dart';

void main() {
  runApp(const MaterialApp(home: FlutterSplashscreenDemo()));
}

class FlutterSplashscreenDemo extends StatelessWidget {
  const FlutterSplashscreenDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(
        backgroundColor: Colors.amber,
        onComplete: () {
          debugPrint('Splashscreen completed');
        },
      ),
    );
  }
}
