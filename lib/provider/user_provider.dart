import 'package:flutter/foundation.dart';
import 'package:todo/models/user_model.dart';

class UserProvider with ChangeNotifier {
  
  UserData get user => _user;
  UserData _user;

  void setUser(UserData oldUser) {
    _user = oldUser;
    notifyListeners();
  }
  
}