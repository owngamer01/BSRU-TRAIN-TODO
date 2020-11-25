import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/user_database.dart';
import 'package:todo/enum/alert_enum.dart';
import 'package:todo/enum/routes_enum.dart';
import 'package:todo/provider/user_provider.dart';
import 'package:todo/utils/dialog_utils.dart';
import 'package:todo/enum/provider_enum.dart';
import 'package:todo/models/user_model.dart';

class RegisterController {

  final UserDatabase databaseUser = UserDatabase();
  final DialogUtils _dialogs;
  final BuildContext _context;

  RegisterController(this._context) : 
    assert(_context != null),
    _dialogs = DialogUtils(_context);

  Future<bool> onRegister(LoginThirdParty registerApp, UserData userData) async {

    if (registerApp == LoginThirdParty.normal) return await _register(userData);
    // else if (registerApp == RegisterApp.facebook) _registerFacebook(userData);
    // else if (registerApp == RegisterApp.google) _registerGoogle(userData);
    return false;
  }

  bool isEmpty(UserData userData) {
    return 
      userData.email.isEmpty ||
      userData.nickname.isEmpty ||
      userData.password.isEmpty ||
      userData.username.isEmpty;
  }

  Future<bool> _register(UserData userData) async {
    try {

      // # save user
      var response = await databaseUser.insertUser(userData);

      // # error
      if (response.isError) {
        this._dialogs.show(
          dialogApp: AlertApp.warning,
          title: response.title,
          content: response.context
        );
        return false;
      }

      // # set user
      this._context.read<UserProvider>().setUser(response.userData);

      // # success
      this._dialogs.show(
        dialogApp: AlertApp.success,
        title: response.title,
        content: response.context,
        action: () {
          Navigator.pushNamed(this._context, RouteApp.intro.toString());
        }
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // _registerFacebook(UserData userData) {}
  // _registerGoogle(UserData userData) {}
}
