import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:feeder/models/signed_root_selected_tab.dart';
import 'package:feeder/scenes/signed/newest_articles.dart';

class SignedRoot extends StatelessWidget {
  final selectedTabModel = SignedRootSeletedTabModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SignedRootSeletedTabModel>(
        model: selectedTabModel, child: this._scaffold());
  }

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
      return Center(child: _content());
    });
  }

  Widget _content() {
    switch (selectedTabModel.selectedIndex) {
      case 0:
        return Text('0');
      case 1:
        return NewestArticlesListView();
      case 2:
        return Text('2');
      default:
        return null;
    }
  }

  Widget _bnb() {
    return ScopedModelDescendant<SignedRootSeletedTabModel>(
        builder: (context, child, model) {
      return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.category), title: const Text('カテゴリ')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.list), title: const Text('新着')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings), title: const Text('設定')),
        ],
        currentIndex: selectedTabModel.selectedIndex,
        fixedColor: Colors.teal[700],
        onTap: selectedTabModel.changeIndex,
      );
    });
  }
}
