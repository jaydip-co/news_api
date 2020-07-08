

import 'dart:async';

import 'package:newsapi/models/article.dart';
import 'dart:convert'as json;
import 'package:http/http.dart' as http;

class BlocforSearch {
  final String url = "https://newsapi.org/v2/everything?apiKey=22eaeaf8f3a64f188e107af7bbd95d32&language=en&q=";
  String keyword;
  StreamController<List<Article>> _searchController = StreamController.broadcast();
  Stream<List<Article>> get finding => _searchController.stream;
  List<Article> results;
  int maxPage;
  int currentpage;
  search(String input) async {
    keyword = input;
    results = new List<Article>();
    final searchUrl = url+input;
    final response = await http.get(searchUrl);
    if(response.statusCode == 200){
      final jsonString = json.jsonDecode(response.body);
      final articles = jsonString['articles'];
      int totalSearch = jsonString['totalResults'];
      maxPage = (totalSearch/20).ceil();
      currentpage = 1;
      for(int i =0;i<articles.length;i++){
        Article Sarticle = Article.fromJson(articles[i]);
        results.add(Sarticle);
      }
      _searchController.add(results);
    }
  }

  addMore()async{
    if(currentpage < maxPage){
      currentpage = currentpage + 1;
      final page = "&page="+currentpage.toString();
      final searchUrl = url+keyword+page;
      final response = await http.get(searchUrl);
      final jsonString = json.jsonDecode(response.body);
      final articles = jsonString['articles'];
      for(int i =0;i<articles.length;i++){
        Article Sarticle = Article.fromJson(articles[i]);
        results.add(Sarticle);
      }
      _searchController.add(results);
    }
  }
}