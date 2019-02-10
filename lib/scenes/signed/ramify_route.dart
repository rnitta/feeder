import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feeder/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class SignedRamifyTeamScene extends StatefulWidget {
  @override
  _SignedRamifyTeamSceneState createState() => _SignedRamifyTeamSceneState();
}

class _SignedRamifyTeamSceneState extends State<SignedRamifyTeamScene> {
  String accessToken;
  List<EsaTeam> teamList = [];
  bool fetchDone = false;

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('チーム選択')),
      body: Center(
        child: _conditionalBuilder(),
      ),
    );
  }

  Widget _conditionalBuilder() {
    if (this.teamList.length == 0) {
      if (this.fetchDone) {
        return Center(child: const Text('所属しているチームがありません.'));
      } else {
        return Center(child: const Text('Loading...'));
      }
    } else {
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return EsaTeamButton(teamList[index]);
          },
          itemCount: teamList.length,
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 32));
    }
  }

  void _fetchTeams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.accessToken = prefs.getString(Constants.aceessTokenPrefName);
    final response = await http
        .get('https://api.esa.io/v1/teams?access_token=${this.accessToken}');
    if (response.statusCode == 200) {
      List<EsaTeam> list = [];
      Map<String, dynamic> decoded = json.decode(response.body);
      for (var item in decoded['teams']) {
        list.add(EsaTeam.fromJson(item));
      }
      setState(() {
        this.fetchDone = true;
        this.teamList = list;
      });
    } else {
      throw Exception('Fail to Fetch Team');
    }
  }
}

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
  EsaTeamButton(team)
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
              print(team.name);
            });
}
