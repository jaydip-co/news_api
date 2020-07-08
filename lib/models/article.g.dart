// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
    json['url'] as String ?? '',
    json['urlToImage'] as String ?? '',
    json['publishedAt'] as String ?? '',
    json['content'] as String ?? '',
    author: json['author'] as String ?? '',
    title: json['title'] as String ?? '',
    description: json['description'] as String ?? '',
  );
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'urlToImage': instance.urlToImage,
      'publishedAt': instance.publishedAt,
      'content': instance.content,
    };
