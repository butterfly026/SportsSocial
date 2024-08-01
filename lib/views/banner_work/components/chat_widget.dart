import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate mock data
    List<String> messages = List.generate(100, (index) => 'Message $index');

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(messages[index],
              style: const TextStyle(color: Colors.white)),
        );
      },
    );
  }
}
