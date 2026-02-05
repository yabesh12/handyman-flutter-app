// AC Chill - Firebase Firestore removed (stub file)
import 'package:nb_utils/nb_utils.dart';

abstract class BaseService {
  dynamic ref;

  BaseService({this.ref});

  Future<dynamic> addDocument(Map data) async {
    // Firestore disabled
    return null;
  }

  Future<dynamic> addDocumentWithCustomId(String id, Map<String, dynamic> data) async {
    // Firestore disabled
    return null;
  }

  Future<void> updateDocument(Map<String, dynamic> data, String? id) async {
    // Firestore disabled
  }

  Future<void> removeDocument(String id) async {
    // Firestore disabled
  }

  Future<bool> isUserExist(String? email) async {
    return false;
  }

  Future<bool> isUserExistWithUid(String? uid) async {
    return false;
  }

  Future<Iterable> getList() async {
    return [];
  }
}
