import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/MyTodoListsProvider.dart';
import 'package:todo_app/views/todo_lists.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (BuildContext context) => MyTodoListProvider(),
      child: MaterialApp(
        title: 'Simple Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoLists(),
      ),


      /*
      routes: {

        TodoListView.routeName: (context) => TodoListView()
      },*/
    );
  }
}
