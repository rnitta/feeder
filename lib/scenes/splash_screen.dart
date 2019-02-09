import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feeder/utils/constants.dart';

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
  void pushFirstScene() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString(Constants.aceessTokenPrefName);
    //FIXME: pushreplaces以外なければまとめる
    if (accessToken == null) {
      Navigator.of(context).pushReplacementNamed('/signin');
    } else {
      Navigator.of(context).pushReplacementNamed('/signed/team_ramify');
    }
  }
}
