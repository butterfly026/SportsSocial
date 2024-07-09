import 'package:flutter/material.dart';
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

  Future<DataMockService> initialize() async {
    await _loadNews();
    await _loadMatches();
    await _loadStandingsInfo();
    await _loadStandings();

    return this;
  }

  // Use this method to populate the news list
  Future<void> _loadNews() async {
    final String jsonString =
        await rootBundle.loadString('lib/assets/news.json');
    final jsonResponse = jsonDecode(jsonString);

    final List<NewsModel> newsList = List<NewsModel>.from(
        jsonResponse.map((newsJson) => NewsModel.fromJson(newsJson)));

    newsNotifier.value = newsList;
  }

  Future<void> _loadMatches() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/assets/matches.json');
      final jsonResponse = jsonDecode(jsonString);

      final List<MatchModel> matchesList = List<MatchModel>.from(
          jsonResponse.map((matchJson) => MatchModel.fromJson(matchJson)));

      // matchesList.sort((a, b) => a.startTime.compareTo(b.startTime));

      matchesNotifier.value = matchesList;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadStandingsInfo() async {
    final String jsonString =
        await rootBundle.loadString('lib/assets/standing_info.json');
    final jsonResponse = jsonDecode(jsonString);

    final standingsInfoList = List<StandingInfoModel>.from(jsonResponse.map(
        (standingInfoJson) => StandingInfoModel.fromJson(standingInfoJson)));

    standingsInfoNotifier.value = standingsInfoList;
  }

  Future<void> _loadStandings() async {
    final String jsonString =
        await rootBundle.loadString('lib/assets/standings.json');
    final jsonResponse = jsonDecode(jsonString);

    final List<StandingModel> standingList = List<StandingModel>.from(
        jsonResponse
            .map((standingJson) => StandingModel.fromJson(standingJson)));

    standingsNotifier.value = standingList;
  }

  // Use this method to populate the standing table after select the tournament and season
  Future<StandingModel> getStandingBySeasonId(String seasonId) async {
    final StandingModel standingModel = standingsNotifier.value.firstWhere(
      (element) => element.id == seasonId,
      orElse: () => standingsNotifier.value.first,
    );

    return standingModel;
  }
}
