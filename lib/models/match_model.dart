import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/firebase/firestore_base_model.dart';
import 'package:sport_social_mobile_mock/models/match_statistics.dart';

enum MatchStatus {
  scheduled,
  inProgress,
  finished,
}

enum Winner {
  home,
  away,
  draw,
}

@immutable
class MatchModel implements FireStoreBaseModel {
  final String id;
  final String tournamentCode;
  final MatchStatus status;
  final dynamic startTime; // timestamp
  final String displayNameHome;
  final String displayNameAway;
  final int? scoreHome;
  final int? scoreAway;
  final String? teamHomeShieldUrl;
  final String? teamAwayShieldUrl;
  final String round;
  final Winner? winner;

  const MatchModel({
    required this.id,
    required this.tournamentCode,
    required this.status,
    required this.startTime,
    required this.displayNameHome,
    required this.displayNameAway,
    this.scoreHome,
    this.scoreAway,
    this.teamHomeShieldUrl,
    this.teamAwayShieldUrl,
    required this.round,
    this.winner,
  });

  MatchModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          tournamentCode: json['tournamentCode'],
          status: MatchStatus.values.byName(json['status']),
          startTime: json['startTime'],
          displayNameHome: json['displayNameHome'],
          displayNameAway: json['displayNameAway'],
          scoreHome: json['scoreHome'],
          scoreAway: json['scoreAway'],
          teamHomeShieldUrl: json['teamHomeShieldUrl'],
          teamAwayShieldUrl: json['teamAwayShieldUrl'],
          round: json['round'],
          winner: json['winner'] != null
              ? Winner.values.byName(json['winner'])
              : null,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentCode': tournamentCode,
      'status': status.name,
      'startTime': startTime,
      'displayNameHome': displayNameHome,
      'displayNameAway': displayNameAway,
      'scoreHome': scoreHome,
      'scoreAway': scoreAway,
      'teamHomeShieldUrl': teamHomeShieldUrl,
      'teamAwayShieldUrl': teamAwayShieldUrl,
      'round': round,
      'winner': winner?.name,
    };
  }
}

@immutable
class MatchDetailModel extends MatchModel {
  final List<MatchStatisticsModel> statistics;

  const MatchDetailModel({
    required super.id,
    required super.tournamentCode,
    required super.status,
    required super.startTime,
    required super.displayNameHome,
    required super.displayNameAway,
    super.scoreHome,
    super.scoreAway,
    super.teamHomeShieldUrl,
    super.teamAwayShieldUrl,
    required super.round,
    super.winner,
    required this.statistics,
  });

  MatchDetailModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          tournamentCode: json['tournamentCode'],
          status: MatchStatus.values.byName(json['status']),
          startTime: json['startTime'],
          displayNameHome: json['displayNameHome'],
          displayNameAway: json['displayNameAway'],
          scoreHome: json['scoreHome'],
          scoreAway: json['scoreAway'],
          teamHomeShieldUrl: json['teamHomeShieldUrl'],
          teamAwayShieldUrl: json['teamAwayShieldUrl'],
          round: json['round'],
          winner: json['winner'] != null
              ? Winner.values.byName(json['winner'])
              : null,
          statistics: json['statistics'] == null
              ? []
              : (json['statistics'] as List)
                  .map((statJson) => MatchStatisticsModel.fromJson(statJson))
                  .toList(),
        );

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['statistics'] = statistics.map((stat) => stat.toJson()).toList();
    return json;
  }
}
