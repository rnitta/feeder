import 'package:flutter/material.dart';
import 'package:feeder/utils/padding.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  BuildContext context;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      body: Scaffold(
          appBar: null,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.asset(
                  'images/oauth_icon.png',
                  scale: 2.0,
                ),
                PaddingText('サインインしてください', 0.0, 40.0, 0.0, 40.0),
                RaisedButton(
                    onPressed: () => _showModal(context),
                    child: const Text('サインイン'))
              ],
            ),
          )),
    );
  }

  void _showModal(BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute<Null>(
          settings: const RouteSettings(name: '/signin/webview'),
          builder: (BuildContext context) => Scaffold(
                body: Center(
                  child: Text('aaaaaaaa'),
                ),
              ),
          fullscreenDialog: true, // ダイアログで表示するかどうか
        ));
  }
}
