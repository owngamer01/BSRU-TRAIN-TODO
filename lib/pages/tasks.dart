import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/components/input_components.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:todo/database/task_database.dart';
import 'package:todo/database/todo_database.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/provider/todo_provider.dart';
import 'package:todo/utils/path_utils.dart';
import 'package:todo/utils/debouncer_utils.dart';

class TaskPage extends StatefulWidget {

  final TodoData todo;
  TaskPage(this.todo, { Key key }) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  final TextEditingController _nameController = TextEditingController();
  
  TodoData _todo;
  TodoController _todoController;
  bool isNameInput = false;

  void _addTask() async {
    _todoController.addTask(_todo.id, TaskData(
      name: 'new task',
      status: 0,
      todoId: _todo.id
    ));
    setState(() {});
  }

  void _deleteTask(TaskData taskData) {
    _todoController.deleteTask(_todo.id, taskData);
  }

  void _updateStatusTask(TaskData taskData) {
    taskData.status = taskData.toggleStatus;
    _todoController.updateTask(_todo.id, taskData, {
      '$colStatus' : taskData.status
    });
  }

  void _updateNameTodo() async {
    await _todoController.updateTodo(_todo, {
      '$colTitle' : _nameController?.text
    }, onReload: true);
    _todo.title = _nameController?.text;
    this._toggleTitleInput();
  }

  void _updateTextTask(TaskData taskData, String text) {
    _debouncer.run(() {
      taskData.name = text;
      _todoController.updateTask(_todo.id, taskData, {
        '$colName' : text
      }, onReload: false);
    });
  }

  TodoData mapController(TodoData todoData) {
    for (var task in todoData.tasks) {
      if (task.controller == null) {
        task.controller = TextEditingController(text: task.name);
      } else {
        task.controller?.text = task.name;
      }
    }
    return todoData;
  }

  void _toggleTitleInput() {
    setState(() {
      isNameInput = !isNameInput;
    });
  }
  
  @override
  void initState() {
    _todo = TodoData.fromMap(widget.todo.toMap());
    super.initState();
    _todoController = TodoController(context);
    _nameController.text = _todo.title;
    _todoController.init();
  }

  @override
  void dispose() {
    _debouncer?.dispose();
    _nameController?.dispose();
    for (var task in _todo.tasks) {
      task.controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Consumer<TodoProvider>(
            builder: (context, todoProvider, child) {
              final todoMap = this.mapController(todoProvider.getTodo(_todo));
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleApp(),
                    _totalTask(todoMap)
                  ],
                ),
              );
            }
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addTask,
      )
    );
  }

  Widget _titleApp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _totalTask(TodoData todoData) {
    final countStatus = todoData.tasks.where((item) => item.status == 1).length;
    return Container(
      margin: EdgeInsets.only(left: 10, top: 0, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[400],
              )
            ),
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset('assets/todo.svg', height: 24),
          ),
          Text("${todoData.tasks.length} tasks"),
          
          SizedBox(height: 10),

          !isNameInput ? 
          InkWell(
            onDoubleTap: _toggleTitleInput,
            child: Text(todoData.title ?? '',
              style: Theme.of(context).textTheme.headline5
            )
          )
          : Row(
            children: [
              Expanded(child: InputComponent(_nameController)),
              IconButton(
                onPressed: _updateNameTodo,
                icon: Icon(Icons.check, color: Colors.greenAccent[400])
              )
            ],
          ), 

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 10,
                  child: CustomPaint(
                    painter: PercentPath(
                      min: countStatus,
                      max: todoData.tasks.length,
                      colors: [Colors.blue[800], Colors.blue[100]]
                    )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(((countStatus * 100) / todoData.tasks.length).toStringAsFixed(2).toString() + "%", style: Theme.of(context).textTheme.bodyText2)
              )
            ],
          ),

          SizedBox(height: 20),
          Text(DateFormat('EEEE, MMM dd, yyyy').format(DateTime.now())),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todoData.tasks.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                key: ValueKey(todoData.tasks[index].id),
                value: todoData.tasks[index].status == 1,
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                controlAffinity: ListTileControlAffinity.leading,
                title: InputComponent(
                  todoData.tasks[index].controller,
                  onChange: (text) {
                    _updateTextTask(todoData.tasks[index], text);
                  },
                ),
                secondary: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      iconSize: 24,
                      icon: Icon(Icons.delete), 
                      onPressed: () { _deleteTask(todoData.tasks[index]); }
                    ),
                  ],
                ),
                onChanged: (_) {
                  _updateStatusTask(todoData.tasks[index]);
                }
              );
            },
          )
        ],
      )
    );
  }
}