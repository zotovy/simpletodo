import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:simpletodo/database/moor_database.dart';
import 'package:simpletodo/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) => AppDatabase(),
      child: MaterialApp(
        title: 'TODO',
        home: HomePage(),
      ),
    );
  }
}
