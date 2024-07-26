import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/commentary_widget.dart';

class BannerHeader extends StatefulWidget {
  const BannerHeader({super.key});

  @override
  State<BannerHeader> createState() => _BannerHeaderState();
}

class _BannerHeaderState extends State<BannerHeader>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _getTabItem(String tabTitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 3.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 50),
        child: Tab(
          text: tabTitle,
          height: 16,
        ),
      ),
    );
  }

  Widget _getTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(left: 8.0),
        onTap: (int index) {
          setState(() {
            _tabController.animateTo(index);
          });
        },
        indicator: BoxDecoration(
          color: const Color(0xFF535457),
          borderRadius: BorderRadius.circular(14),
        ),
        unselectedLabelColor: Colors.white,
        labelStyle: const TextStyle(fontSize: 10.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        labelColor: Colors.white,
        dividerColor: Colors.transparent,
        splashBorderRadius: const BorderRadius.all(Radius.circular(8.0)),
        tabAlignment: TabAlignment.start,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.transparent,
        indicatorPadding: EdgeInsets.zero,
        indicatorWeight: 0.0,
        splashFactory: NoSplash.splashFactory, // No splash effect

        tabs: [
          for (var tabTitle in ['Commentary', 'Game Summary', 'Stats'])
            _getTabItem(tabTitle)
        ],
      ),
    );
  }

  Widget _getContentByIdx(int index) {
    switch (index) {
      case 0:
        return const CommentaryWidget(displayMode: 0);
      case 1:
        return Container();
      case 2:
        return Container();
      default:
        return const Text('Default page',
            style: TextStyle(color: Colors.white));
    }
  }

  Widget _getTabContent(int index) {
    return Visibility(
        visible: _tabController.index == index,
        child: SizedBox(
          height: 100,
          child: _getContentByIdx(index),
        ));
  }

  Widget _getBannerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getTabBar(),
        Column(
          children: [
            for (int i = 0; i < 3; i++) _getTabContent(i),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xFF4968DA),
                    Color(0xFFB36AB0),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: _getBannerWidget(),
          ),
        )
      ],
    );
  }
}
