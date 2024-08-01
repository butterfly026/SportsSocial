import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/banner_app_bar.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/banner_header.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/chat_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15182C),
      appBar: BannerAppBar(),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 165.0),
            child: const ChatWidget(),
          ),
          const BannerHeader(),
        ],
      ),
    );
  }
}
