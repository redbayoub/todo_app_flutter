import 'package:flutter/material.dart';
import 'package:todo_app/db/TodoListsProvider.dart';
import 'package:todo_app/models/TodoList.dart';
import 'package:todo_app/views/todo_list_view.dart';

class TodoLists extends StatefulWidget {
  TodoLists({Key key}) : super(key: key);


  @override
  _TodoListsState createState() => _TodoListsState();
}

class _TodoListsState extends State<TodoLists> {
  List<TodoList> todoLists = [];



  void _addTodoList() async {
    TodoList newList = TodoList();

    newList.title = "Untitled";
    newList.items = [];
    newList.modified = DateTime.now();
    TodoList listToView = await TodoListsProvider.addTodoListToDB(newList);
    assert(listToView.id != null);
    viewTodoList(context, listToView);
  }

  Widget buildListItem(BuildContext context, int index) {
    return ListTile(
      title: Text(todoLists[index].title),
      subtitle: Text(
          "Last Modification ${todoLists[index].modified.toIso8601String()}"),
      onTap: () => viewTodoList(context, todoLists[index]),
    );
  }

  viewTodoList(BuildContext context, TodoList item) {
    assert(item.id != null);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TodoListView(item, () => refreshList()),
      ),
    );
  }

  Future<void> refreshList() async {
    TodoListsProvider.getTodoListsFromDB().then((lists) {
      todoLists.clear();
      setState(() {
        todoLists = lists;
      });
    });
  }

  @override
  void initState() {
    TodoListsProvider.getTodoListsFromDB().then((result) {
      setState(() {
        todoLists = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the TodoLists object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("To-do Lists"),
      ),
      body: ListView.builder(
          itemCount: todoLists.length,
          itemBuilder: (BuildContext context, int index) =>
              buildListItem(context, index)),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodoList,
        tooltip: 'Add Todo List',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
