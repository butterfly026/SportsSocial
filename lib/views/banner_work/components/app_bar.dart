import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class SubPageAppBar extends AppBar {
  SubPageAppBar({
    super.key,
    super.automaticallyImplyLeading,
    String? titleText,
    super.toolbarHeight,
    List<Widget>? actions,
    super.titleSpacing,
    Widget? leading,
    Widget? titleWidget,
    super.bottom,
  }) : super(
            title: titleWidget ?? _getTitleTextWidget(titleText),
            leading: _getLeadingWidget(),
            flexibleSpace:_getGradientAppBarBackground(),
            backgroundColor: const Color(0xFF15182C),
            centerTitle: false);

  @override
  Size get preferredSize => const Size(double.infinity, 40.0);

  static Widget _getTitleTextWidget(String? titleText) {
    return Transform.translate(
      offset: const Offset(-30, 0.0), // Adjust this offset as needed
      child: Text(
        titleText ?? '',
        style: const TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }

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
