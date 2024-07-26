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
  final String _statsSubCollection = 'statistics';
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

  CollectionReference<MatchModel> get _matchesRef =>
      collectionRefWithConverter<MatchModel>(
        _matchCollection,
        MatchModel.fromJson,
      );

  CollectionReference<MatchCommentaryModel> _commentariesRef(String matchId) =>
      subCollectionRefWithConverter<MatchCommentaryModel>(
        '$_matchCollection/$matchId/$_commentsSubCollection',
        MatchCommentaryModel.fromJson,
      );

  CollectionReference<MatchStatisticsModel> _statisticsRef(String matchId) =>
      subCollectionRefWithConverter<MatchStatisticsModel>(
        '$_matchCollection/$matchId/$_statsSubCollection',
        MatchStatisticsModel.fromJson,
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
  final Random _random = Random();
  int commentaryOrder = 0;
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

  final List<MatchCommentaryType> _possibleCommentariesTypes = [
    MatchCommentaryType.defaultType,
    MatchCommentaryType.whistle,
    MatchCommentaryType.time,
    MatchCommentaryType.corner,
    MatchCommentaryType.substitution,
    MatchCommentaryType.goal,
    MatchCommentaryType.goalAgainst,
    MatchCommentaryType.yellowCard,
    MatchCommentaryType.yellowRedCard,
    MatchCommentaryType.redCard,
    MatchCommentaryType.funfact,
    MatchCommentaryType.lineup,
    MatchCommentaryType.injury,
    MatchCommentaryType.penaltyOut,
    MatchCommentaryType.penalty,
    MatchCommentaryType.varType,
    MatchCommentaryType.attendance,
  ];

  Future<ChannelModel?> getChannel() async {
    final DocumentSnapshot<ChannelModel> snapshot =
        await _channelRef.doc(_channelId).get();
    return snapshot.data();
  }

  Future<void> startMatch() async {
    // clean up
    await cleanUpMatch();

    // random update every 10 seconds:
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await updateMatchScore();
      await updateMatchCommentary();
      // await updateMatchStatistics();
      // await updateMatchIncidents();
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

  // Future<void> updateMatchStatistics() async {
  //   final int possessionAway = _random.nextInt(101);
  //   final int possessionHome = 100 - possessionAway;

  //   final int shotsAway = _random.nextInt(21);
  //   final int shotsHome = _random.nextInt(21);

  //   final int shotsOnTargetAway = _random.nextInt(shotsAway + 1);
  //   final int shotsOnTargetHome = _random.nextInt(shotsHome + 1);

  //   final int foulsAway = _random.nextInt(21);
  //   final int foulsHome = _random.nextInt(21);

  //   final int cornersAway = _random.nextInt(11);
  //   final int cornersHome = _random.nextInt(11);

  //   final int offsidesAway = _random.nextInt(6);
  //   final int offsidesHome = _random.nextInt(6);

  //   final int yellowCardsAway = _random.nextInt(6);
  //   final int yellowCardsHome = _random.nextInt(6);

  //   final int redCardsAway = _random.nextInt(3);
  //   final int redCardsHome = _random.nextInt(3);

  //   final int savesAway = _random.nextInt(6);
  //   final int savesHome = _random.nextInt(6);

  // }

  Future<void> cleanUpMatch() async {
    _timer?.cancel();

    commentaryOrder = 0;

    final matchCleanUp = {
      'scoreAway': 0,
      'scoreHome': 0,
      'status': 'scheduled',
      'winner': null,
    };

    await _channelMatchRef(_channelId).doc(_matchId).update(matchCleanUp);
    await _matchesRef.doc(_matchId).update(matchCleanUp);

    await _commentariesRef(_matchId).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    await _statisticsRef(_matchId).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    await _incidentsRef(_matchId).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
