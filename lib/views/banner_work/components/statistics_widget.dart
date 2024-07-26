import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/match_statistics.dart';
import 'package:sport_social_mobile_mock/services/live_game_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';

class StatisticsWidget extends StatefulWidget {
  final int displayMode;
  const StatisticsWidget({super.key, required this.displayMode});

  @override
  StatisticsWidgetState createState() => StatisticsWidgetState();
}

class StatisticsWidgetState extends State<StatisticsWidget> {
  final dataMockService = ServiceLocator.get<LiveGameService>();

  @override
  void initState() {
    super.initState();
  }

  Widget _getStatusWidget(MatchgStatisticsModel statistic) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFF635F9B)),
        child: Column(
          children: [
            Text(
              statistic.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10.0, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _getValue(MatchgStatisticsModel statistic, int homeOrAway) {
    return Expanded(
      flex: 1,
      child: Text(
        homeOrAway == 0 ? statistic.valueHome : statistic.valueAway,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10.0, color: Colors.white),
      ),
    );
  }

  Widget _getPregress(MatchgStatisticsModel statistic, int homeOrAway) {
    int homeValue = int.tryParse(statistic.valueHome.replaceAll('%', '')) ?? 0;
    int awayValue = int.tryParse(statistic.valueAway.replaceAll('%', '')) ?? 0;
    int bigValue = homeValue > awayValue ? homeValue : awayValue;
    double factor = 0;
    if (bigValue != 0) {
      if (homeOrAway == 0) {
        //home progress
        if (homeValue != 0) {
          factor = homeValue / bigValue;
        }
      } else if (homeOrAway == 1) {
        //away progress
        if (awayValue != 0) {
          factor = awayValue / bigValue;
        }
      }
    }
    return Expanded(
      flex: 2,
      child: FractionallySizedBox(
        widthFactor: factor,
        alignment: homeOrAway == 0
            ? FractionalOffset.centerRight
            : FractionalOffset.centerLeft,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: homeOrAway == 0 ? Colors.red : Colors.blue,
              width: 7,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getStatisticItem(MatchgStatisticsModel statistic) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          _getValue(statistic, 0),
          _getPregress(statistic, 0),
          const SizedBox(width: 4.0),
          _getStatusWidget(statistic),
          const SizedBox(width: 4.0),
          _getPregress(statistic, 1),
          _getValue(statistic, 1),
        ],
      ),
    );
  }

  Widget _getStatisticsList(List<MatchgStatisticsModel> lstData) {
    return Expanded(
        child: ListView.builder(
            itemCount: lstData.length,
            itemBuilder: (context, index) {
              return _getStatisticItem(lstData[index]);
            }));
  }

  Widget _getExpandIcon() {
    return GestureDetector(
      onTap: () {},
      child: const Icon(
        Icons.open_in_full,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dataMockService.statisticsNotifier,
        builder: (context, statistics, child) {
          List<MatchgStatisticsModel> lstData = [];
          int len = statistics.length;
          if (widget.displayMode == 0) {
            lstData = statistics.sublist(0, len > 4 ? 4 : len);
          } else {
            lstData = statistics;
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getStatisticsList(lstData),
              _getExpandIcon(),
            ],
          );
        });
  }
}
