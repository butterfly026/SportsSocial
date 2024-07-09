import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/services/data_mock_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';

class DataMockPage extends StatelessWidget {
  final dataMockService = ServiceLocator.get<DataMockService>();

  DataMockPage({super.key});

  Widget _showNewsJson() {
    return ValueListenableBuilder(
        valueListenable: dataMockService.newsNotifier,
        builder: (context, news, child) {
          String prettyJson = jsonEncode(news);
          return SingleChildScrollView(
            child: Text(
              prettyJson,
              style: const TextStyle(
                fontFamily: 'Monospace',
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mock View'),
      ),
      body: Center(child: _showNewsJson()),
    );
  }
}
