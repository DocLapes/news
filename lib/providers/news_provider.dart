import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _favorites = [];
  bool _isLoading = false;
  String _sortOrder = 'publishedAt';

  List<Article> get articles => _articles;
  List<Article> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get sortOrder => _sortOrder;

  NewsProvider() {
    _loadFavorites();
    fetchArticles();
  }

  Future<void> fetchArticles({String query = ''}) async {
    _isLoading = true;
    notifyListeners();

    final url = 'https://newsapi.org/v2/everything?q=${query}&apiKey=YOUR_API_KEY';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = (data['articles'] as List).map((json) => Article.fromJson(json)).toList();
        _sortArticles();
      } else {
        _articles = [];
      }
    } catch (error) {
      _articles = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void _sortArticles() {
    if (_sortOrder == 'publishedAt') {
      _articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else if (_sortOrder == 'popularity') {
      // Implement sort by popularity if data is available
    }
    notifyListeners();
  }

  void setSortOrder(String order) {
    _sortOrder = order;
    _sortArticles();
  }

  void toggleFavorite(Article article) {
    if (_favorites.contains(article)) {
      _favorites.remove(article);
    } else {
      _favorites.add(article);
    }
    _saveFavorites();
    notifyListeners();
  }

  void _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteUrls = _favorites.map((article) => article.url).toList();
    prefs.setStringList('favoriteArticles', favoriteUrls);
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteUrls = prefs.getStringList('favoriteArticles');
    if (favoriteUrls != null) {
      _favorites = _articles.where((article) => favoriteUrls.contains(article.url)).toList();
    }
    notifyListeners();
  }
}
