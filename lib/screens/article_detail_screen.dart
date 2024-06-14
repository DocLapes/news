import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/news_provider.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article.urlToImage.isNotEmpty
                ? Image.network(article.urlToImage)
                : Container(),
            SizedBox(height: 10),
            Text(
              article.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(article.description),
            Spacer(),
            IconButton(
              icon: Icon(
                newsProvider.favorites.contains(article) ? Icons.favorite : Icons.favorite_border,
                color: newsProvider.favorites.contains(article) ? Colors.red : null,
              ),
              onPressed: () {
                newsProvider.toggleFavorite(article);
              },
            ),
          ],
        ),
      ),
    );
  }
}
