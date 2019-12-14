import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:simpletodo/database/moor_database.dart';

class NewTaskInput extends StatefulWidget {
  @override
  _NewTaskInputState createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  DateTime taskDate;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTextField(),
          _buildDateButton(),
        ],
      ),
    );
  }

  Expanded _buildTextField() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 8),
        color: Color.fromRGBO(245, 245, 245, 1),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter your task"),
          onSubmitted: (value) {
            final database = Provider.of<AppDatabase>(context);
            final task = Task(
              name: value,
              dueDate: taskDate,
            );
            database.insertTask(task);
            resetValueAfterSubmit();
          },
        ),
      ),
    );
  }

  Container _buildDateButton() {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: IconButton(
          color: Colors.white,
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            taskDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2010),
              lastDate: DateTime(2050),
            );
          },
        ),
      ),
    );
  }

  void resetValueAfterSubmit() {
    setState(() {
      taskDate = null;
      controller.clear();
    });
  }
}
