import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/services/live_game_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';

class GameSummaryWidget extends StatefulWidget {
  final int displayMode;
  const GameSummaryWidget({super.key, required this.displayMode});

  @override
  GameSummaryWidgetState createState() => GameSummaryWidgetState();
}

class GameSummaryWidgetState extends State<GameSummaryWidget> {
  final dataMockService = ServiceLocator.get<LiveGameService>();

  @override
  void initState() {
    super.initState();
  }

  Widget _getGameSummaryItem() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 16.0, color: Colors.white, height: 1.5),
        children: <TextSpan>[
          TextSpan(
              text: 'End of 60 mins',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
              text:
                  'A cagey opening at Old Trafford. Both teams cautious in the early stages. '),
        ],
      ),
    );
  }

  Widget _getGameSummaryList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: _getGameSummaryItem(),
              ),
            )
          ],
        ),
      ),
    );
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getGameSummaryList(),
        _getExpandIcon(),
      ],
    );
  }
}
