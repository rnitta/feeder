import 'package:flutter/material.dart';
import 'package:feeder/utils/padding.dart';

class RequireAuth extends Scaffold {
  RequireAuth()
      : super(
            appBar: null,
            body: Center(
              child: RequireAuthWrapper(),
            ));
}

class RequireAuthWrapper extends Column {
  RequireAuthWrapper()
      : super(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image.asset(
              'images/oauth_icon.png',
              scale: 2.0,
            ),
            PaddingText.build('下のボタンからログインしてください', 0.0, 40.0, 0.0, 80.0),
            AuthSignInButton()
          ],
        );
}

class AuthSignInButton extends RaisedButton {
  static _onPressedCallback() {
    print('fuga');
  }

  AuthSignInButton()
      : super(onPressed: _onPressedCallback, child: Text('Sign in'));
}
