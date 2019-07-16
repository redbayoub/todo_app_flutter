import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/MyTodoListsProvider.dart';
import 'package:todo_app/models/TodoList.dart';
import 'package:todo_app/views/todo_list_view.dart';

class MyTodoList_ListItem extends StatelessWidget {
  MyTodoList_ListItem(this.todoList);

  final TodoList todoList;

  @override
  Widget build(BuildContext context) {
    final myTodoListsProvider = Provider.of<MyTodoListProvider>(context);
    return Dismissible(
      key: ValueKey(todoList.id),
      onDismissed: (DismissDirection dismissDirection) {
        int currIndex = myTodoListsProvider.findIndexById(todoList.id);
        myTodoListsProvider.removeTodoList(todoList);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete Confirmation"),
                content: Text(
                    "${todoList.title} To-do List will be deleted, Are you sure ?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Confirm",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      myTodoListsProvider.removeTodoList(todoList,
                          deleteFromDB: true);
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      myTodoListsProvider.addTodoList(todoList,
                          insertPosition: currIndex);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
      ),
      child: ListTile(
        title: Text(todoList.title),
        subtitle:
            Text("Last Modification ${todoList.modified.toIso8601String()}"),
        onTap: () => viewTodoList(context, todoList),
      ),
    );
  }

  viewTodoList(BuildContext context, TodoList item) {
    assert(item.id != null);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TodoListView(item),
      ),
    );
  }
}
