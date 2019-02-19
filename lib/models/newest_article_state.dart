import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:feeder/utils/constants.dart';

class ArticleItemEntity {
  String name;
  bool wip;
  String category;
  String createdByIcon;

  // null気をつける
  ArticleItemEntity.deserialize(Map<String, dynamic> item) {
    name = item['name'];
    wip = item['wip'];
    category = item['category'];
    createdByIcon =
        ((item['created_by'] ?? {}) as Map<String, dynamic>)['icon'];
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
  bool loading = false;

  Future<void> fetchArticles() async {
    if (loading) {
      return;
    }
    page = nextPage;
    if (page == null) {
      isFetchable = false;
      notifyListeners();
      return;
    }
    loading = true;
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
    final posts =
        await compute(deserialize, response.body); // 2回デコード走ることになるのであとで考え直す
    articles.addAll(posts);
    nextPage = await compute(parseNextPage, response.body);
    refreshing = false;
    notifyListeners();
    loading = false;
  }

  Future<void> refresh() async {
    if (refreshing) {
      return;
    }
    page = null;
    nextPage = 1;
    articles = [];
    refreshing = true;
    notifyListeners();
    await fetchArticles();
  }
}
