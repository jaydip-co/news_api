import 'package:json_annotation/json_annotation.dart';
part 'article.g.dart';
@JsonSerializable()
class Article{
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article(this.url, this.urlToImage, this.publishedAt, this.content, {this.author,this.title,this.description});
  factory Article.fromJson(Map<String,dynamic> json) => _$ArticleFromJson(json);
}