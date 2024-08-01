import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/banner_app_bar.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/banner_header.dart';

class BannerWorkPage extends StatefulWidget {
  const BannerWorkPage({super.key});

  @override
  DataMockPageState createState() => DataMockPageState();
}

class DataMockPageState extends State<BannerWorkPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  static Widget getTeamBadge(String? badgeUrl, double size) {
    return CachedNetworkImage(
        imageUrl: badgeUrl ?? '',
        width: size,
        height: size,
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

  static Widget _getTitleWidget() {
    return Transform.translate(
      offset: const Offset(-40, 0.0), // Adjust this offset as needed
      child: Row(
        children: [
          getTeamBadge(
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/36534.png',
              20.0),
          const SizedBox(width: 6.0),
          const Column(
            children: [
              Text(
                '60:22',
                style: TextStyle(fontSize: 8.0, color: Colors.white),
              ),
              Text(
                '2-2',
                style: TextStyle(fontSize: 13.0, color: Colors.white),
              )
            ],
          ),
          const SizedBox(width: 6.0),
          getTeamBadge(
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/22007.png',
              20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15182C),
      appBar: BannerAppBar(
        titleWidget: _getTitleWidget(),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
        ),
        child: const Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BannerHeader(),
          ],
        ),
      ),
    );
  }
}
