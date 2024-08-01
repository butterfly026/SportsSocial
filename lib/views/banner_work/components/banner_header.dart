import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/commentary_widget.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/game_summary_widget.dart';

class BannerHeader extends StatefulWidget {
  const BannerHeader({super.key});

  @override
  State<BannerHeader> createState() => _BannerHeaderState();
}

class _BannerHeaderState extends State<BannerHeader>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabContentNames = [
    'commentary',
    'gameSummary',
    'statistics'
  ];

  late double currentBannerHeight;
  double defaultBannerHeight = 100;
  double offsetBannerHeight = 55;
  double dragYStart = 0;
  double dragYEnd = 0;
  bool expanded = false;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    currentBannerHeight = defaultBannerHeight;
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
        return CommentaryWidget(isDragging: isDragging);
      case 'gameSummary':
        return GameSummaryWidget(expandMode: expanded);
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
        child: AnimatedContainer(
          height: currentBannerHeight,
          duration:
              isDragging ? Duration.zero : const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _getContentByName(contentName),
        ));
  }

  Widget _getExpandIcon() {
    final maxHeight = MediaQuery.of(context).size.height - 150;
    return GestureDetector(
      onTap: () {
        bool tmpExpanded = !expanded;
        if (_tabController.index == 1 && tmpExpanded) {
          Future.delayed(const Duration(milliseconds: 150), () {
            setState(() {
              expanded = tmpExpanded;
            });
          });
          setState(() {
            currentBannerHeight = tmpExpanded ? maxHeight : defaultBannerHeight;
          });
        } else {
          setState(() {
            expanded = tmpExpanded;
            currentBannerHeight = expanded ? maxHeight : defaultBannerHeight;
          });
        }
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
            _getTabContent('gameSummary'),
            _getTabContent('statistics'),
          ],
        ),
      ],
    );
  }

  Widget _getExpandDragIcon() {
    return Transform.translate(
      offset: const Offset(0, 2.0),
      child: Container(
        height: 5,
        width: 30,
        decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(6))),
      ),
    );
  }

  Widget _getExpandDragArea() {
    final maxHeight = MediaQuery.of(context).size.height - 150;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (details) {
        setState(() {
          isDragging = true;
          dragYStart = details.globalPosition.dy;
        });
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        setState(() {
          double positionY = details.globalPosition.dy;
          if (positionY < 270) {
            currentBannerHeight = defaultBannerHeight;
          } else if (positionY <= maxHeight + 110) {
            currentBannerHeight = positionY - 110;
          }
          if (_tabController.index == 1) {
            if (currentBannerHeight > 300 && expanded == 0) {
              expanded = true;
            } else if (currentBannerHeight < 300 && expanded == 1) {
              expanded = false;
            }
          }
        });
      },
      onVerticalDragEnd: (details) {
        setState(() {
          dragYEnd = details.globalPosition.dy;
          double offset = dragYEnd - dragYStart;
          double defaultOffset = 150;
          if (offset > defaultOffset) {
            currentBannerHeight = maxHeight;
          } else if ((offset > 0 && offset <= defaultOffset) ||
              (offset >= -defaultOffset && offset < 0)) {
            currentBannerHeight = expanded ? maxHeight : defaultBannerHeight;
          } else if (offset < -defaultOffset) {
            currentBannerHeight = defaultBannerHeight;
          }
          if (currentBannerHeight == defaultBannerHeight) {
            expanded = false;
          } else {
            expanded = true;
          }
          isDragging = false;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 5.0),
          _getExpandDragIcon(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.only(top: 5.0),
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
      duration: isDragging ? Duration.zero : const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: currentBannerHeight + offsetBannerHeight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _getBannerWidget(),
          _getExpandDragArea(),
        ],
      ),
    ).animate();
  }
}
