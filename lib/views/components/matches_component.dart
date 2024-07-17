import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/match_model.dart';
import 'package:sport_social_mobile_mock/services/data_mock_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';
import 'package:sport_social_mobile_mock/utils/date_utils.dart' as date_utils;
import 'package:sport_social_mobile_mock/views/components/circle_painter.dart';

class MatchesWidget extends StatelessWidget {
  MatchesWidget({super.key});

  final dataMockService = ServiceLocator.get<DataMockService>();
  final String favTeamName = 'Italy';
  final TextStyle txtStyleBody2 =
      const TextStyle(fontSize: 12, letterSpacing: 0.2, color: Colors.white);

  Widget _matchMonthName(MatchModel match, MatchModel? previousMatch) {
    bool isDispMonth = false;
    String startTime = date_utils.dateFromMilisecond(match.startTime);
    String eventMonthName = date_utils.getFormattedDate(startTime, 'MMMM yyyy');
    if (previousMatch == null) {
      isDispMonth = true;
    } else {
      String? prevMatchMonthName = date_utils.getFormattedDate(
          date_utils.dateFromMilisecond(previousMatch.startTime), 'MMMM yyyy');
      if (eventMonthName != prevMatchMonthName) {
        isDispMonth = true;
      }
    }
    if (isDispMonth) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Text(eventMonthName,
            style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      );
    } else {
      return const SizedBox(height: 12);
    }
  }

  Widget _matchDate(MatchModel match) {
    String startTime = date_utils.dateFromMilisecond(match.startTime);
    String weekday = date_utils.getWeekday(startTime);
    String day = date_utils.getDay(startTime);
    return SizedBox(
      width: 28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(day, style: txtStyleBody2),
          const SizedBox(height: 2),
          Text(weekday,
              style: txtStyleBody2.copyWith(color: const Color(0xFF5F5E69)))
        ],
      ),
    );
  }

  Widget _tournamentCode(MatchModel match) {
    return SizedBox(
      width: 78,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(match.tournamentCode,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.0, color: Colors.white))
        ],
      ),
    );
  }

  Widget _teamBadge(String? badgeUrl) {
    return CachedNetworkImage(
        imageUrl: badgeUrl ?? '',
        width: 14.0,
        height: 14.0,
        placeholder: (context, url) => const SizedBox(
              width: 12.0,
              height: 12.0,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                ),
              ),
            ),
        errorWidget: (context, url, error) {
          return const SizedBox(
              width: 12.0,
              height: 12.0,
              child: Center(
                child: Icon(Icons.error, color: Colors.grey, size: 14.0),
              ));
        });
  }

  Widget _teamName(String teamName) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(teamName,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: -0.04,
                color: Colors.white)),
      ],
    ));
  }

  Widget _teamBadgeAndName(String? badgeUrl, String teamName) {
    return Row(
      children: [
        _teamBadge(badgeUrl),
        const SizedBox(width: 8),
        _teamName(teamName),
      ],
    );
  }

  Widget _getMatchTeamInfo(MatchModel match) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _teamBadgeAndName(match.teamHomeShieldUrl, match.displayNameHome),
          const SizedBox(height: 2),
          _teamBadgeAndName(match.teamAwayShieldUrl, match.displayNameAway),
        ],
      ),
    );
  }

  Widget _getMatchScore(MatchModel match) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Text(match.scoreHome.toString(),
              style: txtStyleBody2.copyWith(fontSize: 12)),
          Text(match.scoreAway.toString(),
              style: txtStyleBody2.copyWith(fontSize: 12))
        ],
      ),
    );
  }

  Widget _getFavoriteMark(Color favColor, String favStr) {
    return SizedBox(
      width: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(20, 20), // Set the size of the CustomPaint
            painter: CirclePainter(
              radius: 20 / 2, // Set the radius of the circle
              color: favColor, // Set the color of the circle
            ),
          ),
          Text(favStr,
              style: txtStyleBody2.copyWith(color: const Color(0xFF15182C))),
        ],
      ),
    );
  }

  Widget _getMatchTimeOrResult(MatchModel match) {
    String formattedTime =
        date_utils.formatTime(date_utils.dateFromMilisecond(match.startTime));
    List<Color> favColors = [
      const Color(0xFF8BC34A),
      const Color(0xFFE57373),
      const Color(0xFF2296F3)
    ];
    List<String> favStrs = ['W', 'L', 'D'];
    Color favColor = favColors[0];
    String favStr = favStrs[0];
    if (match.scoreHome == match.scoreAway) {
      favColor = favColors[2];
      favStr = favStrs[2];
    } else {
      int nFavIdx = 0;
      if (match.displayNameHome == favTeamName) {
        if (match.scoreHome! > match.scoreAway!) {
          nFavIdx = 0;
        } else if (match.scoreHome! < match.scoreAway!) {
          nFavIdx = 1;
        }
      } else if (match.displayNameAway == favTeamName) {
        if (match.scoreAway! > match.scoreHome!) {
          nFavIdx = 0;
        } else if (match.scoreAway! < match.scoreHome!) {
          nFavIdx = 1;
        }
      }
      favColor = favColors[nFavIdx];
      favStr = favStrs[nFavIdx];
    }
    return Row(
      children: [
        if (match.status == MatchStatus.finished) _getMatchScore(match),
        if (match.status == MatchStatus.finished)
          _getFavoriteMark(favColor, favStr),
        if (match.status == MatchStatus.scheduled)
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Text(formattedTime, style: txtStyleBody2)],
            ),
          ),
      ],
    );
  }

  Widget _matchItemWidget(MatchModel match, MatchModel? previousMatch) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _matchMonthName(match, previousMatch),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _matchDate(match),
            _tournamentCode(match),
            _getMatchTeamInfo(match),
            _getMatchTimeOrResult(match),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ValueListenableBuilder(
          valueListenable: dataMockService.matchesNotifier,
          builder: (context, matches, child) {
            return ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                MatchModel matchItem = matches[index];
                return _matchItemWidget(
                    matchItem, index > 0 ? matches[index - 1] : null);
              },
            );
          },
        ));
  }
}
