import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/match_game_summary.dart';
import 'package:sport_social_mobile_mock/services/live_game_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';

class GameSummaryWidget extends StatefulWidget {
  final int expandMode;
  const GameSummaryWidget({super.key, required this.expandMode});

  @override
  GameSummaryWidgetState createState() => GameSummaryWidgetState();
}

class GameSummaryWidgetState extends State<GameSummaryWidget> {
  final dataMockService = ServiceLocator.get<LiveGameService>();

  @override
  void initState() {
    super.initState();
  }

  Widget _getCommentaryItem(MatchGameSummary summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: RichText(
        text: TextSpan(
          style:
              const TextStyle(fontSize: 16.0, color: Colors.white, height: 1.5),
          children: <TextSpan>[
            TextSpan(
                text: summary.summaryTime,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const TextSpan(text: ' '),
            TextSpan(text: summary.content),
          ],
        ),
      ),
    );
  }

  Widget _getSummaryList(List<MatchGameSummary> lstData) {
    return ListView.builder(
        itemCount: lstData.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return _getCommentaryItem(lstData[index]);
        });
  }

  Widget _getIncidents() {
    return Text('Text');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dataMockService.summaryNotifier,
        builder: (context, commentaries, child) {
          return ValueListenableBuilder(
              valueListenable: dataMockService.incidentNotifier,
              builder: (context, incidents, child) {
                List<MatchGameSummary> lstData = [];
                int len = commentaries.length;
                if (widget.expandMode == 0) {
                  lstData = commentaries.sublist(0, len > 4 ? 4 : len);
                } else {
                  lstData = commentaries;
                }
                if (widget.expandMode == 0) {
                  return _getSummaryList(lstData);
                } else {
                  return Column(
                    children: [
                      _getIncidents(),
                      Expanded(
                        child: _getSummaryList(lstData),
                      )
                    ],
                  );
                }
              });
        });
  }
}
