import 'package:sport_social_mobile_mock/models/match_model.dart';
import 'package:sport_social_mobile_mock/models/news_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sport_social_mobile_mock/models/standings_model.dart';

class DataMockService {
  Future<DataMockService> initialize() async {
    return this;
  }

  // Use this method to populate the news list
  Future<List<NewsModel>> getNews() async {
    final String jsonString = await rootBundle.loadString('assets/news.json');
    final jsonResponse = jsonDecode(jsonString);

    final List<NewsModel> newsList = jsonResponse
        .map((standingJson) => NewsModel.fromJson(standingJson))
        .toList();

    return newsList;
  }

  // Use this method to populate the previous and next matches
  // Use the field matchDate for sorting
  // Use flutter list separatorBuilder to separate the matches by month
  Future<List<MatchModel>> getMatches() async {
    final String jsonString =
        await rootBundle.loadString('assets/matches.json');
    final jsonResponse = jsonDecode(jsonString);

    final List<MatchModel> matchesList = jsonResponse
        .map((standingJson) => MatchModel.fromJson(standingJson))
        .toList();

    return matchesList;
  }

  // Use this method to help populate the tournament checkbox and season checkbox after select a tournament
  // Use the first element as default on load
  Future<List<StandingInfoModel>> getStandingsInfo() async {
    final String jsonString =
        await rootBundle.loadString('assets/standings_info.json');
    final jsonResponse = jsonDecode(jsonString);

    final List<StandingInfoModel> standingsInfoList = jsonResponse
        .map((standingJson) => StandingInfoModel.fromJson(standingJson))
        .toList();

    return standingsInfoList;
  }

  // Use this method to populate the standing table after select the tournament and season
  Future<StandingModel> getStandingById(String id) async {
    final String jsonString =
        await rootBundle.loadString('assets/standings_info.json');
    final jsonResponse = jsonDecode(jsonString);

    final StandingModel standingModel = StandingModel.fromJson(
        jsonResponse.firstWhere((element) => element['id'] == id));

    return standingModel;
  }
}
