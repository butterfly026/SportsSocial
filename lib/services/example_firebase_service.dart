import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_social_mobile_mock/firebase/firebase_utils.dart';
import 'package:sport_social_mobile_mock/models/channel_model.dart';
import 'package:sport_social_mobile_mock/models/match_commentary_model.dart';
import 'package:sport_social_mobile_mock/models/match_incident_model.dart';
import 'package:sport_social_mobile_mock/models/match_model.dart';
import 'package:sport_social_mobile_mock/models/match_statistics.dart';

class ExampleFirebaseService {
  final String _channelColelction = 'channels';
  final String _matchesChannelSubCollection = 'matches';

  final String _matchCollection = 'matches';
  final String _commentsSubCollection = 'commentaries';
  final String _incidentsSubCollection = 'incidents';

  final String _channelId = 'Nqm7dwogKL7VhSBBhphw';
  final String _matchId = 'team_1_fc_team_2_fc_1111';

  CollectionReference<ChannelModel> get _channelRef =>
      collectionRefWithConverter<ChannelModel>(
        _channelColelction,
        ChannelModel.fromJson,
      );

  CollectionReference<MatchModel> _channelMatchRef(String channelId) =>
      subCollectionRefWithConverter<MatchModel>(
        '$_channelColelction/$channelId/$_matchesChannelSubCollection',
        MatchModel.fromJson,
      );

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

  Future<ExampleFirebaseService> initialize() async {
    return this;
  }

  Timer? _timer;
  int updateInterval = 10; // interval to update match data
  final maxRuntime = const Duration(minutes: 5); // safeguard

  final Random _random = Random();
  int commentaryOrder = 0;
  int incidentOrder = 0;
  final List<String> _possibleCommentaries = [
    "Great goal by the home team!",
    "What a save by the goalkeeper!",
    "The away team is pressing hard.",
    "A fantastic display of skill!",
    "The match is heating up!",
    "A controversial decision by the referee.",
    "The crowd is going wild!",
    "A tactical substitution by the coach.",
    "An unexpected turn of events!",
    "The defense is holding strong."
  ];

  final List<MatchCommentaryType> _possibleCommentariesTypes =
      MatchCommentaryType.values;
  final List<MatchIncidentType> _possibleIncidentsTypes =
      MatchIncidentType.values;
  final List<MatchIncidentStageType> _possibleIncidentsStageTypes =
      MatchIncidentStageType.values;
  final List<MatchIncidentSideType> _possibleIncidentsSideTypes =
      MatchIncidentSideType.values;

  Future<ChannelModel?> getChannel() async {
    final DocumentSnapshot<ChannelModel> snapshot =
        await _channelRef.doc(_channelId).get();
    return snapshot.data();
  }

  Future<void> startMatch() async {
    print('Starting match...');

    // clean up
    await cleanUpMatch();

    final startTime = DateTime.now();
    // random update every $updateInterval seconds:
    _timer = Timer.periodic(Duration(seconds: updateInterval), (timer) async {
      final elapsedTime = DateTime.now().difference(startTime);
      if (elapsedTime > maxRuntime) {
        timer.cancel();
        print('Timer canceled after exceeding maximum runtime.');
        return;
      }
      print('Updating match info...');
      await updateMatchScore();
      await updateMatchCommentary();
      await updateMatchStatistics();
      await updateMatchIncidents();
      print('Match info updated');
    });
  }

  Future<void> updateMatchScore() async {
    final int scoreAway = _random.nextInt(11);
    final int scoreHome = _random.nextInt(11);

    final matchUpdate = {
      'scoreAway': scoreAway,
      'scoreHome': scoreHome,
      'status': 'inProgress',
      'winner': null,
    };

    await _channelMatchRef(_channelId).doc(_matchId).update(matchUpdate);
    await _matchesRef.doc(_matchId).update(matchUpdate);
  }

  Future<void> updateMatchCommentary() async {
    final int level = _random.nextInt(3);
    final String message =
        _possibleCommentaries[_random.nextInt(_possibleCommentaries.length)];
    final MatchCommentaryType type = _possibleCommentariesTypes[
        _random.nextInt(_possibleCommentariesTypes.length)];

    final randomCommentary = MatchCommentaryModel(
      level: level,
      message: message,
      time: '10',
      type: type,
      hash: 'hash',
      order: commentaryOrder++,
    );

    await _commentariesRef(_matchId).add(randomCommentary);
  }

  Future<void> updateMatchStatistics() async {
    final statistics = [];

    for (var type in MatchStatisticsType.values) {
      final valueHome = _random.nextInt(100).toString();
      final valueAway = _random.nextInt(100).toString();
      final displayName = type.toString();

      statistics.add(
        MatchStatisticsModel(
          valueHome: valueHome,
          valueAway: valueAway,
          displayName: displayName,
          type: type,
        ).toJson(),
      );
    }

    await _matchesRef.doc(_matchId).update({'statistics': statistics});
  }

  Future<void> updateMatchIncidents() async {
    final MatchIncidentStageType stage = _possibleIncidentsStageTypes[
        _random.nextInt(_possibleIncidentsStageTypes.length)];

    final MatchIncidentType type = _possibleIncidentsTypes[
        _random.nextInt(_possibleIncidentsTypes.length)];

    final MatchIncidentSideType side = _possibleIncidentsSideTypes[
        _random.nextInt(_possibleIncidentsSideTypes.length)];

    final incident = MatchIncidentModel(
      incidentTime: incidentOrder.toString(),
      participant: 'participant $incidentOrder',
      stage: stage,
      type: type,
      side: side,
      order: incidentOrder++,
    );

    await _incidentsRef(_matchId).add(incident);
  }

  Future<void> cleanUpMatch() async {
    print('Cleaning up match...');
    _timer?.cancel();

    commentaryOrder = 0;

    final matchCleanUp = {
      'scoreAway': 0,
      'scoreHome': 0,
      'status': 'scheduled',
      'winner': null,
    };

    await _channelMatchRef(_channelId).doc(_matchId).update(matchCleanUp);
    await _matchesRef.doc(_matchId).update({...matchCleanUp, 'statistics': []});

    await _commentariesRef(_matchId).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    await _incidentsRef(_matchId).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    print('Match cleaned up');
  }
}
