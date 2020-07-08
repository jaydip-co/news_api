import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:newsapi/models/article.dart';
import 'package:newsapi/services/ArticleBloc.dart';
import 'package:newsapi/services/BlocforSearch.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ArticleBloc bloc = ArticleBloc();
  ScrollController _scrollContoller = ScrollController();
  bool isLoading = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollContoller.addListener(() {
      if(_scrollContoller.position.pixels == _scrollContoller.position.maxScrollExtent){
        bloc.addMoreCategory();
      }
    });
  }
  @override
  void dispose() {
    _scrollContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),
              onPressed: (){
                showSearch(context: context, delegate: Actiondelegate());
              },)
          ],
        ),
        body: RefreshIndicator(
          onRefresh: (){
            bloc.initializeData();
            return Future.delayed(Duration(milliseconds: 10));
          },
          child: StreamBuilder<List<Article>>(
              stream: bloc.getArticle,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if(data == null){
                  return Center(
                    child: SpinKitPulse(size: 60,color: Colors.cyan,),
                  );
                }
                else {
                  return ListView.builder(
                      controller: _scrollContoller ,
                      itemCount: data.length,
                      itemBuilder: (con, pos) {
                        final single = data[pos];
                        return ExpansionTile(
                          key: Key(single.title),
                          title: Text(single.title),
                          initiallyExpanded: false,
                          children: <Widget>[
                            Image(
                                image: NetworkImage(single.urlToImage)
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(single.description),
                            ),
                          ],
                        );
                      }
                  );
                }
              }
          ),
        ),
        bottomNavigationBar: BottomNav(Bloc: bloc,)
    );
  }
}

class BottomNav extends StatefulWidget {
  final ArticleBloc Bloc;

  const BottomNav({Key key, this.Bloc}) : super(key: key);
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.red,
      currentIndex: _currentIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.cyan,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(title: Text('top'),icon: Icon(Icons.keyboard_arrow_up)),
        BottomNavigationBarItem(title: Text('business'), icon: Icon(Icons.business)),
        BottomNavigationBarItem(title: Text('sports'), icon: Icon(Icons.settings_input_svideo)),
        BottomNavigationBarItem(title: Text('entertainment'), icon: Icon(Icons.camera)),
        BottomNavigationBarItem(title: Text('health'),icon: Icon(Icons.healing)),
        BottomNavigationBarItem(title: Text('science'),icon: Icon(Icons.scatter_plot)),
        BottomNavigationBarItem(title: Text('technology'),icon: Icon(Icons.terrain)),
      ],
      onTap: (index){
        if(_currentIndex != index){
          setState(() {
            _currentIndex = index;
          });
          widget.Bloc.addCategoryType(index);
        }

      },
    );
  }
}


class Actiondelegate extends SearchDelegate<Article>{

  BlocforSearch searchBloc = BlocforSearch();
  ScrollController _Controller = ScrollController();
  Actiondelegate(){
    _Controller.addListener(() {
      if(_Controller.position.pixels == _Controller.position.maxScrollExtent){
        searchBloc.addMore();
      }
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[IconButton(
      icon: Icon(Icons.clear),
      onPressed: (){
        query = '';
      },
    )];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(query != ''){
      searchBloc.search(query);
    }
    return StreamBuilder<List<Article>>(
      stream: searchBloc.finding,
      builder: (context,snapshot){
        final data = snapshot.data;
        if(data == null){
          return Center(
            child: SpinKitPulse(size: 60,color: Colors.cyan,),
          );
        }
        else{
          return ListView.builder(
              controller: _Controller,
              itemCount: data.length,
              itemBuilder: (con,index){
                final single = data[index];
                return ExpansionTile(
                  key: Key(single.title),
                  title: Text(single.title),
                  initiallyExpanded: false,
                  children: <Widget>[
                    Image(
                        image: NetworkImage(single.urlToImage)
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(single.description),
                    ),
                  ],
                );
              }
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

}