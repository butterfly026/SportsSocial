import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/match_incident_model.dart';

class IncidentsTimeline extends StatefulWidget {
  final List<MatchIncidentModel> incidents;
  const IncidentsTimeline({super.key, required this.incidents});

  @override
  IncidentsTimelineState createState() => IncidentsTimelineState();
}

class IncidentsTimelineState extends State<IncidentsTimeline> {
  static const double _defaultWidthPerIncident = 70;
  static const double _stageTimeWgtWidth = 20;
  static const double _iconSize = 16;
  static const List<String> _lstStageTimes = ['KO', 'HT', 'ET', 'PT'];

  List<MatchIncidentModel> _lstIncidents = [];
  TextStyle textStyle = const TextStyle(
      fontSize: 12.0,
      color: Colors.white,
      height: 1.5,
      fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _lstIncidents = widget.incidents;
  }

  @override
  void didUpdateWidget(covariant IncidentsTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_lstIncidents != widget.incidents) {
      setState(() {
        _lstIncidents = widget.incidents;
      });
    }
  }

  Widget _getTeamBadge(String? badgeUrl) {
    return CachedNetworkImage(
        imageUrl: badgeUrl ?? '',
        width: 20.0,
        height: 20.0,
        placeholder: (context, url) => const SizedBox(
              width: 20.0,
              height: 20.0,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                ),
              ),
            ),
        errorWidget: (context, url, error) {
          return const SizedBox(
              width: 20.0,
              height: 20.0,
              child: Center(
                child: Icon(Icons.error, color: Colors.grey, size: 14.0),
              ));
        });
  }

  List<String> _getIncidentTimes(List<MatchIncidentModel> lstIncidents) {
    final Set<String> incidentTimes = {};
    for (var incident in lstIncidents) {
      switch (incident.stage) {
        case MatchIncidentStageType.firstHalf:
          incidentTimes.add('KO');
          break;
        case MatchIncidentStageType.secondHalf:
          incidentTimes.add('HT');
          break;
        case MatchIncidentStageType.extraTime:
          incidentTimes.add('ET');
          break;
        case MatchIncidentStageType.penalty:
          incidentTimes.add('PT');
          break;
        default:
          break;
      }
      incidentTimes.add(incident.incidentTime);
    }
    return incidentTimes.toList();
  }

  double _getIncidentTimeLineWidth(List<MatchIncidentModel> lstIncidents) {
    List<String> incidentTimes = _getIncidentTimes(lstIncidents);
    int nStageTimes = incidentTimes
        .where((incidentTime) => _lstStageTimes.contains(incidentTime))
        .toList()
        .length;
    double widthTimeline =
        _defaultWidthPerIncident * (incidentTimes.length - nStageTimes) +
            _stageTimeWgtWidth * nStageTimes;
    double screenWidth = MediaQuery.of(context).size.width - 80;
    if (widthTimeline < screenWidth) {
      widthTimeline = screenWidth;
    }

    return widthTimeline / (incidentTimes.length - nStageTimes);
  }

  Widget _getIncidentImage(
      String participant, String assetImg, MatchIncidentSideType side) {
    return Column(
      children: [
        if (side == MatchIncidentSideType.home) ...[
          Text(participant,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(fontWeight: FontWeight.normal)),
          Image.asset(assetImg, width: _iconSize, height: _iconSize),
        ] else ...[
          Image.asset(assetImg, width: _iconSize, height: _iconSize),
          Text(participant,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(fontWeight: FontWeight.normal)),
        ],
      ],
    );
  }

  Widget _getIncidentCard(
      String participant, Color color, MatchIncidentSideType side) {
    return Column(
      children: [
        if (side == MatchIncidentSideType.home) ...[
          Text(participant,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(fontWeight: FontWeight.normal)),
          SizedBox(
              width: 7,
              height: 10.0,
              child: Container(decoration: BoxDecoration(color: color))),
        ] else ...[
          SizedBox(
              width: 7,
              height: 10.0,
              child: Container(decoration: BoxDecoration(color: color))),
          Text(participant,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(fontWeight: FontWeight.normal)),
        ],
      ],
    );
  }

  Widget _getSubstitution(List<MatchIncidentModel> incidentsIn,
      List<MatchIncidentModel> incidentsOut, MatchIncidentSideType side) {
    final List<Widget> widgets = [];
    if (side == MatchIncidentSideType.away) {
      widgets.addAll(
        incidentsIn.map(
          (incident) => Text(
            '${incidentsIn.indexOf(incident) == 0 ? '' : '/ '}${incident.participant}',
            textAlign: TextAlign.center,
            style: textStyle.copyWith(
                color: Colors.green, fontWeight: FontWeight.normal),
          ),
        ),
      );
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (incidentsIn.isNotEmpty)
              const Icon(Icons.arrow_downward, color: Colors.red, size: 15),
            if (incidentsOut.isNotEmpty)
              const Icon(Icons.arrow_upward, color: Colors.green, size: 15),
          ],
        ),
      );
      widgets.addAll(
        incidentsOut.map(
          (incident) => Text(
            '${incidentsOut.indexOf(incident) == 0 ? '' : '/ '}${incident.participant}',
            textAlign: TextAlign.center,
            style: textStyle.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );
    } else {
      widgets.addAll(
        incidentsOut.map(
          (incident) => Text(
            '${incidentsOut.indexOf(incident) == 0 ? '' : '/ '}${incident.participant}',
            textAlign: TextAlign.center,
            style: textStyle.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (incidentsOut.isNotEmpty)
              const Icon(Icons.arrow_upward, color: Colors.green, size: 15),
            if (incidentsIn.isNotEmpty)
              const Icon(Icons.arrow_downward, color: Colors.red, size: 15),
          ],
        ),
      );
      widgets.addAll(
        incidentsIn.map(
          (incident) => Text(
            '${incidentsIn.indexOf(incident) == 0 ? '' : '/ '}${incident.participant}',
            textAlign: TextAlign.center,
            style: textStyle.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );
    }
    return Column(children: widgets);
  }

  Widget _getGoalAssistance(MatchIncidentModel incAssistance,
      MatchIncidentModel incGoal, MatchIncidentSideType side) {
    return Column(
      children: [
        if (side == MatchIncidentSideType.home) ...[
          Text(incAssistance.participant,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                  fontWeight: FontWeight.normal, fontSize: 10.0)),
          Image.asset('lib/assets/assitance_ball.png',
              width: _iconSize, height: _iconSize),
          Text(incGoal.participant,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                  fontWeight: FontWeight.normal, fontSize: 10.0)),
          Image.asset('lib/assets/ball.png',
              width: _iconSize, height: _iconSize),
        ] else ...[
          Image.asset('lib/assets/ball.png',
              width: _iconSize, height: _iconSize),
          Text(incGoal.participant,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                  fontWeight: FontWeight.normal, fontSize: 10.0)),
          Image.asset('lib/assets/assitance_ball.png',
              width: _iconSize, height: _iconSize),
          Text(incAssistance.participant,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                  fontWeight: FontWeight.normal, fontSize: 10.0)),
        ],
      ],
    );
  }

  Widget _getIncidentItemWidget(
      List<MatchIncidentModel> incidents, MatchIncidentSideType side) {
    if (incidents.isEmpty) return Container();
    if (incidents.length == 1) {
      MatchIncidentModel incident = incidents[0];
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
          return _getIncidentImage(
              incident.participant, 'lib/assets/assitance_ball.png', side);
        default:
          return Container();
      }
    } else if (incidents.length == 2 &&
        (incidents[0].type == MatchIncidentType.assistance ||
            incidents[0].type == MatchIncidentType.goal)) {
      try {
        MatchIncidentModel incAssistance = incidents
            .firstWhere((item) => item.type == MatchIncidentType.assistance);
        MatchIncidentModel incGoal =
            incidents.firstWhere((item) => item.type == MatchIncidentType.goal);
        return _getGoalAssistance(incAssistance, incGoal, side);
      } catch (e) {
        return Container();
      }
    } else {
      if (incidents[0].type == MatchIncidentType.substitutionIn ||
          incidents[0].type == MatchIncidentType.substitutionOut) {
        List<MatchIncidentModel> incidentsIn = incidents
            .where((item) => item.type == MatchIncidentType.substitutionIn)
            .toList();
        List<MatchIncidentModel> incidentsOut = incidents
            .where((item) => item.type == MatchIncidentType.substitutionOut)
            .toList();
        return _getSubstitution(incidentsIn, incidentsOut, side);
      }
    }
    return Container();
  }

  List<MatchIncidentModel> _getIncident(
    List<MatchIncidentModel> lstIncidents,
    String incidentTime,
    MatchIncidentSideType side,
  ) {
    return lstIncidents.where((incident) {
      return incident.incidentTime == incidentTime && incident.side == side;
    }).toList();
  }

  Widget _getTeamIncidents(
      List<MatchIncidentModel> lstIncidents, MatchIncidentSideType side) {
    List<String> incidentTimes = _getIncidentTimes(lstIncidents);
    double incidentWgtWidth = _getIncidentTimeLineWidth(lstIncidents);
    return Row(
      children: [
        if (side == MatchIncidentSideType.home)
          _getTeamBadge(
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/36534.png'),
        if (side == MatchIncidentSideType.away)
          _getTeamBadge(
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/22007.png'),
        Row(
          crossAxisAlignment: side == MatchIncidentSideType.home
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            for (var incidentTime in incidentTimes)
              SizedBox(
                width: _lstStageTimes.contains(incidentTime)
                    ? _stageTimeWgtWidth
                    : incidentWgtWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: side == MatchIncidentSideType.home ? 5.0 : 0,
                      top: side == MatchIncidentSideType.away ? 5.0 : 0),
                  child: _getIncidentItemWidget(
                      _getIncident(lstIncidents, incidentTime, side), side),
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _getTimelineWidget(List<MatchIncidentModel> lstIncidents) {
    if (lstIncidents.isEmpty) return Container();
    List<String> incidentTimes = _getIncidentTimes(lstIncidents);
    double incidentWgtWidth = _getIncidentTimeLineWidth(lstIncidents);
    return Container(
      padding: const EdgeInsets.only(left: 20.0, top: 2.0, bottom: 2.0),
      decoration: const BoxDecoration(
        color: Color(0xFF3AC962),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Row(
        children: [
          for (var incidentTime in incidentTimes)
            SizedBox(
              width: _lstStageTimes.contains(incidentTime)
                  ? _stageTimeWgtWidth
                  : incidentWgtWidth,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_lstIncidents.isEmpty) {
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
              reverse: true,
              child: Column(
                children: [
                  _getTeamIncidents(_lstIncidents, MatchIncidentSideType.home),
                  _getTimelineWidget(_lstIncidents),
                  _getTeamIncidents(_lstIncidents, MatchIncidentSideType.away),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
