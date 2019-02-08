import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () => pushFirstScene());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ネットワークチェックもしたい
  void pushFirstScene() {
    // 戻れなくなるから普通のpushでいいかも
    Navigator.of(context).pushReplacementNamed('/signin');
  }
}
