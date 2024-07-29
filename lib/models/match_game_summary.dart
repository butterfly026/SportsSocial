import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/firebase/firestore_base_model.dart';

@immutable
class MatchGameSummary implements FireStoreBaseModel {
  final int order;
  final String summaryTime;
  final String content;

  const MatchGameSummary({
    required this.order,
    required this.summaryTime,
    required this.content,
  });

  MatchGameSummary.fromJson(Map<String, dynamic> json)
      : this(
          order: json['order'],
          summaryTime: json['summaryTime'],
          content: json['content'],
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'summaryTime': summaryTime,
      'content': content,
    };
  }
}
