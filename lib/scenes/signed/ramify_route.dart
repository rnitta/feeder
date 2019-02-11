import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feeder/utils/constants.dart';
import 'package:feeder/scenes/signed/root.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class TeamsState {
  List<EsaTeam> teamList;
  bool fetchDone;

  TeamsState({this.teamList = const <EsaTeam>[], this.fetchDone = false});

  // @override
  // // あとでちゃんと書くか消す
  // String toString() {
  //   return 'TeamState: {$teamList}';
  // }
}

class SignedRamifyTeamIW extends InheritedWidget {
  SignedRamifyTeamIW({
    Key key,
    @required Widget child,
    this.data,
  }) : super(key: key, child: child);

  final _SignedRamifyTeamSceneState data;

  @override
  bool updateShouldNotify(SignedRamifyTeamIW oldWidget) {
    return data != oldWidget.data;
  }
}

class SignedRamifyTeamScene extends StatefulWidget {
  static _SignedRamifyTeamSceneState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(SignedRamifyTeamIW)
            as SignedRamifyTeamIW)
        .data;
  }

  @override
  _SignedRamifyTeamSceneState createState() => _SignedRamifyTeamSceneState();
}

class _SignedRamifyTeamSceneState extends State<SignedRamifyTeamScene> {
  TeamsState state;

  @override
  void initState() {
    super.initState();
    this.state = TeamsState(); //ここで２回走ってるけどまあしゃーない
    _fetchTeams();
  }

  @override
  Widget build(BuildContext context) {
    return SignedRamifyTeamIW(
        data: this,
        child: Scaffold(
          appBar: AppBar(title: const Text('チーム選択')),
          body: Center(
            child: _conditionalBuilder(),
          ),
        ));
  }

  Widget _conditionalBuilder() {
    if (this.state.teamList.length == 0) {
      if (this.state.fetchDone) {
        return Center(child: const Text('所属しているチームがありません.'));
      } else {
        return Center(child: const Text('Loading...'));
      }
    } else {
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return EsaTeamButton(this.state.teamList[index], context);
          },
          itemCount: this.state.teamList.length,
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 32));
    }
  }

  void _fetchTeams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString(Constants.aceessTokenPrefName);
    final response = await http.get(
        'https://api.esa.io/v1/teams?access_token=${accessToken}&per_page=100');
    if (response.statusCode == 200) {
      List<EsaTeam> list = [];
      Map<String, dynamic> decoded = json.decode(response.body);
      for (var item in decoded['teams']) {
        list.add(EsaTeam.fromJson(item));
      }
      setState(() {
        this.state.teamList = list;
        this.state.fetchDone = true;
      });
    } else {
      throw Exception('Fail to Fetch Team');
    }
  }
}

//FIXME: modelsあたりに分離
class EsaTeam {
  final String url;
  final String name;
  final String iconUrl;
  final String description;

  EsaTeam.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        name = json['name'],
        iconUrl = json['icon'],
        description = json['description'];
}

class EsaTeamButton extends FlatButton {
  EsaTeamButton(EsaTeam team, BuildContext context)
      : super(
            child: Card(
                child: ListTile(
              leading: Image.network(
                team.iconUrl,
                height: 50,
                width: 50,
              ),
              title: Text(team.name),
              subtitle: Text(team.url),
            )),
            onPressed: () {
              final _SignedRamifyTeamSceneState state =
                  SignedRamifyTeamScene.of(context);
              print(state.state.teamList.length);
              print(state.state.teamList);
              print(state.state.fetchDone);
              // state変えてリビルド止めてpushReplacementで移動する

              // Navigator.push(
              //     context,
              //     MaterialPageRoute<Null>(
              //         settings: RouteSettings(name: '/signed/root'),
              //         builder: (BuildContext context) {
              //           SignedRoot(team);
              //         }));
            });
}
