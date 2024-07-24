import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_social_mobile_mock/firebase/firebase_utils.dart';
import 'package:sport_social_mobile_mock/models/channel_model.dart';

class ExampleFirebaseService {
  final String _channelColelction = 'channels';
  final String _channelId = 'Nqm7dwogKL7VhSBBhphw';

  CollectionReference<ChannelModel> get channelRef =>
      collectionRefWithConverter<ChannelModel>(
        _channelColelction,
        ChannelModel.fromJson,
      );

  Future<ExampleFirebaseService> initialize() async {
    return this;
  }

  Future<ChannelModel?> getChannel() async {
    final DocumentSnapshot<ChannelModel> snapshot =
        await channelRef.doc(_channelId).get();
    return snapshot.data();
  }
}
