import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:simpletodo/database/moor_database.dart';
import 'package:simpletodo/ui/widgets/new_task_input_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: AppBar(
        title: Text('Tasks'),
        centerTitle: true,
        leading: Icon(
          Icons.done_all,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildTaskList(context)),
          NewTaskInput(),
        ],
      ),
    );
  }
}

StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
  final database = Provider.of<AppDatabase>(context);
  return StreamBuilder(
    stream: database.watchAllTasks(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      final tasks = snapshot.data ?? List();
      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          final task = tasks[index];
          return _buildListItem(task, database, index);
        },
      );
    },
  );
}

Widget _buildListItem(Task task, AppDatabase database, int index) {
  List<Color> colors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent
  ];
  Color color = colors[index % colors.length];
  return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: () => database.deleteTask(task),
        )
      ],
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          height: 50,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: double.infinity,
                    width: 5,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  Text(
                    task.name,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    task.dueDate == null
                        ? ''
                        : '${task.dueDate.day}.${task.dueDate.month}.${task.dueDate.year}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Checkbox(
                value: task.completed,
                onChanged: (value) =>
                    database.updateTask(task.copyWith(completed: value)),
              ),
            ],
          ),
        ),
      ));
}
