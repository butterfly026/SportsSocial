import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/news_model.dart';
import 'package:sport_social_mobile_mock/services/data_mock_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DataMockPage extends StatefulWidget {
  const DataMockPage({super.key});

  @override
  _DataMockPageState createState() => _DataMockPageState();
}

class _DataMockPageState extends State<DataMockPage>
    with TickerProviderStateMixin {
  final dataMockService = ServiceLocator.get<DataMockService>();
  late TabController _tabController;

  String humanizeTimeDifference(dynamic miliseconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(miliseconds);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Widget _showNewsJson() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ValueListenableBuilder(
          valueListenable: dataMockService.newsNotifier,
          builder: (context, news, child) {
            return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                NewsModel newsItem = news[index];
                return GestureDetector(
                  onTap: () async {
                    await launchUrlString(newsItem.url);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 16.0, top: 16.0, right: 16.0, bottom: 8.0),
                        decoration: BoxDecoration(
                            color: Color(0xFF121212),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                child: CachedNetworkImage(
                                    imageUrl: newsItem.imageUrl ?? '',
                                    placeholder: (context, url) => Container(
                                          width: 150.0,
                                          height: 150.0,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) {
                                      return Container(
                                          width: 100.0,
                                          height: 100.0,
                                          child: Center(
                                            child: Icon(Icons.error,
                                                color: Colors.grey),
                                          ));
                                    }),
                              ),
                            ),
                            SizedBox(height: 6.0),
                            Text(
                              newsItem.title,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        '${humanizeTimeDifference(newsItem.publishedAt)}, ${newsItem.providerDisplayName}, ${newsItem.readTime == null ? '' : '${newsItem.readTime} min read'}',
                        style:
                            TextStyle(fontSize: 14.0, color: Color(0xFFD0D0D0)),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }

  Widget _showTabBar() {
    return TabBar(
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
        borderRadius:
            BorderRadius.circular(16), // Radius for the active tab border
      ),
      unselectedLabelColor: Colors.white, // Inactive tab text color
      labelColor: Colors.white, // Active tab text color
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      splashBorderRadius: BorderRadius.all(Radius.circular(8.0)),
      tabAlignment: TabAlignment.start,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.zero,
      labelPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
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
    );
  }

  Widget _showTabWidgets() {
    return Expanded(
      child: TabBarView(controller: _tabController, children: [
        _showNewsJson(),
        Container(),
        Container(),
        Container(),
      ]),
    );
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
              Expanded(child: SizedBox(height: 35, child: _showTabBar()))
            ],
          ),
          SizedBox(height: 8.0),
          _showTabWidgets(),
        ],
      ),
    );
  }
}
