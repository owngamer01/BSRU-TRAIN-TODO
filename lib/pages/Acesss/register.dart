import 'package:flutter/material.dart';
import 'package:todo/components/avatar_components.dart';
import 'package:todo/components/input_components.dart';
import 'package:todo/controller/register_controller.dart';
import 'package:todo/enum/provider_enum.dart';
import 'package:todo/models/user_model.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  UserData _userData;
  RegisterController _registerController;

  final nickController     = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController    = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _register() {

    if(!_formKey.currentState.validate()) {
      return;
    }

    _userData = UserData(
      email: emailController.text,
      nickname: nickController.text,
      password: passwordController.text,
      username: usernameController.text
    );

    _registerController.onRegister(LoginThirdParty.normal, _userData);

    // print(_userData.toJson());
  }

  @override
  void initState() {
    super.initState();
    _registerController = RegisterController(context);
  }

  @override
  void dispose() {
    nickController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: _formKey,
            child: Column(
              children: [
                AvatarComponent(),
                InputComponent(
                  nickController,
                  labelText: 'Nickname',
                  decoration: InputDecoration(
                    hintText: 'Nickname',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                InputComponent(
                  emailController,
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email)
                  ),
                ),
                InputComponent(
                  usernameController,
                  labelText: 'Username',
                  decoration: InputDecoration(
                    hintText: 'Username',
                  ),
                ),
                InputComponent(
                  passwordController,
                  labelText: 'Password',
                  isPassword: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Register", style: TextStyle(
                      fontSize: 16
                    )),
                    onPressed: _register
                  )
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
}