import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BannerAppBar extends AppBar {
  BannerAppBar({
    super.key,
    Widget? titleWidget,
  }) : super(
            title: titleWidget,
            leading: _getLeadingWidget(),
            flexibleSpace:_getGradientAppBarBackground(),
            centerTitle: false);

  @override
  Size get preferredSize => const Size(double.infinity, 40.0);

  static Widget _getLeadingWidget() {
    return Transform.translate(
      offset: const Offset(-8, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  static Widget _getGradientAppBarBackground() {
    return Container(
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
    );
  }
}
