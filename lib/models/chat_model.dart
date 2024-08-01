import 'package:sport_social_mobile_mock/firebase/firestore_base_model.dart';

class ChatModel  implements FireStoreBaseModel {
  final String id;
  final String userAvatar;
  final String userName;
  final String time;
  final String? content;
  final String? imgUrl;
  final String? videoUrl;

  const ChatModel({
    required this.id,
    required this.userAvatar,
    required this.userName,
    required this.time,
    this.content,
    this.imgUrl,
    this.videoUrl,
  });

  ChatModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] ?? '',
          userAvatar: json['userAvatar'] ?? '',
          userName: json['userName'] ?? '',
          time: json['time'] ?? '',
          content: json['content'],
          imgUrl: json['imgUrl'],
          videoUrl: json['videoUrl'],
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userAvatar': userAvatar,
      'userName': userName,
      'time': time,
      'content': content,
      'imgUrl': imgUrl,
      'videoUrl': videoUrl,
    };
  }
}
