import 'package:go_router/go_router.dart';
import 'package:sport_social_mobile_mock/views/banner_work/banner_work_page.dart';
import 'package:sport_social_mobile_mock/views/team_info/team_info_page.dart';
import 'package:sport_social_mobile_mock/views/home_page.dart';

GoRouter appRouter() {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        name: 'team_info',
        path: '/team_info',
        builder: (context, state) => const TeamInfoPage(),
      ),
      GoRoute(
        name: 'banner_work',
        path: '/banner_work',
        builder: (context, state) => const BannerWorkPage(),
      ),
    ],
  );
}
