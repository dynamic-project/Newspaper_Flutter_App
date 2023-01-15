import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/article.dart';

class NewsProvider {
  static const String _baseUrl = 'https://newsapi.org/v2/';
  final String _apiKey;

  NewsProvider(this._apiKey);

  Future<List<Article>> getTopHeadlines() async {
    // Construct the URL string
    var url = Uri.parse(_baseUrl + 'top-headlines');

    // Add headers
    var headers = {'x-api-key': _apiKey};

    // Make the GET request
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> articlesJson = data['articles'];
      return articlesJson.map((e) => Article.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load top headlines');
    }
  }
}