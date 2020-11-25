import 'package:flutter/material.dart';
import 'package:todo/components/input_components.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/enum/provider_enum.dart';
import 'package:todo/enum/routes_enum.dart';
import 'package:todo/models/user_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final userController = TextEditingController();
  final passwordController = TextEditingController();
  AuthController authController;

  void _login(){
    var userData = UserData(
      username: userController.text,
      password: passwordController.text
    );
    authController.onLogin(LoginThirdParty.normal, userData);
  }

  @override
  void initState() {
    super.initState();
    authController = AuthController(context);
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _logo(),
              _textField(),
              _loginButton()
            ],
          ),
        )
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 70),
        width: 150,
        child: Image.asset('assets/logo.png')
      ),
    );
  }

  Widget _textField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Login to your account", style: Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500
        )),
        SizedBox(height: 10),
        InputComponent(
          userController,
          decoration: InputDecoration(
            hintText: 'Username'
          ),
        ),
        InputComponent(
          passwordController,
          isPassword: true,
          decoration: InputDecoration(
            hintText: 'password'
          ),
        )
      ]
    );
  }

  Widget _loginButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text("Login", style: TextStyle(
              fontSize: 16
            )),
            onPressed: _login
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Expanded(child: Divider(thickness: 2, height: 10)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("OR"),
              ),
              Expanded(child: Divider(thickness: 2, height: 10)),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteApp.register.toString());
          }, 
          child: Text("Register", style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black
          ))
        )
      ]
    );
  }
}