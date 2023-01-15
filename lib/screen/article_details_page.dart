import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../model/article.dart';

class ArticleDetailsPage extends StatefulWidget {
  final Article article;

  const ArticleDetailsPage({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleDetailsPageState createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  bool _isBookmarked = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _checkBookmarked();
  }

  _checkBookmarked() async {
    List<Article>? bookmarkedArticles = await _databaseHelper.getArticles();
    if (bookmarkedArticles != null) {
      if (bookmarkedArticles.contains(widget.article)) {
        setState(() {
          _isBookmarked = true;
        });
      }
    }
  }

  _addToBookmark() async {
    await _databaseHelper.insertArticle(widget.article);
    setState(() {
      _isBookmarked = true;
    });
  }

  _removeFromBookmark() async {
    await _databaseHelper.deleteArticle(widget.article.id!);
    setState(() {
      _isBookmarked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Article Details"),
        actions: [
          _isBookmarked
              ? ElevatedButton(
            child: const Text("Remove from Bookmark"),
            onPressed: () {
              _removeFromBookmark();
            },
          )
              : ElevatedButton(
            child: const Text("Add to Bookmark"),
            onPressed: () {
              _addToBookmark();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(widget.article.title),
            const SizedBox(height: 10),
            Text(widget.article.description),
            const SizedBox(height: 10),
            Text(widget.article.publishedAt),
          ],
        ),
      ),
    );
  }
}