import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/user_database.dart';
import 'package:todo/enum/alert_enum.dart';
import 'package:todo/enum/provider_enum.dart';
import 'package:todo/enum/routes_enum.dart';
import 'package:todo/models/user_model.dart';
import 'package:todo/provider/user_provider.dart';
import 'package:todo/utils/dialog_utils.dart';

class AuthController {

  AuthController(this._context) : 
    _dialog = DialogUtils(_context);

  final UserDatabase _database = UserDatabase();
  final DialogUtils _dialog;
  final BuildContext _context;

  Future<bool> onLogin(LoginThirdParty loginThirdParty, UserData userData) async {
    if (loginThirdParty == LoginThirdParty.normal) return await _login(userData);
    // else if (registerApp == RegisterApp.facebook) _registerFacebook(userData);
    // else if (registerApp == RegisterApp.google) _registerGoogle(userData);
    return false;
  }

  Future<UserData> verifyUser() async {
    final res = await _database.verifyUser();
    if (res.isError) {
      return null;
    }
    this._context.read<UserProvider>().setUser(res.userData);
    return res.userData;
  }
  
  Future<bool> _login(UserData userData) async {
    var response = await _database.getUserById(userData);
    if (response.isError) {
      this._dialog.show(
        dialogApp: AlertApp.warning,
        title: response.title,
        content: response.context
      );
      return false;
    }

    // # set provider
    this._context.read<UserProvider>().setUser(response.userData);

    // # push to next page
    Navigator.pushNamed(this._context, 
      response.userData.isFirstTime > 0
        ? RouteApp.intro.toString()
        : RouteApp.home.toString()
    );
  
    return true;
  }

  Future<bool> updateUser(UserData user) async {
    final response = await _database.updateUser(user);
    if (response.isError) {
      this._dialog.show(
        dialogApp: AlertApp.warning,
        title: response.title,
        content: response.context
      );
      return false;
    }
    return true;
  }
  
}