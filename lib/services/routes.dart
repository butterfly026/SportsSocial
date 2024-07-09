import 'package:go_router/go_router.dart';
import 'package:sport_social_mobile_mock/views/data_mock_page.dart';
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
        name: 'data_mock',
        path: '/data_mock',
        builder: (context, state) => DataMockPage(),
      ),
    ],
  );
}
