import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/match_game_summary.dart';
import 'package:sport_social_mobile_mock/models/match_incident_model.dart';
import 'package:sport_social_mobile_mock/services/live_game_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';
import 'package:sport_social_mobile_mock/views/banner_work/banner_work_page.dart';

class GameSummaryWidget extends StatefulWidget {
  final int expandMode;
  const GameSummaryWidget({super.key, required this.expandMode});

  @override
  GameSummaryWidgetState createState() => GameSummaryWidgetState();
}

class GameSummaryWidgetState extends State<GameSummaryWidget> {
  final dataMockService = ServiceLocator.get<LiveGameService>();
  TextStyle textStyle = const TextStyle(
      fontSize: 12.0,
      color: Colors.white,
      height: 1.5,
      fontWeight: FontWeight.bold);
  double defaultWidthPerIncident = 60;
  @override
  void initState() {
    super.initState();
  }

  Widget _getCommentaryItem(MatchGameSummary summary) {
    if (widget.expandMode == 1) {
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
                  children: [Text(summary.summaryTime, style: textStyle)],
                ),
              ),
              Expanded(
                child: Text(summary.content, style: textStyle),
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
        itemBuilder: (context, index) {
          return _getCommentaryItem(lstData[index]);
        });
  }

  List<String> getIncidentTimes(List<MatchIncidentModel> lstIncidents) {
    List<String> incidentTimes = [];
    for (var incident in lstIncidents) {
      if (!incidentTimes.contains(incident.incidentTime)) {
        if (incident.stage == MatchIncidentStageType.firstHalf &&
            !incidentTimes.contains('KO')) {
          incidentTimes.add('KO');
        } else if (incident.stage == MatchIncidentStageType.secondHalf &&
            !incidentTimes.contains('HT')) {
          incidentTimes.add('HT');
        } else if (incident.stage == MatchIncidentStageType.extraTime &&
            !incidentTimes.contains('ET')) {
          incidentTimes.add('ET');
        } else if (incident.stage == MatchIncidentStageType.penalty &&
            !incidentTimes.contains('PT')) {
          incidentTimes.add('PT');
        }
        incidentTimes.add(incident.incidentTime);
      }
    }
    return incidentTimes;
  }

  List<MatchIncidentModel> getSideIncidents(
      List<MatchIncidentModel> lstIncidents, MatchIncidentSideType side) {
    return lstIncidents.where((incident) => incident.side == side).toList();
  }

  double getIncidentTimeLine(List<MatchIncidentModel> lstIncidents) {
    List<String> incidentTimes = getIncidentTimes(lstIncidents);
    double widthTimeline = defaultWidthPerIncident * incidentTimes.length;
    double screenWidth = MediaQuery.of(context).size.width - 70;
    if (widthTimeline < screenWidth) {
      defaultWidthPerIncident = screenWidth / (incidentTimes.length + 1);
      widthTimeline = screenWidth;
    }
    return widthTimeline;
  }

  Widget _getIncidentImage(
      String participant, String assetImg, MatchIncidentSideType side) {
    if (side == MatchIncidentSideType.away) {
      return Column(
        children: [
          Image.asset(
            assetImg,
            width: 16,
            height: 16,
          ),
          Text(
            participant,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(
                fontWeight: FontWeight.normal, fontSize: 10.0),
          ),
        ],
      );
    }
    return Column(
      children: [
        Text(
          participant,
          textAlign: TextAlign.center,
          style:
              textStyle.copyWith(fontWeight: FontWeight.normal, fontSize: 10.0),
        ),
        Image.asset(
          assetImg,
          width: 16,
          height: 16,
        ),
      ],
    );
  }

  Widget _getIncidentCard(
      String participant, Color color, MatchIncidentSideType side) {
    if (side == MatchIncidentSideType.away) {
      return Column(
        children: [
          SizedBox(
            width: 7,
            height: 10.0,
            child: Container(
              decoration: BoxDecoration(color: color),
            ),
          ),
          Text(
            participant,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(
                fontWeight: FontWeight.normal, fontSize: 10.0),
          ),
        ],
      );
    }
    return Column(
      children: [
        Text(
          participant,
          textAlign: TextAlign.center,
          style:
              textStyle.copyWith(fontWeight: FontWeight.normal, fontSize: 10.0),
        ),
        SizedBox(
          width: 7,
          height: 10.0,
          child: Container(
            decoration: BoxDecoration(color: color),
          ),
        ),
      ],
    );
  }

  Widget _getIncidentItemWidget(
      MatchIncidentModel? incident, MatchIncidentSideType side) {
    if (incident == null) return Container();
    switch (incident.type) {
      case MatchIncidentType.goal:
      case MatchIncidentType.penaltyScored:
        return _getIncidentImage(
            incident.participant, 'lib/assets/ball.png', side);
      case MatchIncidentType.ownGoal:
        return _getIncidentImage(
            incident.participant, 'lib/assets/own_ball.png', side);
      case MatchIncidentType.yellowCard:
        return _getIncidentCard(incident.participant, Colors.yellow, side);
      case MatchIncidentType.redCard:
        return _getIncidentCard(incident.participant, Colors.red, side);
      case MatchIncidentType.penaltyMissed:
        return _getIncidentImage(
            incident.participant, 'lib/assets/missed_ball.png', side);
      case MatchIncidentType.assistance:
        print('assistance');
        return _getIncidentImage(
            incident.participant, 'lib/assets/assitance_ball.png', side);
      default:
        return Container();
    }
  }

  MatchIncidentModel? getIncident(
    List<MatchIncidentModel> lstIncidents,
    String incidentTime,
    MatchIncidentSideType side,
  ) {
    try {
      return lstIncidents.firstWhere(
        (incident) =>
            incident.incidentTime == incidentTime && incident.side == side,
      );
    } catch (e) {
      return null;
    }
  }

  Widget getTeamIncidents(
      List<MatchIncidentModel> lstIncidents, MatchIncidentSideType side) {
    List<String> incidentTimes = getIncidentTimes(lstIncidents);
    return Row(
      children: [
        if (side == MatchIncidentSideType.home)
          DataMockPageState.getTeamBadge(
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/36534.png',
              20.0),
        if (side == MatchIncidentSideType.away)
          DataMockPageState.getTeamBadge(
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/22007.png',
              20.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var incidentTime in incidentTimes)
              SizedBox(
                width: incidentTimes.indexOf(incidentTime) == 0
                    ? defaultWidthPerIncident - 20
                    : defaultWidthPerIncident,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: side == MatchIncidentSideType.home ? 5.0 : 0,
                      top: side == MatchIncidentSideType.away ? 5.0 : 0),
                  child: _getIncidentItemWidget(
                      getIncident(lstIncidents, incidentTime, side), side),
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _getTimelineWidget(List<MatchIncidentModel> lstIncidents) {
    double widthTimeline = getIncidentTimeLine(lstIncidents);
    List<String> incidentTimes = getIncidentTimes(lstIncidents);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      decoration: const BoxDecoration(
        color: Color(0xFF3AC962),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: SizedBox(
        width: widthTimeline,
        child: Row(
          children: [
            for (var incidentTime in incidentTimes)
              SizedBox(
                width: defaultWidthPerIncident,
                child: Column(
                  children: [
                    Text(
                      incidentTime,
                      style: textStyle.copyWith(fontSize: 10.0),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _getIncidents(List<MatchIncidentModel> lstIncidents) {
    if (lstIncidents.isEmpty) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: const BoxDecoration(
        color: Color(0xFF150103),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  getTeamIncidents(lstIncidents, MatchIncidentSideType.home),
                  _getTimelineWidget(lstIncidents),
                  getTeamIncidents(lstIncidents, MatchIncidentSideType.away),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
      child: Text(
        title,
        style: textStyle,
      ),
    );
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCategoryTitle('Match Timeline'),
                      _getIncidents(incidents),
                      getCategoryTitle('Summary'),
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
