import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/services/data_mock_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';
import 'package:sport_social_mobile_mock/views/team_info/components/matches_component.dart';
import 'package:sport_social_mobile_mock/views/team_info/components/news_component.dart';
import 'package:sport_social_mobile_mock/views/team_info/components/standings_component.dart';

class TeamInfoPage extends StatefulWidget {
  const TeamInfoPage({super.key});

  @override
  DataMockPageState createState() => DataMockPageState();
}

class DataMockPageState extends State<TeamInfoPage>
    with TickerProviderStateMixin {
  final dataMockService = ServiceLocator.get<DataMockService>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _getTabItem(String tabTitle) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: Tab(text: tabTitle));
  }

  Widget _showTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(left: 8.0),
      indicator: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Colors.white,
          style: BorderStyle.solid,
        ),
        borderRadius:
            BorderRadius.circular(16), // Radius for the active tab border
      ),
      unselectedLabelColor: Colors.white, // Inactive tab text color
      labelColor: Colors.white, // Active tab text color
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      splashBorderRadius: const BorderRadius.all(Radius.circular(8.0)),
      tabAlignment: TabAlignment.start,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      splashFactory: NoSplash.splashFactory, // No splash effect

      tabs: [
        for (var tabTitle in ['News', 'Matches', 'Standings'])
          _getTabItem(tabTitle)
      ],
    );
  }

  Widget _showTabWidgets() {
    return Expanded(
      child: TabBarView(controller: _tabController, children: [
        NewsWidget(),
        MatchesWidget(),
        const StandingsWidget(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15182C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF15182c),
        title: const Text(
          'Data Mock View',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: SizedBox(height: 35, child: _showTabBar()))
            ],
          ),
          const SizedBox(height: 8.0),
          _showTabWidgets(),
        ],
      ),
    );
  }
}
