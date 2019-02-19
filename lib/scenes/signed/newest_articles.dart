import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:feeder/models/newest_article_state.dart';
import 'package:feeder/components/article_list_item.dart';

class NewestArticlesListView extends StatelessWidget {
  final newestArticlesState = NewestArticlesState();

  @override
  Widget build(BuildContext context) => ScopedModel<NewestArticlesState>(
      model: this.newestArticlesState, child: _refreshable());

  Widget _refreshable() => RefreshIndicator(
        child: _listView(),
        onRefresh: newestArticlesState.refresh,
      );

  Widget _listView() {
    return ScopedModelDescendant<NewestArticlesState>(
        builder: (context, child, model) {
      final itemCount = this.newestArticlesState.articles.length;
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (newestArticlesState.refreshing) {
            return null;
          }
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
          return ArticleItemComponent(newestArticlesState.articles[index]);
        },
      );
    });
  }
}
