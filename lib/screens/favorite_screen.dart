import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import 'article_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);
    var favoriteArticles = newsProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Articles'),
      ),
      body: ListView.builder(
        itemCount: favoriteArticles.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(favoriteArticles[i].title),
          subtitle: Text(favoriteArticles[i].description),
          leading: favoriteArticles[i].urlToImage.isNotEmpty
              ? Image.network(favoriteArticles[i].urlToImage, width: 100, fit: BoxFit.cover)
              : null,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ArticleDetailScreen(article: favoriteArticles[i])));
          },
        ),
      ),
    );
  }
}
