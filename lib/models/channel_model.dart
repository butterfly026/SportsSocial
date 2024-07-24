import 'package:sport_social_mobile_mock/firebase/firestore_base_model.dart';

class ChannelModel implements FireStoreBaseModel {
  final String id;
  final String name;
  final String displayName;
  final String icon;
  final List<String> colors;

  const ChannelModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.colors,
  });

  ChannelModel.fromJson(Map<String, dynamic>? json)
      : this(
          id: json?['id'],
          name: json?['name'],
          displayName: json?['displayName'],
          icon: json?['icon'],
          colors: List<String>.from(json?['colors']),
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'displayName': displayName,
      'icon': icon,
      'colors': colors,
    };
  }
}
