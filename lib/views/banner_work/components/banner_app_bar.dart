import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BannerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BannerAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size(double.infinity, 40.0);

  static Widget getTeamBadge(String? badgeUrl) {
    return CachedNetworkImage(
        imageUrl: badgeUrl ?? '',
        width: 20.0,
        height: 20.0,
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
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/36534.png'),
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
              'https://d1bvoel1nv172p.cloudfront.net/competitors/images/normal/medium/22007.png'),
        ],
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: _getTitleWidget(),
        leading: _getLeadingWidget(),
        flexibleSpace: _getGradientAppBarBackground(),
        centerTitle: false);
  }
}
