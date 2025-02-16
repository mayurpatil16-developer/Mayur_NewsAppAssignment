import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article.dart';

class NewsProvider with ChangeNotifier {
  static const String _apiKey = '24bf2150bf0341a2b164fd78aebb505e';
  static const String _baseUrl = 'https://newsapi.org/v2';

  List<Article> _articles = [];
  String _currentCategory = 'general';
  bool _isLoading = false;
  String _error = '';
  int _page = 1;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get error => _error;

  String _getCategoryParam(String category) {
    // Convert display name to API parameter
    switch (category.toLowerCase()) {
      case 'top stories':
        return 'general';
      default:
        return category.toLowerCase();
    }
  }

  Future<void> fetchArticles({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _articles = [];
    }

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/top-headlines?country=us&category=${_getCategoryParam(_currentCategory)}&page=$_page&apiKey=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Article> newArticles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();

        if (refresh) {
          _articles = newArticles;
        } else {
          _articles.addAll(newArticles);
        }
        _page++;
      } else {
        _error = 'Failed to fetch articles';
      }
    } catch (e) {
      _error = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _currentCategory = category;
    fetchArticles(refresh: true);
  }
}
