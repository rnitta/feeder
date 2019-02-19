import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feeder/models/newest_article_state.dart';

class ArticleItemComponent extends Container {
  ArticleItemComponent(ArticleItemEntity articleEntity)
      : super(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.grey[700]),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Row(children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Center(child: _icon(articleEntity))),
              _content(articleEntity)
            ]));

  static Widget _icon(ArticleItemEntity entity) {
    if (entity.createdByIcon == null) {
      return FlutterLogo(
        size: 30,
      );
    } else {
      return Image.network(
        entity.createdByIcon,
        height: 30,
        width: 30,
      );
    }
  }

  static Widget _content(ArticleItemEntity entity) => Flexible(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Text(
                entity.category,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Text(entity.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            )
          ]));
}
