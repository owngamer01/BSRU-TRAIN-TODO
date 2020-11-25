import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/enum/routes_enum.dart';
import 'package:todo/provider/user_provider.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  int _currentPage = 0;

  final _pageController = PageController();
  final _todoMap = [{
    'title': 'Todo 1',
    'content': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis',
    'icon': 'intro1'
  }, {
    'title': 'Todo 2',
    'content': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis',
    'icon': 'intro2'
  }, {
    'title': 'Todo 3',
    'content': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis',
    'icon': 'intro3'
  }];

  void _pageChange(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
    });
  }

  void _nextPage() async {
    
    var user = context.read<UserProvider>().user;
    user.isFirstTime = 0;

    AuthController(context).updateUser(user).then((status) {
      if (!status) return;
      Navigator.pushNamed(context, RouteApp.home.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _page(),
          _pointer()
        ]
      )
    );
  }

  Widget _page() {
    return Expanded(
      child: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: _pageChange,
        children: _todoMap.map((map) => Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.7,
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 40
              ),
              child: SvgPicture.asset('assets/icon/intro/${map['icon']}.svg',
                alignment: Alignment.bottomCenter,
                fit: BoxFit.scaleDown
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(map['title'], style: Theme.of(context).textTheme.headline6),
            ),
            Text(map['content'], 
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2)
          ],
        )).toList(),
      ),
    );
  }

  Widget _pointer() {
    return Column(
      children: [
        _currentPage >= (_todoMap.length - 1)
        ? FadeIn(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: RaisedButton(
              onPressed: _nextPage,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Next"),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_right_alt)
                ],
              ),
            ),
          ),
        )
        : Container(),
        Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _todoMap.asMap().entries.map((map) => 
              Container(
                width: 10,
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: map.key == _currentPage 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey[300],
                  shape: BoxShape.circle
                ),
              )
            ).toList()
          ),
        ),
      ],
    );
  }
}