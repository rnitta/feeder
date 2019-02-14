import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feeder/utils/constants.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    //Future.delayed(const Duration(milliseconds: 500), () => pushFirstScene());
    pushFirstScene();
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
  void pushFirstScene() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(Constants.aceessTokenPrefName);
    print(accessToken);
    //FIXME: pushreplaces以外なければまとめる
    if (accessToken == null) {
      Navigator.pushReplacementNamed(context, '/signin');
    } else {
      Navigator.pushReplacementNamed(context, '/signed/team_ramify');
    }
  }
}
