import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/news_model.dart';
import 'package:sport_social_mobile_mock/services/data_mock_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';

class NewsWidget extends StatelessWidget {
  final dataMockService = ServiceLocator.get<DataMockService>();
  NewsWidget({super.key});

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
  Widget build(BuildContext context) {
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
                    // await launchUrlString(newsItem.url);
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
                                    width: 100.0,
                                    height: 100.0,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    width: 100.0,
                                    height: 100.0,
                                    child: Center(
                                      child: Icon(Icons.error),
                                    ),
                                  ),
                                ),
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
                        '${humanizeTimeDifference(newsItem.publishedAt)}, ${newsItem.providerDisplayName}, ${newsItem.readTime} min read',
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
}
