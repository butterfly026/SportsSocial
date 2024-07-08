import 'package:flutter/material.dart';

@immutable
class NewsModel {
  final String title;
  final String providerDisplayName;
  final String imageUrl;
  final dynamic publishedAt; // timestamp
  final String? readTime;

  const NewsModel({
    required this.title,
    required this.providerDisplayName,
    required this.imageUrl,
    required this.publishedAt,
    this.readTime,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'],
      providerDisplayName: json['providerDisplayName'],
      imageUrl: json['imageUrl'],
      publishedAt: json['publishedAt'],
      readTime: json['readTime'],
    );
  }
}
