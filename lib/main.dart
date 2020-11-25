import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/enum/routes_enum.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/pages/Acesss/login.dart';
import 'package:todo/pages/Acesss/register.dart';
import 'package:todo/pages/tasks.dart';
import 'package:todo/provider/todo_provider.dart';

import 'pages/home.dart';
import 'pages/intro.dart';
import 'provider/user_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider())
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Color(0xFF301D9A),
              accentColor: Color(0xFF301D9A),
              buttonTheme: ButtonThemeData(
                buttonColor: Color(0xFF301D9A),
                textTheme: ButtonTextTheme.primary,
                padding: EdgeInsets.symmetric(vertical: 10)
              ),
              fontFamily: 'poppins',
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            
            initialRoute: RouteApp.root.toString(),

            // # static routes
            routes: {
              RouteApp.root.toString():       (_) => RootPage(),
              RouteApp.login.toString():       (_) => LoginPage(),
              RouteApp.register.toString():   (_) => RegisterPage(),
              RouteApp.intro.toString():      (_) => IntroPage(),
              RouteApp.home.toString():       (_) => HomePage(),
            },

            // # dynamic route
            onGenerateRoute: (settings) {

              var route = RouteApp.values.firstWhere(
                (route) => route.toString() == settings.name,
                orElse: () => null
              );

              switch (route) {
                case RouteApp.tasks:
                  final TodoData todo = settings.arguments;
                  return MaterialPageRoute(builder: (_) => TaskPage(todo));
                  break;
                default: 
                  return MaterialPageRoute(builder: (_) => RootPage());
              }
            },
          ),
        ),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  AuthController authController;

  void initAuth() async {

    await Future.delayed(Duration(seconds: 1));
    
    authController = AuthController(context);
    final res = await authController.verifyUser();
    if (res != null) {
      Navigator.pushNamed(context, RouteApp.home.toString());
    }
    else {
      Navigator.pushNamed(context, RouteApp.login.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initAuth();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
