import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/firebase/firestore_base_model.dart';

enum MatchStatisticsType {
  ballPossession,
  goalAttempts,
  shotsOnGoal,
  shotsOffGoal,
  blockedShots,
  freeKicks,
  cornerKicks,
  offsides,
  throwIns,
  goalkeeperSaves,
  fouls,
  yellowCards,
  completedPasses,
  totalPasses,
  attacks,
  dangerousAttacks,
}

@immutable
class MatchStatisticsModel implements FireStoreBaseModel {
  final String valueHome;
  final String valueAway;
  final String displayName;
  final MatchStatisticsType type;

  const MatchStatisticsModel({
    required this.valueHome,
    required this.valueAway,
    required this.displayName,
    required this.type,
  });

  MatchStatisticsModel.fromJson(Map<String, dynamic> json)
      : this(
          valueHome: json['valueHome'],
          valueAway: json['valueAway'],
          displayName: json['displayName'],
          type: MatchStatisticsType.values.byName(json['type']),
        );

  @override
  Map<String, dynamic> toJson() => {
        'valueHome': valueHome,
        'valueAway': valueAway,
        'displayName': displayName,
        'type': type.toString().split('.').last,
      };
}
