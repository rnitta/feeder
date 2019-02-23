import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feeder/models/newest_article_state.dart';
import 'package:elapsed_time/elapsed_time.dart';

class ArticleItemComponent extends Container {
  static final timeFormatter = ElapsedTime(format1: 'yyyy年M月d日', format2: 'M月d日 H時');

  ArticleItemComponent(ArticleItemEntity articleEntity)
      : super(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.grey[700]),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Row(children: <Widget>[
              Container(padding: const EdgeInsets.all(10), child: Center(child: _icon(articleEntity))),
              _content(articleEntity)
            ]));

  static Widget _icon(ArticleItemEntity entity) {
    if (entity.createdByIcon == null) {
      return FlutterLogo(
        size: 30,
      );
    } else {
      return CircleImage.network(
        entity.createdByIcon,
        height: 30,
        width: 30,
      );
    }
  }

  static Widget _content(ArticleItemEntity entity) => Flexible(
          child:
              Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Flexible(
              child: Text(timeFormatter.fromNow(at: entity.updatedAt),
                  overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 14))),
          Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: CircleImage.network(
                entity.updatedByIcon,
                height: 14,
                width: 14,
              ))
        ]),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
          child: Text(
            entity.category,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Text(entity.name,
              overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        _tagHListedRow(entity.tags)
      ]));

  static Widget _tagHListedRow(List<String> tags) {
    Iterable<String> childs = tags.map((tag) => ' #$tag');
    if (childs.length == 0) {
      childs = ['no tags'].map((_) => _);
    }
    final List<Text> children =
        childs.map((String tag) => Text(tag, style: const TextStyle(color: Colors.grey, fontSize: 14))).toList();
    return Row(
      children: children,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}

class CircleImage {
  static Widget network(String url, {double width, double height}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(url),
            )),
      );
}
