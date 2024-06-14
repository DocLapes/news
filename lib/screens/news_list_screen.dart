import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import 'article_detail_screen.dart';
import 'favorite_screen.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('News Client'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => FavoriteScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Search'),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                newsProvider.fetchArticles(query: value);
              },
            ),
            DropdownButton<String>(
              value: newsProvider.sortOrder,
              onChanged: (value) {
                newsProvider.setSortOrder(value!);
              },
              items: <String>['publishedAt', 'popularity']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'publishedAt' ? 'Date' : 'Popularity'),
                );
              }).toList(),
            ),
            Expanded(
              child: newsProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: newsProvider.articles.length,
                      itemBuilder: (ctx, i) => ListTile(
                        title: Text(newsProvider.articles[i].title),
                        subtitle: Text(newsProvider.articles[i].description),
                        leading: newsProvider.articles[i].urlToImage.isNotEmpty
                            ? Image.network(newsProvider.articles[i].urlToImage, width: 100, fit: BoxFit.cover)
                            : null,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ArticleDetailScreen(article: newsProvider.articles[i])));
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
