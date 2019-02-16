import 'package:scoped_model/scoped_model.dart';

class SignedRootSeletedTabModel extends Model {
  int selectedIndex = 1;

  void changeIndex(int n) {
    print(n);
    this.selectedIndex = n;
    notifyListeners();
    print(this.selectedIndex);
  }
}
