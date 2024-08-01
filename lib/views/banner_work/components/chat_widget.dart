import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/chat_model.dart';
import 'package:sport_social_mobile_mock/views/banner_work/components/triangle_clipper.dart';

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
        content:
            'OK! I think its time to bring in Case and Mount. What Y\'all think?'),
    const ChatModel(
        id: '2',
        userAvatar: 'https://mdbcdn.b-cdn.net/img/new/avatars/3.webp',
        userName: 'United Fan',
        imgUrl:
            'https://mobilecoderz.com/blog/wp-content/uploads/2022/05/Flutter-3.0-Released-Know-The-Latest-Features-Updates-Here.png',
        time: '2024-07-26 11:35',
        content: 'That was my favorite team, Time to go for the kill'),
    const ChatModel(
        id: '3',
        userAvatar: 'https://mdbcdn.b-cdn.net/img/new/avatars/4.webp',
        userName: 'Dennis Pro',
        time: '2024-07-28 11:35',
        content:
            'OK! I think its time to bring in Case and Mount. What Y\'all think?'),
    const ChatModel(
        id: '4',
        userAvatar: 'https://mdbcdn.b-cdn.net/img/new/avatars/5.webp',
        userName: 'William Chan',
        time: '2024-07-29 11:35',
        imgUrl:
            'https://mobilecoderz.com/blog/wp-content/uploads/2022/05/Flutter-3.0-Released-Know-The-Latest-Features-Updates-Here.png',
        content:
            'OK! I think its time to bring in Case and Mount. What Y\'all think?'),
    const ChatModel(
        id: '5',
        userAvatar: 'https://mdbcdn.b-cdn.net/img/new/avatars/6.webp',
        userName: 'Michael Mar',
        time: '2024-07-30 11:35',
        content:
            'OK! I think its time to bring in Case and Mount. What Y\'all think?'),
    const ChatModel(
        id: '6',
        userAvatar: 'https://mdbcdn.b-cdn.net/img/new/avatars/7.webp',
        userName: 'Drontie',
        time: '2024-07-31 11:35',
        content: 'Let\'s go!!! Game is super interesting!!')
  ];
  @override
  void initState() {
    super.initState();
  }

  Widget _getUserAvatar(String url) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: const Size.fromRadius(15), // Image radius
        child: CachedNetworkImage(
          imageUrl: url,
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget _getUserNameMsgTime(ChatModel chat) {
    return Row(
      children: [
        Text(
          chat.userName,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(width: 5.0),
        Text(
          chat.time,
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF93939F)),
        ),
      ],
    );
  }

  Widget _getTextMessageContent(ChatModel chat) {
    return Text(
      chat.content ?? '',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }

  Widget _getImageContent(ChatModel chat) {
    return CachedNetworkImage(
      imageUrl: chat.imgUrl ?? '',
      placeholder: (context, url) => const SizedBox(
        width: 50.0,
        height: 50.0,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.0,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        return const SizedBox(
            width: 12.0,
            height: 12.0,
            child: Center(
              child: Icon(Icons.error, color: Colors.grey, size: 14.0),
            ));
      },
    );
  }

  Widget _getChatMsgContent(ChatModel chat) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8, // Limit width
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF535457),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getUserNameMsgTime(chat),
          if (chat.imgUrl != null) _getImageContent(chat),
          if (chat.content != null) _getTextMessageContent(chat),
        ],
      ),
    );
  }

  Widget _getChatItem(ChatModel chat, bool isLastItem) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, bottom: 10.0, right: 5.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getUserAvatar(chat.userAvatar),
              const SizedBox(width: 5.0),
              ClipPath(
                clipper: TriangleClipper(),
                child: Container(
                  color: const Color(0xFF535457),
                  height: 10,
                  width: 10,
                ),
              ),
              _getChatMsgContent(chat)
            ],
          ),
          if (isLastItem) const SizedBox(height: 80)
        ],
      ),
    );
  }

  Widget _getChatHistory() {
    return ListView.builder(
        itemCount: lstChatHistory.length,
        itemBuilder: (context, index) {
          return _getChatItem(
              lstChatHistory[index], index == lstChatHistory.length - 1);
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
        Positioned.fill(
          child: _getChatHistory(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _getChatButtonGroup(),
        ),
      ],
    );
  }
}
