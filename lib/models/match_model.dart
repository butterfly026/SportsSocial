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
  final String teamHome; // team name
  final String teamHomeScode;
  final String? teamHomeShieldUrl;
  final String teamAway; // team name
  final String teamAwayScode;
  final String? teamAwayShieldUrl;
  final String round;
  final Winner winnder;

  const MatchModel({
    required this.id,
    required this.tournamentCode,
    required this.status,
    required this.startTime,
    required this.teamHome,
    required this.teamHomeScode,
    this.teamHomeShieldUrl,
    required this.teamAway,
    required this.teamAwayScode,
    this.teamAwayShieldUrl,
    required this.round,
    required this.winnder,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'],
      tournamentCode: json['tournamentCode'],
      status: MatchStatus.values.byName(json['status']),
      startTime: json['startTime'],
      teamHome: json['teamHome'],
      teamHomeScode: json['teamHomeScode'],
      teamHomeShieldUrl: json['teamHomeShieldUrl'],
      teamAway: json['teamAway'],
      teamAwayScode: json['teamAwayScode'],
      teamAwayShieldUrl: json['teamAwayShieldUrl'],
      round: json['round'],
      winnder: Winner.values.byName(json['winnder']),
    );
  }
}
