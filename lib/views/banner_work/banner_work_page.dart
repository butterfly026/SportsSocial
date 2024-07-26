import 'package:flutter/material.dart';
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

  Widget _getMatchStatusBar() {
    return Row(
      children: [
        GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 35,
            )),
        const Spacer(),
        const SizedBox(width: 10.0)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15182C),
      body: Column(
        children: [
          _getMatchStatusBar(),
          const BannerHeader(),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
