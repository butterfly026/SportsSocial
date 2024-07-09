import 'package:flutter/material.dart';

@immutable
class StandingSeasonInfoModel {
  final String id;
  final String yearTitle;
  final int year;

  const StandingSeasonInfoModel({
    required this.id,
    required this.yearTitle,
    required this.year,
  });

  factory StandingSeasonInfoModel.fromJson(Map<String, dynamic> json) {
    return StandingSeasonInfoModel(
      id: json['id'],
      yearTitle: json['yearTitle'],
      year: json['year'],
    );
  }
}

@immutable
class StandingInfoModel {
  final String name;
  final List<StandingSeasonInfoModel> seasons;

  const StandingInfoModel({
    required this.name,
    required this.seasons,
  });

  factory StandingInfoModel.fromJson(Map<String, dynamic> json) {
    return StandingInfoModel(
      name: json['name'],
      seasons: (json['seasons'] as List)
          .map((e) => StandingSeasonInfoModel.fromJson(e))
          .toList(),
    );
  }
}

@immutable
class StandingRowModel {
  final String teamDisplayName;
  final String? teamHomeShieldUrl;
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int points;
  final String form;

  const StandingRowModel({
    required this.teamDisplayName,
    this.teamHomeShieldUrl,
    required this.matchesPlayed,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
    required this.form,
  });

  StandingRowModel.fromJson(Map<String, dynamic> json)
      : this(
          teamDisplayName: json['teamDisplayName'],
          teamHomeShieldUrl: json['teamHomeShieldUrl'],
          matchesPlayed: json['matchesPlayed'],
          wins: json['wins'],
          draws: json['draws'],
          losses: json['losses'],
          goalsFor: json['goalsFor'],
          goalsAgainst: json['goalsAgainst'],
          points: json['points'],
          form: json['form'],
        );

  Map<String, dynamic> toJson() {
    return {
      'teamDisplayName': teamDisplayName,
      'teamHomeShieldUrl': teamHomeShieldUrl,
      'matchesPlayed': matchesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'points': points,
      'form': form,
    };
  }
}

@immutable
class StandingModel {
  final String id;
  final String name;
  final String? group;
  final String? seasonShieldUrl;
  final List<StandingRowModel> rows;

  const StandingModel({
    required this.id,
    required this.name,
    this.group,
    this.seasonShieldUrl,
    required this.rows,
  });

  StandingModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['name'],
          group: json['group'],
          seasonShieldUrl: json['seasonShieldUrl'],
          rows: (json['rows'] as List)
              .map((e) => StandingRowModel.fromJson(e))
              .toList(),
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'group': group,
      'seasonShieldUrl': seasonShieldUrl,
      'rows': rows.map((e) => e.toJson()).toList(),
    };
  }
}
