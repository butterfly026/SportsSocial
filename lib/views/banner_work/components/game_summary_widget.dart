import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/match_game_summary.dart';
import 'package:sport_social_mobile_mock/services/live_game_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/incidents_timeline.dart';

class GameSummaryWidget extends StatefulWidget {
  final bool expanded;
  const GameSummaryWidget({super.key, required this.expanded});

  @override
  GameSummaryWidgetState createState() => GameSummaryWidgetState();
}

class GameSummaryWidgetState extends State<GameSummaryWidget> {
  final dataMockService = ServiceLocator.get<LiveGameService>();
  final TextStyle _textStyle = const TextStyle(
      fontSize: 12.0,
      color: Colors.white,
      height: 1.5,
      fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
  }

  Widget _summaryItem(MatchGameSummary summary) {
    if (widget.expanded) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF606580), width: 1.0),
              borderRadius: BorderRadius.circular(3.0)),
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(summary.summaryTime, style: _textStyle)],
                ),
              ),
              Expanded(
                child: Text(summary.content, style: _textStyle),
              ),
            ],
          ));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
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
      itemBuilder: (context, index) => _summaryItem(lstData[index]),
    );
  }

  Widget _getCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
      child: Text(
        title,
        style: _textStyle,
      ),
    );
  }

  Widget _getNotAvailableWidget(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dataMockService.summaryNotifier,
        builder: (context, summaries, child) {
          return ValueListenableBuilder(
              valueListenable: dataMockService.incidentNotifier,
              builder: (context, incidents, child) {
                if (!widget.expanded) {
                  if (summaries.isEmpty) {
                    return _getNotAvailableWidget('Summaries not available');
                  }
                  return Center(child: _summaryItem(summaries[0]));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _getCategoryTitle('Match Timeline'),
                      incidents.isNotEmpty
                          ? IncidentsTimeline(incidents: incidents)
                          : _getNotAvailableWidget('Timeline not available'),
                      _getCategoryTitle('Summary'),
                      summaries.isNotEmpty
                          ? Expanded(child: _getSummaryList(summaries))
                          : _getNotAvailableWidget('Summaries not available')
                    ],
                  );
                }
              });
        });
  }
}
