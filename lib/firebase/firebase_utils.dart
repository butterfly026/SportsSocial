import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sport_social_mobile_mock/firebase/firestore_base_model.dart';

CollectionReference<T> collectionRefWithConverter<T extends FireStoreBaseModel>(
    String collection, Function fromJson) {
  return FirebaseFirestore.instance.collection(collection).withConverter<T>(
      fromFirestore: (snapshot, _) {
        Map<String, dynamic>? json = snapshot.data();
        if (json != null) {
          json['id'] = snapshot.id;
        }
        return fromJson(json);
      },
      toFirestore: (model, _) => model.toJson());
}

CollectionReference<T>
    subCollectionRefWithConverter<T extends FireStoreBaseModel>(
        String path, Function fromJson) {
  List<String> pathParts = path.split('/');
  if (pathParts.length % 2 == 0) {
    throw Exception('Path must have even bars');
  }

  var ref = FirebaseFirestore.instance.collection(pathParts[0]);
  DocumentReference? doc;

  for (int i = 1; i < pathParts.length; i++) {
    if (i % 2 != 0) {
      doc = ref.doc(pathParts[i]);
    } else {
      ref = doc!.collection(pathParts[i]);
    }
  }

  return ref.withConverter<T>(
      fromFirestore: (snapshot, _) {
        Map<String, dynamic>? json = snapshot.data();
        if (json != null) {
          json['id'] = snapshot.id;
        }
        return fromJson(json);
      },
      toFirestore: (model, _) => model.toJson());
}
