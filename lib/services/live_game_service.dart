import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sport_social_mobile_mock/firebase/firebase_utils.dart';
import 'package:sport_social_mobile_mock/models/match_commentary_model.dart';
import 'package:sport_social_mobile_mock/models/match_game_summary.dart';
import 'package:sport_social_mobile_mock/models/match_incident_model.dart';
import 'package:sport_social_mobile_mock/models/match_model.dart';
import 'package:sport_social_mobile_mock/models/match_statistics.dart';

class LiveGameService {
  final commentaryNotifier = ValueNotifier<List<MatchCommentaryModel>>([]);
  final incidentNotifier = ValueNotifier<List<MatchIncidentModel>>([]);
  final summaryNotifier = ValueNotifier<List<MatchGameSummary>>([]);
  final statisticNotifier = ValueNotifier<List<MatchStatisticsModel>>([]);

  final String _matchId = 'team_1_fc_team_2_fc_1111';

  final String _matchCollection = 'matches';
  final String _commentsSubCollection = 'commentaries';
  final String _incidentsSubCollection = 'incidents';
  final String _gameSummarySubCollection = 'summaries';

  CollectionReference<MatchDetailModel> get _matchesRef =>
      collectionRefWithConverter<MatchDetailModel>(
        _matchCollection,
        MatchDetailModel.fromJson,
      );

  CollectionReference<MatchCommentaryModel> _commentariesRef(String matchId) =>
      subCollectionRefWithConverter<MatchCommentaryModel>(
        '$_matchCollection/$matchId/$_commentsSubCollection',
        MatchCommentaryModel.fromJson,
      );

  CollectionReference<MatchIncidentModel> _incidentsRef(String matchId) =>
      subCollectionRefWithConverter<MatchIncidentModel>(
        '$_matchCollection/$matchId/$_incidentsSubCollection',
        MatchIncidentModel.fromJson,
      );

  CollectionReference<MatchGameSummary> _summariessRef(String matchId) =>
      subCollectionRefWithConverter<MatchGameSummary>(
        '$_matchCollection/$matchId/$_gameSummarySubCollection',
        MatchGameSummary.fromJson,
      );

  Future<LiveGameService> initialize() async {
    _startListeningToCommentaries();
    _startListeningToIncidents();
    _startListeningToSummaries();
    _startListeningToStatistics();
    return this;
  }

  void _startListeningToCommentaries() {
    _commentariesRef(_matchId).orderBy('order', descending: true).snapshots().listen((snapshot) {
      final commentaries = snapshot.docs.map((doc) => doc.data()).toList();
      commentaryNotifier.value = commentaries;
    }, onError: (error) {
      if (kDebugMode) {
        print('Error listening to commentaries: $error');
      }
    });
  }

  void _startListeningToIncidents() {
    _incidentsRef(_matchId).orderBy('order', descending: true).snapshots().listen((snapshot) {
      final incidents = snapshot.docs.map((doc) => doc.data()).toList();
      incidentNotifier.value = incidents;
    }, onError: (error) {
      if (kDebugMode) {
        print('Error listening to incidents: $error');
      }
    });
  }

  void _startListeningToSummaries() {
    _summariessRef(_matchId).orderBy('order', descending: true).snapshots().listen((snapshot) {
      final summaries = snapshot.docs.map((doc) => doc.data()).toList();
      summaryNotifier.value = summaries;
    }, onError: (error) {
      if (kDebugMode) {
        print('Error listening to summaries: $error');
      }
    });
  }

  void _startListeningToStatistics() {
    _matchesRef.doc(_matchId).snapshots().listen((snapshot) {
      statisticNotifier.value = snapshot.data()?.statistics ?? [];
    }, onError: (error) {
      if (kDebugMode) {
        print('Error listening to statistics: $error');
      }
    });
  }
}
