

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'dart:convert'as json;
import 'package:http/http.dart' as http;
import 'package:newsapi/models/article.dart';
class ArticleBloc {

  final url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=22eaeaf8f3a64f188e107af7bbd95d32";
  final urlforevery = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=22eaeaf8f3a64f188e107af7bbd95d32";
  final urlWithPageNumber= "https://newsapi.org/v2/top-headlines?country=in&apiKey=22eaeaf8f3a64f188e107af7bbd95d32&page=";
  int currentpage;
  int maxpage;
  int totalresult;
  int totalLoaded;
  String _CurrentCategory = 'general';
  List<Article> newarticles;

  ArticleBloc(){
    initializeData();

  }

  initializeData() async {
    _AtricleContoller.add(null);
    currentpage = 1;
    final urls = "http://newsapi.org/v2/top-headlines?country=in&apiKey=22eaeaf8f3a64f188e107af7bbd95d32&category=$_CurrentCategory&page=$currentpage";
    final response = await http.get(urls);
    final jsonString = json.jsonDecode(response.body);
    final articles = jsonString['articles'];
    totalresult = jsonString['totalResults'];
    maxpage = (totalresult/20).ceil();
    newarticles = new List<Article>();
    for(int i=0; i<articles.length ; i++){
      Article single = Article.fromJson(articles[i]);
      newarticles.add(single);
    }
    currentpage = 1;
    _AtricleContoller.add(newarticles);
  }
  addMoreCategory() async{
    if(currentpage < maxpage){
      currentpage = currentpage+1;
      final urls = "http://newsapi.org/v2/top-headlines?country=in&apiKey=22eaeaf8f3a64f188e107af7bbd95d32&category=$_CurrentCategory&page=$currentpage";
      final response = await http.get(urls);
      if(response.statusCode == 200){
        final jsonString = json.jsonDecode(response.body);
        final articles = jsonString['articles'];
        for(int i=0; i<articles.length ; i++){
          Article single = Article.fromJson(articles[i]);
          newarticles.add(single);
        }
        _AtricleContoller.add(newarticles);
      }

    }

  }

  addCategoryType(int a) async {
    _AtricleContoller.add(null);
    String category;
    switch(a){
      case 0:
        category = 'general';
        break;
      case 1:
        category = 'business';
        break;
      case 2:
        category = 'sport';
        break;
      case 3:
        category = 'entertainment';
        break;
      case 4:
        category = 'health';
        break;
      case 5:
        category = 'science';
        break;
      case 6:
        category = 'technology';
        break;
    }
    _CurrentCategory = category;
    initializeData();
  }

  StreamController<List<Article>> _AtricleContoller = StreamController.broadcast();
  Stream<List<Article>> get getArticle => _AtricleContoller.stream;
}