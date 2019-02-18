import 'package:scoped_model/scoped_model.dart';

class SignedRootTitleModel extends Model {
  String name;

  SignedRootTitleModel(this.name);
  void changeTitle(String newTitle) {
    this.name = newTitle;
    notifyListeners();
  }
}
