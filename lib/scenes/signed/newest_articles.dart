import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:feeder/models/newest_article_state.dart';
import 'package:feeder/components/article_list_item.dart';
import 'package:feeder/scenes/signed/article_short_view.dart';

class NewestArticlesListView extends StatelessWidget {
  final newestArticlesState = NewestArticlesState();

  @override
  Widget build(BuildContext context) =>
      ScopedModel<NewestArticlesState>(model: this.newestArticlesState, child: _refreshable());

  Widget _refreshable() => RefreshIndicator(
        child: _listView(),
        onRefresh: newestArticlesState.refresh,
      );

  Widget _listView() {
    return ScopedModelDescendant<NewestArticlesState>(builder: (context, child, model) {
      final itemCount = this.newestArticlesState.articles.length;
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (newestArticlesState.refreshing) {
            return null;
          }
          if (itemCount == 0 || index == itemCount - 10) {
            // 10が適切かはあとで考える
            newestArticlesState.fetchArticles();
          }
          if (index == itemCount) {
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
          return GestureDetector(
              onTap: () {
                _navigateToArticleShowSnece(context, newestArticlesState.articles[index]);
              },
              child: Hero(
                // Hero毎コンポーネントにいれたほうがいいかも
                tag: 'articlec${newestArticlesState.articles[index].number}',
                child: ArticleItemComponent(newestArticlesState.articles[index]),
              ));
        },
      );
    });
  }

  void _navigateToArticleShowSnece(BuildContext context, ArticleItemEntity entity) {
    Navigator.push(
      context,
      MaterialPageRoute<Null>(
        settings: const RouteSettings(name: "/signed/article_short"),
        builder: (BuildContext context) => ArticleShortView(entity),
      ),
    );
  }
}
