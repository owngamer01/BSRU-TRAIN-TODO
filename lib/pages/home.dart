import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:todo/enum/action_enum.dart';
import 'package:todo/enum/routes_enum.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/provider/todo_provider.dart';
import 'package:todo/provider/user_provider.dart';
import 'package:todo/utils/path_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final PageController pageController = PageController(
    viewportFraction: 0.8
  );
  final _formatDate = DateFormat('MMMM dd, yyyy');

  TodoController _todoController;
  List<List<Color>> randomColor = [
    [Color(0xFF5C45DB), Color(0xFF7D9DE4)],
    [Color(0xFFD44B73), Color(0xFF7DDA25C)],
    [Color(0xFF185a9d), Color(0xFF43cea2)]
  ];

  int _currentPage = 0;
  UserProvider _userProvider;

  _onPageChange(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  _onAction(TodoActionCard action, TodoData todoData) {
    if (action == TodoActionCard.add) {
      addTodo();
    } else if (action == TodoActionCard.remove) { 
      removeTodo(todoData);
    } else {}
  }

  void addTodo() async {
    var todo = await this._todoController.addTodo(TodoData(
      title: 'Todo New',
      colors: randomColor[Random().nextInt(3)],
      createdAt: DateTime.now(),
      tasks: [],
    ));
    if (todo != null) {
      _currentPage = getTodoProvider.length - 1;
      pageJump(_currentPage);
    }
  }

  void removeTodo(TodoData todoData) async {
    if (await _todoController.deleteTodo(todoData)) {
      if (getTodoProvider.length >= this._currentPage && this._currentPage > 0) {
        _currentPage -= 1;
        pageJump(_currentPage);
      }
    }
  }

  void pageJump(int jumpTo) {
    pageController.animateToPage(jumpTo, 
      duration: Duration(milliseconds: 350), 
      curve: Curves.easeOutCubic
    );
  }

  List<TodoData> get getTodoProvider => context.read<TodoProvider>().todo;

  void _toScreenTask(TodoData todo) {
    Navigator.pushNamed(context, RouteApp.tasks.toString(),
      arguments: todo
    );
  }

  @override
  void initState() {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    super.initState();
    _todoController = new TodoController(context);
    _userProvider   = context.read<UserProvider>();
    _todoController.init();
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: todoProvider.todo.length > 0 
                  ? todoProvider.todo[this._currentPage].colors 
                  : [Color(0xFF5C45DB), Color(0xFF7D9DE4)]
              )
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  _bodyToday(),
                  _slideTodo(todoProvider.todo)
                ],
              ),
            )
          );
        }
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RotatedBox(
            quarterTurns: 2,
            child: SvgPicture.asset('assets/menu.svg', height: 24, color: Colors.white)
          ),
          Text("TODO", 
            style: Theme.of(context).textTheme.headline6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500
            )),
          InkWell(
            onTap: addTodo,
            child: Icon(Icons.add, size: 24, color: Colors.white)
          )
        ],
      ),
    );
  }

  Widget _bodyToday() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: MediaQuery.of(context).size.width * 0.12,
        right: MediaQuery.of(context).size.width * 0.12
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF9E9E9E),
              boxShadow: [BoxShadow(
                spreadRadius: -4,
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(4, 4)
              )]
            ),
          ),

          SizedBox(height: 30),

          Text("Hello, " + this._userProvider.user.nickname, style: Theme.of(context).textTheme.headline5.apply(
            color: Colors.white
          )),

          SizedBox(height: 15),

          Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor", style: Theme.of(context).textTheme.caption.apply(
            color: Colors.white
          )),

          SizedBox(height: 30),

          Text.rich(TextSpan(
            text: 'TODAY',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
            children: [TextSpan(
              text: ' : ' + _formatDate.format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.white
              )
            )]
          )),
        ],
      ),
    );
  }

  Widget _slideTodo(List<TodoData> todoList) {
    return Expanded(
      child: PageView(
        controller: pageController,
        onPageChanged: _onPageChange,
        children: todoList.map((todo) => _cardTodo(todo, todoList)).toList(),
      ),
    );
  }

  Widget _cardTodo(TodoData todo, List<TodoData> listTodo) {
    return Padding(
      key: ValueKey(todo.id),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Card(
        child: Material(
          child: InkWell(
            onTap: () {
              _toScreenTask(todo); 
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey[400],
                        )
                      ),
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset('assets/todo.svg', height: 24),
                    ),
                    PopupMenuButton<TodoActionCard>(
                      onSelected: (todoAction) => _onAction(todoAction, todo),
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<TodoActionCard>(
                          value: TodoActionCard.add,
                          child: Text("Add"),
                        ),
                        const PopupMenuItem<TodoActionCard>(
                          value: TodoActionCard.remove,
                          child: Text("Delete"),
                        ),
                      ],
                    ),
                  ],
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('${listTodo[this._currentPage].tasks.length} Tasks', style: Theme.of(context).textTheme.caption),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(listTodo[this._currentPage].title, style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.w500
                        )),
                      ),
                      Container(
                        height: 30,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CustomPaint(
                          painter: PercentPath(
                            min: 1,
                            max: 10,
                            colors: todo.colors
                          )
                        ),
                      ),
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}