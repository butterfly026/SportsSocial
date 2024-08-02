import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sport_social_mobile_mock/models/match_commentary_model.dart';
import 'package:sport_social_mobile_mock/models/match_game_summary.dart';
import 'package:sport_social_mobile_mock/models/match_incident_model.dart';
import 'package:sport_social_mobile_mock/models/match_statistics.dart';

class LiveGameService {
  final commentaryNotifier = ValueNotifier<List<MatchCommentaryModel>>([]);
  final incidentNotifier = ValueNotifier<List<MatchIncidentModel>>([]);
  final summaryNotifier = ValueNotifier<List<MatchGameSummary>>([]);
  final statisticNotifier = ValueNotifier<List<MatchStatisticsModel>>([]);
  Future<LiveGameService> initialize() async {
    await _loadCommentary();
    await _loadSummaries();
    await _loadIncident();
    await _loadStatistic();
    return this;
  }

  Future<void> _loadCommentary() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/commentary.json');
      final jsonResponse = jsonDecode(jsonString);

      final List<MatchCommentaryModel> dataList =
          List<MatchCommentaryModel>.from(jsonResponse
              .map((jsonData) => MatchCommentaryModel.fromJson(jsonData)));
      dataList.sort((a, b) {
        return b.order > a.order
            ? 1
            : b.order == a.order
                ? 0
                : -1;
      });
      commentaryNotifier.value = dataList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _loadSummaries() async {
    try {
      final List<MatchGameSummary> dataList = [
        const MatchGameSummary(
            order: 0,
            summaryTime: 'Ends of 60 min',
            content:
                'A cagey opening at Old Trafford. Both teams cautious in the early stages. '),
        const MatchGameSummary(
            order: 1,
            summaryTime: 'Ends of 90 min',
            content: 'Both teams cautious in the early stages. '),
        const MatchGameSummary(
            order: 2,
            summaryTime: 'Ends of 60 min',
            content:
                'A cagey opening at Old Trafford. Both teams cautious in the early stages. '),
        const MatchGameSummary(
            order: 3,
            summaryTime: 'Ends of 90 min',
            content: 'Both teams cautious in the early stages. '),
        const MatchGameSummary(
            order: 4,
            summaryTime: 'Ends of 60 min',
            content:
                'A cagey opening at Old Trafford. Both teams cautious in the early stages. '),
        const MatchGameSummary(
            order: 5,
            summaryTime: 'Ends of 90 min',
            content: 'Both teams cautious in the early stages. '),
        const MatchGameSummary(
            order: 6,
            summaryTime: 'Ends of 60 min',
            content:
                'A cagey opening at Old Trafford. Both teams cautious in the early stages. '),
        const MatchGameSummary(
            order: 7,
            summaryTime: 'Ends of 90 min',
            content: 'Both teams cautious in the early stages. '),
        const MatchGameSummary(
            order: 8,
            summaryTime: 'Ends of 90 min',
            content:
                'A cagey opening at Old Trafford. Both teams cautious in the early stages. ')
      ];
      dataList.sort((a, b) {
        return b.order > a.order
            ? 1
            : b.order == a.order
                ? 0
                : -1;
      });
      summaryNotifier.value = dataList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _loadIncident() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/incidents.json');
      final jsonResponse = jsonDecode(jsonString);

      final List<MatchIncidentModel> dataList = List<MatchIncidentModel>.from(
          jsonResponse
              .map((jsonData) => MatchIncidentModel.fromJson(jsonData)));

      dataList.sort((a, b) {
        return a.order > b.order
            ? 1
            : b.order == a.order
                ? 0
                : -1;
      });
      incidentNotifier.value = dataList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _loadStatistic() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/statistics.json');
      final jsonResponse = jsonDecode(jsonString);

      final List<MatchStatisticsModel> dataList =
          List<MatchStatisticsModel>.from(jsonResponse
              .map((jsonData) => MatchStatisticsModel.fromJson(jsonData)));

      statisticNotifier.value = dataList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
