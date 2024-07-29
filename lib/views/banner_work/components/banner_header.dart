import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/commentary_widget.dart';

class BannerHeader extends StatefulWidget {
  const BannerHeader(
      {super.key,
      required this.expandMode,
      required this.bannerHeight,
      this.onExpand});
  final int expandMode;
  final double bannerHeight;
  final Function(int expanded)? onExpand;

  @override
  State<BannerHeader> createState() => _BannerHeaderState();
}

class _BannerHeaderState extends State<BannerHeader>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Function(int expanded)? onExpand;
  final List<String> tabContentNames = [
    'commentary',
    'gameSummary',
    'statistics'
  ];

  int expandMode = 0;
  double bannerHeight = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    expandMode = widget.expandMode;
    bannerHeight = widget.bannerHeight;
    onExpand = widget.onExpand;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BannerHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (expandMode != widget.expandMode) {
      setState(() {
        expandMode = widget.expandMode;
      });
    }
    if (bannerHeight != widget.bannerHeight) {
      setState(() {
        bannerHeight = widget.bannerHeight;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _getTabItem(String tabTitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 35),
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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 1.0),
        ),
        unselectedLabelColor: Colors.white,
        // labelStyle: const TextStyle(fontSize: 10.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
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

  Widget _getContentByName(String contentName) {
    switch (contentName) {
      case 'commentary':
        return CommentaryWidget(expandMode: expandMode);
      case 'gameSummary':
        return Container();
      case 'statistics':
        return Container();
      default:
        return const Text('Default page',
            style: TextStyle(color: Colors.white));
    }
  }

  Widget _getTabContent(String contentName) {
    return Visibility(
        visible: _tabController.index == tabContentNames.indexOf(contentName),
        child: SizedBox(
          height: bannerHeight,
          child: _getContentByName(contentName),
        ));
  }

  Widget _getExpandIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          expandMode = (expandMode + 1) % 2;
          if(onExpand != null) {
            onExpand!(expandMode);
          }
        });
      },
      child: const Padding(
        padding: EdgeInsets.only(right: 2),
        child: Icon(
          Icons.open_in_full,
          color: Colors.black,
          size: 18,
        ),
      ),
    );
  }

  Widget _getBannerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _getTabBar()),
            _getExpandIcon(),
          ],
        ),
        Column(
          children: [
            _getTabContent('commentary'),
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
            padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
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
