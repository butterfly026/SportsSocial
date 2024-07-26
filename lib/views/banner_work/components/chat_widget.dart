import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget _getChatHistory() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Column(
        //   children: [
        //     Expanded(
        //       child: SingleChildScrollView(
        //         child: _getChatHistory(),
        //       ),
        //     )
        //   ],
        // ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.chat,
                color: Colors.black,
              ),
            )
          ],
        )
      ],
    );
  }
}
