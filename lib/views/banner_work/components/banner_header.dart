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

  late double _currentBannerHeight;
  final double _defaultBannerHeight = 100;
  final double _offsetBannerHeight = 55;
  final double _summaryFullHeight = 330;
  double _dragYStart = 0;
  double _dragYEnd = 0;
  bool _expanded = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentBannerHeight = _defaultBannerHeight;
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

  Widget _tabBar() {
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

  Widget _getExpandIcon() {
    final maxHeight = MediaQuery.of(context).size.height - 150;
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
          _currentBannerHeight = _expanded ? maxHeight : _defaultBannerHeight;
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

  Widget _tabContent() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          CommentaryWidget(isDragging: _isDragging),
          GameSummaryWidget(expanded: _expanded),
          Container(),
        ],
      ),
    );
  }

  Widget _getBannerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _tabBar()),
            _getExpandIcon(),
          ],
        ),
        _tabContent(),
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
          _isDragging = true;
          _dragYStart = details.globalPosition.dy;
        });
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        setState(() {
          double positionY = details.globalPosition.dy;
          if (positionY < 270) {
            _currentBannerHeight = _defaultBannerHeight;
          } else if (positionY <= maxHeight + 110) {
            _currentBannerHeight = positionY - 110;
          }
          if (_tabController.index == 1) {
            if (_currentBannerHeight > _summaryFullHeight && !_expanded) {
              _expanded = true;
            } else if (_currentBannerHeight < _summaryFullHeight && _expanded) {
              _expanded = false;
            }
          }
        });
      },
      onVerticalDragEnd: (details) {
        setState(() {
          _dragYEnd = details.globalPosition.dy;
          double offset = _dragYEnd - _dragYStart;
          double defaultOffset = 150;
          if (offset > defaultOffset) {
            _currentBannerHeight = maxHeight;
          } else if ((offset > 0 && offset <= defaultOffset) ||
              (offset >= -defaultOffset && offset < 0)) {
            _currentBannerHeight = _expanded ? maxHeight : _defaultBannerHeight;
          } else if (offset < -defaultOffset) {
            _currentBannerHeight = _defaultBannerHeight;
          }
          if (_currentBannerHeight == _defaultBannerHeight) {
            _expanded = false;
          } else {
            _expanded = true;
          }
          _isDragging = false;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10.0),
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
      duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _currentBannerHeight + _offsetBannerHeight,
      child: Column(
        children: [
          Expanded(child: _getBannerWidget()),
          _getExpandDragArea(),
        ],
      ),
    ).animate();
  }
}
