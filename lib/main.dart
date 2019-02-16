import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:feeder/scenes/signin.dart';
import 'package:feeder/scenes/splash_screen.dart';
import 'package:feeder/scenes/signed/ramify_team.dart';
import 'package:feeder/scenes/signed/root.dart';
import 'package:feeder/models/signed_root_selected_tab.dart';

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
        '/signed/team_ramify': (_) {
          final model = TeamsModel();
          return ScopedModel<TeamsModel>(
            model: model,
            child: SignedRamifyTeamScene(model),
          );
        },
        '/signed/root': (_) {
          return SignedRoot(SignedRootSeletedTabModel());
        }
      },
    );
  }
}
