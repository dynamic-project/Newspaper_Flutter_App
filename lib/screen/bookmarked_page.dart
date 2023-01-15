import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../model/article.dart';
import 'article_details_page.dart';

class BookmarkedPage extends StatefulWidget {
  const BookmarkedPage({Key? key}) : super(key: key);

  @override
  _BookmarkedPageState createState() => _BookmarkedPageState();
}

class _BookmarkedPageState extends State<BookmarkedPage> {
  List<Article> _bookmarkedArticles = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _getBookmarkedArticles();
  }

  _getBookmarkedArticles() async {
    _bookmarkedArticles = (await _databaseHelper.getArticles())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarked Articles"),
      ),
      body: _bookmarkedArticles.isEmpty
          ? const Center(child: Text("No bookmarked articles"))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _bookmarkedArticles.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailsPage(
                          article: _bookmarkedArticles[index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(_bookmarkedArticles[index].title),
                          const SizedBox(height: 10),
                          Text(_bookmarkedArticles[index].description),
                          const SizedBox(height: 10),
                          Text(_bookmarkedArticles[index].publishedAt),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
