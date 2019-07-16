import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/MyTodoListsProvider.dart';
import 'package:todo_app/custom_widgets/my_editable_text.dart';
import 'package:todo_app/db/TodoItemsRepositoryService.dart';
import 'package:todo_app/models/TodoItem.dart';
import 'package:todo_app/models/TodoList.dart';

class TodoListView extends StatefulWidget {

  TodoListView(this.initialTodoList, {Key key})
      : super(key: key);
  final TodoList initialTodoList;

  //final Function refreshListCallback;

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  TodoList todoList;
  DateTime lastModicfication;

  Future<bool> saveChanges(BuildContext context) async {
    if (lastModicfication != null) {
      final MyTodoListProvider listsProvider = Provider.of<MyTodoListProvider>(
          context);
      listsProvider.updateTodoList(todoList);

    }
    //widget.refreshListCallback();
    return true;
  }

  Widget buildTodoTitle(TodoItem item) {
    if (item.isDone) {
      return MyEditableText(
        defaultData: item.title,
        onSubmitted: (String newValue) {
          _updateTodoItemTitle(item, newValue);
        },
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
        ),
      );
    } else {
      return MyEditableText(
          defaultData: item.title,
          onSubmitted: (String newValue) {
            _updateTodoItemTitle(item, newValue);
          });
    }
  }

  Widget buildListItem(BuildContext context, int index) {
    return ListTile(
      title: buildTodoTitle(todoList.items[index]),
      leading: Checkbox(
        value: todoList.items[index].isDone,
        onChanged: (bool value) async {
          setState(() {
            todoList.items[index].isDone = value;
          });
          TodoItemsRepositoryService.updtaeTodoItemInDB(todoList.items[index]);
          lastModicfication = DateTime.now();
          todoList.modified = lastModicfication;
        },
      ),
    );
  }

  Widget buildAddTodoItemInput(BuildContext context) {
    TextEditingController controller = TextEditingController();
    TextField tf = TextField(
        decoration: InputDecoration(hintText: "Add a to-do item"),
        controller: controller,
        onSubmitted: (String value) {
          _addTodoItem(value);
          controller.clear();
        });
    return tf;
  }

  @override
  void initState() {
    todoList = widget.initialTodoList;
    // load todo list items
    if (todoList.items == null) todoList.items = [];
    TodoItemsRepositoryService.getTodoItemsFromDB(todoList.id).then((result) {
      setState(() {
        todoList.items = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: MyEditableText(
              defaultData: todoList.title,
              onSubmitted: (String newVal) async {
                if (newVal != todoList.title) {
                  setState(() {
                    todoList.title = newVal;
                  });
                  lastModicfication = DateTime.now();
                  todoList.modified = lastModicfication;
                  saveChanges(context);
                }

              },
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: buildAddTodoItemInput(context),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: todoList.items.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildListItem(context, index),
                ),
              ),
            ],
          )),
      onWillPop: () => saveChanges(context),
    );
  }

  void _addTodoItem(String newItemValue) async {
    TodoItem toAddItem =
        TodoItem(title: newItemValue, isDone: false, added: DateTime.now());
    TodoItem newTodoItem =
    await TodoItemsRepositoryService.addTodoItemToDB(todoList.id, toAddItem);
    todoList.items.add(newTodoItem);
    lastModicfication = DateTime.now();
    todoList.modified = lastModicfication;
  }

  void _updateTodoItemTitle(TodoItem item, String newValue) async {
    item.title = newValue;
    lastModicfication = DateTime.now();
    todoList.modified = lastModicfication;
    TodoItemsRepositoryService.updtaeTodoItemInDB(item);
  }
}
