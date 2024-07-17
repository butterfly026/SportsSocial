import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/services/data_mock_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';
import 'package:sport_social_mobile_mock/views/components/news_widget.dart';

class DataMockPage extends StatefulWidget {
  const DataMockPage({super.key});

  @override
  _DataMockPageState createState() => _DataMockPageState();
}

class _DataMockPageState extends State<DataMockPage>
    with TickerProviderStateMixin {
  final dataMockService = ServiceLocator.get<DataMockService>();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Widget _showNewsJson() {
    return ValueListenableBuilder(
        valueListenable: dataMockService.newsNotifier,
        builder: (context, news, child) {
          String prettyJson = jsonEncode(news);
          return SingleChildScrollView(
            child: Text(
              prettyJson,
              style: const TextStyle(
                fontFamily: 'Monospace',
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF15182C),
      appBar: AppBar(
        backgroundColor: Color(0xFF15182c),
        title: const Text(
          'Data Mock View',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                    height: 35,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(left: 8.0),
                      indicator: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Colors.white,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(
                            16), // Radius for the active tab border
                      ),
                      unselectedLabelColor:
                          Colors.white, // Inactive tab text color
                      labelColor: Colors.white, // Active tab text color
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      splashBorderRadius:
                          BorderRadius.all(Radius.circular(8.0)),
                      tabAlignment: TabAlignment.start,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorPadding: EdgeInsets.zero,
                      labelPadding:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
                      splashFactory: NoSplash.splashFactory, // No splash effect

                      tabs: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Tab(text: 'News')),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Tab(text: 'Matches')),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Tab(text: 'Standings')),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: const Tab(text: 'Stats'))
                      ],
                    )),
              )
            ],
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              NewsWidget(),
              Container(),
              Container(),
              Container(),
            ]),
          ),
        ],
      ),
    );
  }
}
