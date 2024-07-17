import 'package:flutter/foundation.dart';
import 'package:sport_social_mobile_mock/models/match_model.dart';
import 'package:sport_social_mobile_mock/models/news_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sport_social_mobile_mock/models/standings_model.dart';

class DataMockService {
  final newsNotifier = ValueNotifier<List<NewsModel>>([]);

  // Use this method to populate the previous and next matches
  // Use the field matchDate for sorting
  // Use flutter list separatorBuilder to separate the matches by month
  final matchesNotifier = ValueNotifier<List<MatchModel>>([]);

  // Use this method to help populate the tournament checkbox and season checkbox after select a tournament
  // Use the first element as default on load
  final standingsInfoNotifier = ValueNotifier<List<StandingInfoModel>>([]);
  final standingsNotifier = ValueNotifier<List<StandingModel>>([]);
  final filteredStandingsNotifier = ValueNotifier<List<StandingModel>>([]);

  Future<DataMockService> initialize() async {
    await _loadNews();
    await _loadMatches();
    await _loadStandingsInfo();
    await _loadStandings();

    return this;
  }

  // Use this method to populate the news list
  Future<void> _loadNews() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/news_smaller.json');
      final jsonResponse = jsonDecode(jsonString);

      final List<NewsModel> newsList = List<NewsModel>.from(
          jsonResponse.map((newsJson) => NewsModel.fromJson(newsJson)));

      newsNotifier.value = newsList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _loadMatches() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/matches.json');
      final jsonResponse = jsonDecode(jsonString);

      List<MatchModel> matchesList = List<MatchModel>.from(
          jsonResponse.map((matchJson) => MatchModel.fromJson(matchJson)));
      matchesList = matchesList
          .where((match) =>
              match.displayNameAway == 'Italy' ||
              match.displayNameHome == 'Italy')
          .toList();
      // matchesList.sort((a, b) => a.startTime.compareTo(b.startTime));
      matchesList.sort((a, b) {
        if (a.startTime == null && b.startTime == null) return 0;
        if (a.startTime == null) return 1;
        if (b.startTime == null) return -1;
        return b.startTime.compareTo(a.startTime);
      });
      matchesNotifier.value = matchesList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _loadStandingsInfo() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/standing_info.json');
      final jsonResponse = jsonDecode(jsonString);

      final standingsInfoList = List<StandingInfoModel>.from(jsonResponse.map(
          (standingInfoJson) => StandingInfoModel.fromJson(standingInfoJson)));

      standingsInfoNotifier.value = standingsInfoList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _loadStandings() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/standings.json');
      final jsonResponse = jsonDecode(jsonString);

      final List<StandingModel> standingList = List<StandingModel>.from(
          jsonResponse
              .map((standingJson) => StandingModel.fromJson(standingJson)));

      standingsNotifier.value = standingList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Use this method to populate the standing table after select the tournament and season
  void getStandingBySeasonId(String seasonId) {
    if (seasonId.isEmpty) {
      filteredStandingsNotifier.value = [];
    } else {
      List<StandingModel> filteredStandings = standingsNotifier.value
          .where(
            (element) => element.id == seasonId,
          )
          .toList();
      filteredStandingsNotifier.value = filteredStandings;
    }
  }
}
