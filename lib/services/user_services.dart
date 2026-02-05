// AC Chill - Firebase Firestore removed (stub file)
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:nb_utils/nb_utils.dart';

import 'base_services.dart';

class UserService extends BaseService {
  UserService();

  Future<bool> isUserExistWithUid(String? uid) async {
    return false;
  }

  Future<void> deleteUser() async {
    // Firebase Auth disabled
  }
}
