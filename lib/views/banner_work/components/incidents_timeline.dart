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

  double _defaultWidthPerIncident = 60;
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
    if(_lstIncidents != widget.incidents) {
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
    List<String> incidentTimes = [];
    for (var incident in lstIncidents) {
      if (!incidentTimes.contains(incident.incidentTime)) {
        switch (incident.stage) {
          case MatchIncidentStageType.firstHalf:
            if (!incidentTimes.contains('KO')) {
              incidentTimes.add('KO');
            }
            break;
          case MatchIncidentStageType.secondHalf:
            if (!incidentTimes.contains('HT')) {
              incidentTimes.add('HT');
            }
            break;
          case MatchIncidentStageType.extraTime:
            if (!incidentTimes.contains('ET')) {
              incidentTimes.add('ET');
            }
            break;
          case MatchIncidentStageType.penalty:
            if (!incidentTimes.contains('PT')) {
              incidentTimes.add('PT');
            }
            break;
          default:
            break;
        }
        incidentTimes.add(incident.incidentTime);
      }
    }
    return incidentTimes;
  }

  double _getIncidentTimeLine(List<MatchIncidentModel> lstIncidents) {
    List<String> incidentTimes = _getIncidentTimes(lstIncidents);
    double widthTimeline = _defaultWidthPerIncident * incidentTimes.length;
    double screenWidth = MediaQuery.of(context).size.width - 70;
    if (widthTimeline < screenWidth) {
      _defaultWidthPerIncident = screenWidth / (incidentTimes.length + 1);
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

  Widget _getsubstitution(List<MatchIncidentModel> incidentsIn,
      List<MatchIncidentModel> incidentsOut, MatchIncidentSideType side) {
    if (side == MatchIncidentSideType.away) {
      return Column(
        children: [
          if (incidentsIn.isNotEmpty)
            for (var incident in incidentsIn)
              Text(
                incidentsIn.indexOf(incident) == 0
                    ? incident.participant
                    : '/ ${incident.participant}',
                textAlign: TextAlign.center,
                style: textStyle.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.normal,
                    fontSize: 10.0),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (incidentsIn.isNotEmpty)
                const Icon(Icons.arrow_downward, color: Colors.red, size: 15),
              if (incidentsOut.isNotEmpty)
                const Icon(Icons.arrow_upward, color: Colors.green, size: 15),
            ],
          ),
          if (incidentsOut.isNotEmpty)
            for (var incident in incidentsOut)
              Text(
                incidentsOut.indexOf(incident) == 0
                    ? incident.participant
                    : '/ ${incident.participant}',
                textAlign: TextAlign.center,
                style: textStyle.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.normal,
                    fontSize: 10.0),
              ),
        ],
      );
    }

    return Column(
      children: [
        if (incidentsOut.isNotEmpty)
          for (var incident in incidentsOut)
            Text(
              incidentsOut.indexOf(incident) == 0
                  ? incident.participant
                  : '/ ${incident.participant}',
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.normal,
                  fontSize: 10.0),
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (incidentsOut.isNotEmpty)
              const Icon(Icons.arrow_upward, color: Colors.green, size: 15),
            if (incidentsIn.isNotEmpty)
              const Icon(Icons.arrow_downward, color: Colors.red, size: 15),
          ],
        ),
        if (incidentsIn.isNotEmpty)
          for (var incident in incidentsIn)
            Text(
              incidentsIn.indexOf(incident) == 0
                  ? incident.participant
                  : '/ ${incident.participant}',
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.normal,
                  fontSize: 10.0),
            ),
      ],
    );
  }

  Widget _getGoalAssistance(MatchIncidentModel incAssistance,
      MatchIncidentModel incGoal, MatchIncidentSideType side) {
    if (side == MatchIncidentSideType.away) {
      return Column(
        children: [
          Image.asset(
            'lib/assets/ball.png',
            width: 16,
            height: 16,
          ),
          Text(
            incGoal.participant,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(
                fontWeight: FontWeight.normal, fontSize: 10.0),
          ),
          Image.asset(
            'lib/assets/assitance_ball.png',
            width: 16,
            height: 16,
          ),
          Text(
            incAssistance.participant,
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
          incAssistance.participant,
          textAlign: TextAlign.center,
          style:
              textStyle.copyWith(fontWeight: FontWeight.normal, fontSize: 10.0),
        ),
        Image.asset(
          'lib/assets/assitance_ball.png',
          width: 16,
          height: 16,
        ),
        Text(
          incGoal.participant,
          textAlign: TextAlign.center,
          style:
              textStyle.copyWith(fontWeight: FontWeight.normal, fontSize: 10.0),
        ),
        Image.asset(
          'lib/assets/ball.png',
          width: 16,
          height: 16,
        ),
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
        return _getsubstitution(incidentsIn, incidentsOut, side);
      }
    }
    return Container();
  }

  List<MatchIncidentModel> _getIncident(
    List<MatchIncidentModel> lstIncidents,
    String incidentTime,
    MatchIncidentSideType side,
  ) {
    return lstIncidents
        .where(
          (incident) =>
              incident.incidentTime == incidentTime && incident.side == side,
        )
        .toList();
  }

  Widget _getTeamIncidents(
      List<MatchIncidentModel> lstIncidents, MatchIncidentSideType side) {
    List<String> incidentTimes = _getIncidentTimes(lstIncidents);
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
                width: incidentTimes.indexOf(incidentTime) == 0
                    ? _defaultWidthPerIncident - 20
                    : _defaultWidthPerIncident,
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
    double widthTimeline = _getIncidentTimeLine(lstIncidents);
    List<String> incidentTimes = _getIncidentTimes(lstIncidents);
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
                width: _defaultWidthPerIncident,
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