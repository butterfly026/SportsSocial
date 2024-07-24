import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/firebase/firestore_base_model.dart';

enum MatchgStatisticsType {
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
class MatchgStatisticsModel implements FireStoreBaseModel {
  final String valueHome;
  final String valueAway;
  final String displayName;
  final MatchgStatisticsType type;

  const MatchgStatisticsModel({
    required this.valueHome,
    required this.valueAway,
    required this.displayName,
    required this.type,
  });

  MatchgStatisticsModel.fromJson(Map<String, dynamic> json)
      : this(
          valueHome: json['valueHome'],
          valueAway: json['valueAway'],
          displayName: json['displayName'],
          type: MatchgStatisticsType.values.byName(json['type'].toLowerCase()),
        );

  @override
  Map<String, dynamic> toJson() => {
        'valueHome': valueHome,
        'valueAway': valueAway,
        'displayName': displayName,
        'type': type.toString().split('.').last,
      };
}
