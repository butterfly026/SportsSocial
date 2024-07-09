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
              context.go('/data_mock');
            },
            child: const Text('Open Data Mock Page'),
          ),
        ],
      ),
    );
  }
}
