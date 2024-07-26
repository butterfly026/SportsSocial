import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sport_social_mobile_mock/services/example_firebase_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';

class HomePage extends StatelessWidget {
  final exampleFirebaseService = ServiceLocator.get<ExampleFirebaseService>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("HOME")),
          ElevatedButton(
            onPressed: () {
              context.go('/team_info');
            },
            child: const Text('Open Team Info Page'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/banner_work');
            },
            child: const Text('Open Banner Page'),
          ),
          ElevatedButton(
            onPressed: () {
              exampleFirebaseService.startMatch();
            },
            child: const Text('Start game'),
          ),
          ElevatedButton(
            onPressed: () {
              exampleFirebaseService.cleanUpMatch();
            },
            child: const Text('End game'),
          ),
        ],
      ),
    );
  }
}
