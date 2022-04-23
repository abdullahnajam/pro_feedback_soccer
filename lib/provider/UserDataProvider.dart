import 'package:flutter/cupertino.dart';
import 'package:pro_feedback_soccer/model/users.dart';

class UserDataProvider extends ChangeNotifier {
  UserModel? userData;
  void setUserData(UserModel user) {
    this.userData = user;
    notifyListeners();
  }
}
