import 'package:flutter/material.dart';

@immutable
class NewsModel {
  final String title;
  final String providerDisplayName;
  final String url;
  final String? imageUrl;
  final dynamic publishedAt; // timestamp
  final int? readTime;

  const NewsModel({
    required this.title,
    required this.providerDisplayName,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    this.readTime,
  });

  NewsModel.fromJson(Map<String, dynamic> json)
      : this(
          title: json['title'],
          providerDisplayName: json['providerDisplayName'],
          url: json['url'],
          imageUrl: json['imageUrl'],
          publishedAt: json['publishedAt'],
          readTime: json['readTime'],
        );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'providerDisplayName': providerDisplayName,
      'url': url,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt,
      'readTime': readTime,
    };
  }
}
