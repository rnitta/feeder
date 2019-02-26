import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:feeder/models/article_fav.dart';

class ArticleShortView extends StatelessWidget {
  final articleFavState = ArticleFavModel();

  @override
  Widget build(BuildContext context) => ScopedModel<ArticleFavModel>(
      model: this.articleFavState,
      child: Scaffold(
        appBar: AppBar(
          title: Text('hige'),
        ),
      ));
}
