import 'dart:async';
import 'dart:convert';
import 'dart:math'; // ランダムテスト用
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ArticleItemEntity {
  String name;
  bool wip;
  String category;

  // null気をつける
  ArticleItemEntity.deserialize() {
    name = '';
  }
}

class NewestArticlesState extends Model {
  List<ArticleItemEntity> articles = [];
  bool isFetchable = true;

  Future<void> fetchArticles() async {
    if (isFetchable) {
      Future.delayed(const Duration(seconds: 1), () {
        articles.addAll([null, null, null]);
        if (Random.secure().nextBool()) {
          isFetchable = false;
        }
        notifyListeners();
      });
    }
  }
}

class ArticleItemComponent extends Container {
  ArticleItemComponent() : super(child: Text('hoge'));
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
          return ArticleItemComponent();
        },
      );
    });
  }
}
