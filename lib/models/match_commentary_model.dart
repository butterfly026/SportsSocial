import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/firebase/firestore_base_model.dart';

enum MatchCommentaryType {
  defaultType,
  whistle,
  time,
  corner,
  substitution,
  goal,
  goalAgainst,
  yellowCard,
  yellowRedCard,
  redCard,
  funfact,
  lineup,
  injury,
  penaltyOut,
  penalty,
  varType,
  attendance,
}

@immutable
class MatchCommentaryModel implements FireStoreBaseModel {
  final int level;
  final String message;
  final String time;
  final MatchCommentaryType type;
  final String hash;
  final int order;

  const MatchCommentaryModel({
    required this.level,
    required this.message,
    required this.time,
    required this.type,
    required this.hash,
    required this.order,
  });

  MatchCommentaryModel.fromJson(Map<String, dynamic> json)
      : this(
          level: json['level'],
          message: json['message'],
          time: json['time'],
          type: MatchCommentaryType.values.byName(
              json['type']..toString().replaceAll('default', 'defaultType')),
          hash: json['hash'],
          order: json['order'],
        );

  @override
  Map<String, dynamic> toJson() => {
        'level': level,
        'message': message,
        'time': time,
        'type': type.toString().split('.').last,
        'hash': hash,
        'order': order,
      };
}
