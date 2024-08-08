import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/match_statistics.dart';
import 'package:sport_social_mobile_mock/services/live_game_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({super.key});

  @override
  StatisticsWidgetState createState() => StatisticsWidgetState();
}

class StatisticsWidgetState extends State<StatisticsWidget> {
  final dataMockService = ServiceLocator.get<LiveGameService>();

  @override
  void initState() {
    super.initState();
  }

  Widget _getStatusWidget(MatchStatisticsModel statistic) {
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _valueWidget(String value) {
    return Expanded(
      flex: 1,
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10.0, color: Colors.white),
      ),
    );
  }

  double _getDenominator(MatchStatisticsModel statistic) {
    final homeValue = double.tryParse(statistic.valueHome) ?? 0;
    final awayValue = double.tryParse(statistic.valueAway) ?? 0;
    return homeValue + awayValue;
  }

  Widget _getProgressWidget(
      double numerator, double denominator, Color color, int quarterTurns) {

    if (denominator == 0) return Expanded(flex: 2, child: Container());

    double percentage = numerator / denominator;
    if (percentage == 0) return Expanded(flex: 2, child: Container());
    return Expanded(
      flex: 2,
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: LinearProgressIndicator(
          value: percentage,
          color: color,
          backgroundColor: Colors.transparent,
          minHeight: 10.0,
        ),
      ),
    );
  }

  Widget _getStatisticItem(MatchStatisticsModel statistic) {
    double denominator = _getDenominator(statistic);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          _valueWidget(statistic.valueHome),
          _getProgressWidget(double.tryParse(statistic.valueHome) ?? 0, denominator, Colors.red, 2),
          const SizedBox(width: 4.0),
          _getStatusWidget(statistic),
          const SizedBox(width: 4.0),
          _getProgressWidget(double.tryParse(statistic.valueAway) ?? 0, denominator, Colors.blue, 0),
          _valueWidget(statistic.valueAway),
        ],
      ),
    );
  }

  Widget _getStatisticsList(List<MatchStatisticsModel> lstData) {
    return Expanded(
      child: ListView.builder(
        itemCount: lstData.length,
        itemBuilder: (context, index) => _getStatisticItem(lstData[index]),
      ),
    );
  }

  Widget _getNotAvailableWidget() {
    return const Center(
      child: Text(
        'Statistics not available',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataMockService.statisticNotifier,
      builder: (context, List<MatchStatisticsModel> statistics, child) {
        if (statistics.isEmpty) {
          return _getNotAvailableWidget();
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatisticsList(statistics),
          ],
        );
      },
    );
  }
}
