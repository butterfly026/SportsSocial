import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/app_bar.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/banner_header.dart';

class BannerWorkPage extends StatefulWidget {
  const BannerWorkPage({super.key});

  @override
  DataMockPageState createState() => DataMockPageState();
}

class DataMockPageState extends State<BannerWorkPage> {
  @override
  void initState() {
    super.initState();
  }

  static Widget _teamBadge(String? badgeUrl) {
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

  static Widget _getTitleWidget() {
    return Transform.translate(
      offset: const Offset(-40, 0.0), // Adjust this offset as needed
      child: Row(
        children: [
          _teamBadge(
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/36534.png'),
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
          _teamBadge(
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/22007.png'),
        ],
      ),
    );
  }

  PreferredSizeWidget _getAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0x44000000),
            offset: Offset(0, 2.0),
            blurRadius: 4.0,
          )
        ]),
        child: SubPageAppBar(
          titleWidget: _getTitleWidget(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15182C),
      appBar: _getAppBar(),
      body: const Column(
        children: [
          BannerHeader(),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
