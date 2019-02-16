import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:feeder/models/esa_team.dart';
import 'package:feeder/models/signed_root_selected_tab.dart';

class SignedRoot extends StatelessWidget {
  final SignedRootSeletedTabModel selectedTabModel;
  SignedRoot(this.selectedTabModel) : super();

  @override
  Widget build(BuildContext context) {
    print('build');
    return ScopedModel<SignedRootSeletedTabModel>(
        model: SignedRootSeletedTabModel(), child: this._scaffold());
  }

  final _tabs = <Widget>[
    Text('Index 0: Home'),
    Text('Index 1: Business'),
    Text('Index 2: School'),
  ];

  Scaffold _scaffold() {
    return Scaffold(
        appBar: AppBar(
          title: Text('title'),
        ),
        body: _body(),
        bottomNavigationBar: _bnb());
  }

  Widget _body() {
    return ScopedModelDescendant<SignedRootSeletedTabModel>(
        builder: (context, child, model) {
      print('a');
      return Center(child: _tabs.elementAt(selectedTabModel.selectedIndex));
    });
  }

  BottomNavigationBar _bnb() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: const Icon(Icons.home), title: const Text('Home')),
        BottomNavigationBarItem(
            icon: const Icon(Icons.business), title: const Text('Business')),
        BottomNavigationBarItem(
            icon: const Icon(Icons.school), title: const Text('School')),
      ],
      currentIndex: 1,
      fixedColor: Colors.deepPurple,
      onTap: selectedTabModel.changeIndex,
    );
  }
}
