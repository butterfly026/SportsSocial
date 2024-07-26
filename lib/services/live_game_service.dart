import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sport_social_mobile_mock/models/match_commentary_model.dart';
import 'package:sport_social_mobile_mock/models/match_incident_model.dart';
import 'package:sport_social_mobile_mock/models/match_statistics.dart';

class LiveGameService {
  final commentaryNotifier = ValueNotifier<List<MatchgCommentaryModel>>([]);
  final incidentNotifier = ValueNotifier<List<MatchIncidentModel>>([]);
  final statisticsNotifier = ValueNotifier<List<MatchgStatisticsModel>>([]);
  Future<LiveGameService> initialize() async {
    await _loadCommentary();
    await _loadIncident();
    await _loadStatistic();
    return this;
  }

  Future<void> _loadCommentary() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/commentary.json');
      final jsonResponse = jsonDecode(jsonString);

      final List<MatchgCommentaryModel> dataList =
          List<MatchgCommentaryModel>.from(jsonResponse
              .map((jsonData) => MatchgCommentaryModel.fromJson(jsonData)));
      dataList.sort((a, b) {
        if (a.time.isEmpty && b.time.isEmpty) return 0;
        if (a.time.isEmpty) return 1;
        if (b.time.isEmpty) return -1;
        int n1 = int.tryParse(b.time) ?? 0;
        int n2 = int.tryParse(a.time) ?? 0;
        if (n1 == 0 && n2 == 0) return 0;
        return n1 > n2 ? 1 : -1;
      });
      commentaryNotifier.value = dataList;
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

      final List<MatchgStatisticsModel> dataList =
          List<MatchgStatisticsModel>.from(jsonResponse
              .map((jsonData) => MatchgStatisticsModel.fromJson(jsonData)));

      statisticsNotifier.value = dataList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
