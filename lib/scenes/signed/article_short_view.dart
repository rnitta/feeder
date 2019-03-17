import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:feeder/models/article_fav.dart';
import 'package:feeder/models/newest_article_state.dart';
import 'package:feeder/components/article_list_item.dart';

class ArticleShortView extends StatelessWidget {
  final articleFavState = ArticleFavModel();
  final ArticleItemEntity entity;

  ArticleShortView(this.entity) : assert(entity != null);

  @override
  Widget build(BuildContext context) => ScopedModel<ArticleFavModel>(
      model: this.articleFavState,
      child: Scaffold(
          appBar: AppBar(
            title: Text('hige'),
          ),
          body: _body(),
          floatingActionButton: _fabs()));

  Widget _body() => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[Hero(tag: 'articlec${entity.number}', child: ArticleItemComponent(entity)), Text('a')],
      );

  Widget _fabs() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                onPressed: () {},
              )),
        ],
      );
}
