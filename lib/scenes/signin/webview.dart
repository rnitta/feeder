import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninWebview extends WebviewScaffold {
  static const queries = {
    'client_id':
        'deb7fb79eafca6979ba40d91445e96613e16398cf2e1124dd80829a42a7c3ea3',
    'scope': 'read write',
    'redirect_uri': 'urn:ietf:wg:oauth:2.0:oob',
    'response_type': 'code'
  };
  static final authURL =
      Uri.https('api.esa.io', 'oauth/authorize', queries).toString();
  static const userAgentStr =
      'Mozilla /5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B5110e Safari/601.1 EsaTheDarkness'; // 闇
  SigninWebview(BuildContext context)
      : super(
            url: authURL,
            appBar: AppBar(title: Text('ログイン')),
            userAgent: userAgentStr,
            resizeToAvoidBottomPadding: false) {
    addSigninCompleteWatcher(context);
  }

  void addSigninCompleteWatcher(BuildContext context) {
    final webviewplugin = FlutterWebviewPlugin();
    webviewplugin.onUrlChanged.listen((String url) {
      final token = Uri.parse(url).queryParameters['code']; // クラッシュしそうな雰囲気を感じる
      // ドメインやパスも検証したほうが良いかも
      if (token != null) {
        // null安全他にいい方法がありそう
        saveTokenToKVS(token);
        Navigator.popUntil(context, ModalRoute.withName('/signin'));
      }
    });
  }

  void saveTokenToKVS(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('esa_access_token', token);
  }
}
