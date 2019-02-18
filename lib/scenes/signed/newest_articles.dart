import 'dart:async';
import 'dart:convert';
import 'dart:math'; // ランダムテスト用
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:feeder/utils/constants.dart';

class ArticleItemEntity {
  String name;
  bool wip;
  String category;

  // null気をつける
  ArticleItemEntity.deserialize(Map<String, dynamic> item) {
    name = item['name'];
    wip = item['wip'];
    category = item['category'];
  }
}

class NewestArticlesState extends Model {
  List<ArticleItemEntity> articles = [];
  int page;
  int nextPage = 1;
  bool isFetchable = true;

  Future<void> fetchArticles() async {
    page = nextPage;
    if (page == null) {
      isFetchable = false;
      notifyListeners();
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String teamName = prefs.getString(Constants.selectedTeamPrefName);
    final String accessToken = prefs.getString(Constants.aceessTokenPrefName);
    final queries = <String, String>{
      'access_token': accessToken,
      'page': page.toString(),
      'per_page': '30' //適切な数に
    };
    final String apiUrl =
        Uri.https('api.esa.io', '/v1/teams/$teamName/posts', queries)
            .toString();
    final response = await http.get(apiUrl);
    Map<String, dynamic> decoded = json.decode(response.body);
    nextPage = decoded['next_page'];
    final posts = decoded['posts'] as List<dynamic>;
    articles.addAll(posts.map((object) =>
        ArticleItemEntity.deserialize(object as Map<String, dynamic>)));
    notifyListeners();
  }
}

class ArticleItemComponent extends Container {
  ArticleItemComponent(ArticleItemEntity articleEntity)
      : super(child: Text('${articleEntity.category} ${articleEntity.name}'));
}

class NewestArticlesListView extends StatelessWidget {
  final newestArticlesState = NewestArticlesState();

  @override
  Widget build(BuildContext context) => ScopedModel<NewestArticlesState>(
      model: this.newestArticlesState, child: _listView());

  Widget _listView() {
    return ScopedModelDescendant<NewestArticlesState>(
        builder: (context, child, model) {
      final itemCount = this.newestArticlesState.articles.length;
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          //あとでもうちょっと先読みするようにする
          if (index == itemCount) {
            newestArticlesState.fetchArticles();
            if (!newestArticlesState.isFetchable) {
              return null;
            }
            return Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: 32.0,
                height: 32.0,
                child: const CircularProgressIndicator(),
              ),
            );
          } else if (index > itemCount) {
            return null;
          }
          return ArticleItemComponent(newestArticlesState.articles[index]);
        },
      );
    });
  }
}
