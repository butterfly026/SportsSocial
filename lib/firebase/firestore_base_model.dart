abstract class FireStoreBaseModel {
  const FireStoreBaseModel();
  FireStoreBaseModel.fromJson(Map<String, dynamic>? json);
  Map<String, dynamic> toJson();
}
