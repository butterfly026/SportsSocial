import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/banner_app_bar.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/banner_header.dart';

class BannerWorkPage extends StatefulWidget {
  const BannerWorkPage({super.key});

  @override
  BannerWorkPageState createState() => BannerWorkPageState();
}

class BannerWorkPageState extends State<BannerWorkPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF15182C),
      appBar: BannerAppBar(),
      body: Stack(
        children: [
          ChatWidget(),
          BannerHeader(),
        ],
      ),
    );
  }
}
