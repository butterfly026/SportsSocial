import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  List<ChatModel> lstChatHistory = [
    const ChatModel(
        id: '1',
        userAvatar: 'https://mdbcdn.b-cdn.net/img/new/avatars/2.webp',
        userName: 'United Fanboy',
        time: '2024-07-26 11:35',
        content: 'OK! I think its time to bring in Case and Mount. What Y\'all think?')
  ];
  @override
  void initState() {
    super.initState();
  }

  Widget _getChatHistory() {
    return ListView.builder(
      itemCount: lstChatHistory.length,
      itemBuilder: (context, index) {
        return Container();
      });
  }

  Widget _getChatButton(IconData icon, VoidCallback? onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getChatButtonGroup() {
    return Container(
      decoration: const BoxDecoration(color: Color(0x35FFFFFF)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getChatButton(Icons.chat_outlined, null),
            const SizedBox(width: 25.0),
            _getChatButton(Icons.mic_none, null),
            const SizedBox(width: 25.0),
            _getChatButton(Icons.stop, null),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: _getChatHistory(),
          ),
        ),
        Expanded(
          child: Column(
            children: [const Spacer(), _getChatButtonGroup()],
          ),
        ),
      ],
    );
  }
}
