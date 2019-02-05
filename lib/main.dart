import 'package:flutter/material.dart';
import 'package:feeder/scenes/require_auth.dart';

void main() => runApp(AppRoot());

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RequireAuth(),
      title: 'Feeder🐣',
      theme: ThemeData.dark(),
      locale: Locale('ja'),
      showPerformanceOverlay: false,
    );
  }
}
