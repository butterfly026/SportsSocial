import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/services/routes.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';

void main() {
  ServiceLocator.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ServiceLocator.getIt.allReady(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Mock App',
            routerConfig: appRouter(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
