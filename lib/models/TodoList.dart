import 'package:todo_app/models/TodoItem.dart';

class TodoList {
  int id;
  String title;
  List<TodoItem> items = [];
  DateTime modified;

  TodoList({this.id, this.title, this.items, this.modified});

  void updateLastModification() {
    this.modified = DateTime.now();
  }
}
