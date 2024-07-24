import 'package:flutter/material.dart';

enum MatchIncidentStageType { firstHalf, secondHalf, extraTime, penalty }

enum MatchIncidentType {
  goal,
  ownGoal,
  assistance,
  redCard,
  yellowCard,
  substitutionOut,
  substitutionIn,
  penaltyScored,
  penaltyMissed,
}

enum MatchIncidentSideType {
  home,
  away,
}

@immutable
class MatchIncidentModel {
  final String incidentTime;
  final String participant;
  final MatchIncidentStageType stage;
  final MatchIncidentType type;
  final MatchIncidentSideType side;
  final int order;

  const MatchIncidentModel({
    required this.incidentTime,
    required this.participant,
    required this.stage,
    required this.type,
    required this.side,
    required this.order,
  });

  MatchIncidentModel.fromJson(Map<String, dynamic> json)
      : this(
          incidentTime: json['incidentTime'],
          participant: json['participant'],
          stage: MatchIncidentStageType.values.byName(json['stage']),
          type: MatchIncidentType.values.byName(json['type']),
          side: MatchIncidentSideType.values.byName(json['side']),
          order: json['order'],
        );

  Map<String, dynamic> toJson() => {
        'incidentTime': incidentTime,
        'participant': participant,
        'stage': stage.toString().split('.').last,
        'type': type.toString().split('.').last,
        'side': side.toString().split('.').last,
        'order': order,
      };
}
