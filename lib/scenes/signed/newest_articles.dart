import 'dart:async';
import 'dart:convert';
import 'dart:math'; // ランダムテスト用
import 'package:flutter/foundation.dart';
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

// トップレベルに置かなければならない
int parseNextPage(String responseBody) {
  return json.decode(responseBody)['next_page'];
}

// トップレベルに置かなければならない
List<ArticleItemEntity> deserialize(String responseBody) {
  return (json.decode(responseBody)['posts'] as List<dynamic>)
      .map<ArticleItemEntity>((object) =>
          ArticleItemEntity.deserialize(object as Map<String, dynamic>))
      .toList();
}

class NewestArticlesState extends Model {
  List<ArticleItemEntity> articles = [];
  int page;
  int nextPage = 1;
  bool isFetchable = true;
  bool refreshing = false;

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
    nextPage = await compute(parseNextPage, response.body);
    final posts =
        await compute(deserialize, response.body); // 2回デコード走ることになるのであとで考え直す
    articles.addAll(posts);
    refreshing = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    page = null;
    nextPage = 1;
    articles = [];
    refreshing = true;
    notifyListeners();
    await fetchArticles();
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
      model: this.newestArticlesState, child: _refreshable());

  Widget _refreshable() => RefreshIndicator(
        child: _listView(),
        onRefresh: newestArticlesState.refresh,
      );

  Widget _listView() {
    return ScopedModelDescendant<NewestArticlesState>(
        builder: (context, child, model) {
      final itemCount = this.newestArticlesState.articles.length;
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (newestArticlesState.refreshing) {
            return null;
          }
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
