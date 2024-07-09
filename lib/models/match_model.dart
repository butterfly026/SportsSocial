import 'package:flutter/material.dart';

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
class MatchModel {
  final String id;
  final String tournamentCode;
  final MatchStatus status;
  final dynamic startTime; // timestamp
  final String displayNameHome;
  final String displayNameAway;
  final String? scoreHome;
  final String? scoreAway;
  final String? teamHomeShieldUrl;
  final String? teamAwayShieldUrl;
  final String? round;
  final Winner winner;

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
    this.round,
    required this.winner,
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
          winner: Winner.values.byName(json['winner']),
        );
}
