import 'package:flutter/material.dart';

import 'db/TodoListsRepositoryService.dart';
import 'models/TodoList.dart';

class MyTodoListProvider with ChangeNotifier {
  List<TodoList> _todoLists = [];

  MyTodoListProvider() {
    TodoListsRepositoryService.getTodoListsFromDB().then((lists) {
      this._todoLists = lists;
      notifyListeners();
    });
  }

  List<TodoList> get todoLists => _todoLists;

  addTodoList(TodoList todoList,
      {int insertPosition = 0, bool addToDB = false}) async {
    TodoList listToBeAdded = todoList;
    if (addToDB) {
      listToBeAdded =
          await TodoListsRepositoryService.addTodoListToDB(todoList);

    }
    _todoLists.insert(insertPosition, listToBeAdded);
    notifyListeners();
    return listToBeAdded;
  }

  void updateTodoList(TodoList todoList) async {
    int index = findIndexById(todoList.id);
    assert(index != -1);
    TodoList updatedList =
        await TodoListsRepositoryService.updtaeTodoListInDB(todoList);
    todoLists.removeAt(index);
    todoLists.insert(index, updatedList);
    notifyListeners();
  }

  removeTodoList(TodoList todoList, {bool deleteFromDB = false}) {
    int index = findIndexById(todoList.id);
    if (index != -1)
      _todoLists.removeAt(index);
    if (deleteFromDB) {
      TodoListsRepositoryService.deleteTodoListFromDB(todoList.id);
    }
    notifyListeners();
  }

  int findIndexById(int todoListId) {
    return this.todoLists.indexWhere((todoList) => todoList.id == todoListId);
  }
}
