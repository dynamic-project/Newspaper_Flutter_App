import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/article.dart';
import '../providers/news_provider.dart';
import 'article_details_page.dart';
import 'bookmarked_page.dart';
import 'login_page.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({Key? key}) : super(key: key);

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  List<Article> _articles = [];
  late NewsProvider _newsProvider;
  final String _apiKey = "2166fc58962e4a6eb16f21a0be046464";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _newsProvider = NewsProvider(_apiKey);
    _getTopHeadlines();
  }

  _getTopHeadlines() async {
    _articles = await _newsProvider.getTopHeadlines();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News List"),
        leading: Container(),
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(
            child: const Text("Bookmarked"),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => const BookmarkedPage()),
                    (route) => false,
              );
            },
          ),
          ElevatedButton(
            child: const Text("Sign Out"),
            onPressed: () {
              // handle the sign out button press
              FirebaseAuth.instance.signOut();

              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailsPage(
                    article: _articles[index],
                  ),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(_articles[index].title),
                    const SizedBox(height: 10),
                    Text(_articles[index].description),
                    const SizedBox(height: 10),
                    Text(_articles[index].publishedAt),
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
