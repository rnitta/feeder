import 'package:scoped_model/scoped_model.dart';

class ArticleFavModel extends Model {
  bool starred = false;
  bool watched = false;

  void star(bool isAttach) {
    starred = isAttach;
  }

  void watch(bool isAttach) {
    watched = isAttach;
  }
}
