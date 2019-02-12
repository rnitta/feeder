import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feeder/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:convert';

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

class TeamsModel extends Model {
  List<EsaTeam> teamList = [];
  bool fetchDone = false;
  bool isError = false;

  void fetchTeams() async {
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
      this.teamList = list;
      this.fetchDone = true;
      notifyListeners();
    } else {
      this.fetchDone = true;
      notifyListeners();
      throw Exception('Fail to Access Esa');
    }
  }
}

class SignedRamifyTeamScene extends StatelessWidget {
  final TeamsModel teamsModel;
  SignedRamifyTeamScene(this.teamsModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('チーム選択')),
        body: ScopedModelDescendant<TeamsModel>(
            builder: (context, child, model) =>
                Center(child: _conditionalBuilder(model))));
  }

  Widget _conditionalBuilder(TeamsModel model) {
    if (model.isError) {
      Center(child: Text('Error has occured'));
    }
    if (model.teamList.length == 0) {
      if (model.fetchDone) {
        return Center(
            child: const Text('所属しているチームがありません.')); // 詰むのであとでログアウトボタンを作成する
      } else {
        model.fetchTeams();
        return Center(child: const Text('Loading...'));
      }
    } else {
      return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return EsaTeamButton(model.teamList[index], context);
          },
          itemCount: model.teamList.length,
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 32));
    }
  }
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
              Navigator.pushReplacementNamed(context, '/signed/root');
            });
}
