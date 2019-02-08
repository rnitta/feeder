import 'package:flutter/material.dart';
import 'package:feeder/scenes/signin.dart';
import 'package:feeder/scenes/splash_screen.dart';

void main() => runApp(AppRoot());

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feeder🐣',
      theme: ThemeData.dark(),
      locale: Locale('ja'),
      showPerformanceOverlay: false,
      routes: <String, WidgetBuilder>{
        '/': (_) => Splash(),
        '/signin': (_) => Signin(),
        '/signed_home': (_) => Scaffold(),
      },
    );
  }
}
