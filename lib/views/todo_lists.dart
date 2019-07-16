import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/MyTodoListsProvider.dart';
import 'package:todo_app/custom_widgets/MyTodoList_ListItem.dart';
import 'package:todo_app/models/TodoList.dart';
import 'package:todo_app/views/todo_list_view.dart';

class TodoLists extends StatelessWidget {
  void _addTodoList(BuildContext context) async {
    final MyTodoListProvider listsProvider =
    Provider.of<MyTodoListProvider>(context);
    TodoList newList = TodoList();

    newList.title = "Untitled";
    newList.items = [];
    newList.modified = DateTime.now();
    TodoList listToView =
    await listsProvider.addTodoList(newList, addToDB: true);
    assert(listToView.id != null);
    _viewTodoList(context, listToView);
  }

  void _viewTodoList(BuildContext context, TodoList item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TodoListView(item),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the TodoLists object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("To-do Lists"),
      ),
      body: Consumer<MyTodoListProvider>(builder: (context, provider, _) {
        return ListView.builder(
          itemCount: provider.todoLists.length,
          itemBuilder: (BuildContext context, int index) =>
              MyTodoList_ListItem(provider.todoLists.elementAt(index)),
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTodoList(context),
        tooltip: 'Add Todo List',
        child: Icon(Icons.add),
      ),

    );
  }
}
