import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/app_bar.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/banner_header.dart';

class BannerWorkPage extends StatefulWidget {
  const BannerWorkPage({super.key});

  @override
  DataMockPageState createState() => DataMockPageState();
}

class DataMockPageState extends State<BannerWorkPage>
    with SingleTickerProviderStateMixin {
  double defaultBannerHeight = 170;
  double bannerHeight = 160;
  double dragYStart = 0;
  double dragYEnd = 0;
  int expanded = 0;
  double maxHeight = 0;

  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {
    _expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _expandAnimation = Tween<double>(
      begin: defaultBannerHeight,
      end: maxHeight,
    ).animate(
      CurvedAnimation(
        parent: _expandController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _expandController.addListener(() {
      setState(() {
        bannerHeight = _expandAnimation.value;
        double screenHeight = MediaQuery.of(context).size.height;
        expanded = bannerHeight < screenHeight - 300 ? 0 : 1;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenHeight = MediaQuery.of(context).size.height;
    maxHeight = screenHeight - 100;
    _expandAnimation = Tween<double>(
      begin: defaultBannerHeight,
      end: maxHeight,
    ).animate(
      CurvedAnimation(
        parent: _expandController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void onExpanded(int expanded) {
    setState(() {
      if (expanded == 1) {
        bannerHeight = MediaQuery.of(context).size.height - 100;
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
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

  Widget _getExpandDragIcon() {
    return Container(
      height: 5,
      width: 30,
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(6))),
    );
  }

  Widget _getExpandDragArea() {
    return Transform.translate(
      offset: const Offset(0, 3),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragStart: (details) {
          setState(() {
            dragYStart = details.globalPosition.dy;
          });
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          setState(() {
            double positionY = details.globalPosition.dy;
            double maxHeight = MediaQuery.of(context).size.height - 70;
            if (positionY < 200) {
              bannerHeight = defaultBannerHeight;
            } else if (positionY <= maxHeight) {
              bannerHeight = positionY - 40;
            }
            if (bannerHeight < maxHeight - 300) {
              expanded = 0;
            } else {
              expanded = 1;
            }
          });
        },
        onVerticalDragEnd: (details) {
          setState(() {
            dragYEnd = details.globalPosition.dy;
            double maxHeight = MediaQuery.of(context).size.height - 100;
            double offset = dragYEnd - dragYStart;
            double defaultOffset = 150;
            if (offset > defaultOffset) {
              bannerHeight = maxHeight;
            } else if (offset > 0 && offset <= defaultOffset) {
              if (expanded == 1) {
                bannerHeight = maxHeight;
              } else if (expanded == 0) {
                bannerHeight = defaultBannerHeight;
              }
            } else if (offset >= -defaultOffset && offset < 0) {
              if (expanded == 1) {
                bannerHeight = maxHeight;
              } else if (expanded == 0) {
                bannerHeight = 190;
              }
            } else if (offset < -defaultOffset) {
              bannerHeight = defaultBannerHeight;
            }            
            if (bannerHeight < maxHeight - 300) {
              expanded = 0;
            } else {
              expanded = 1;
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            _getExpandDragIcon()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15182C),
      appBar: _getAppBar(),
      body: Container(
        height: bannerHeight,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BannerHeader(
              expandMode: expanded,
              bannerHeight: bannerHeight - 60,
              onExpand: onExpanded,
            ),
            _getExpandDragArea(),
          ],
        ),
      ),
    );
  }
}
