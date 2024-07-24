import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        ],
      ),
    );
  }
}
