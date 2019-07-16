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

  set todoLists(List<TodoList> lists) {
    this._todoLists = lists;
    notifyListeners();
  }

  addTodoList(TodoList todoList,
      {int insertPosition = -1, bool addToDB = false}) async {
    TodoList listToBeAdded = todoList;
    if (addToDB) {
      listToBeAdded =
          await TodoListsRepositoryService.addTodoListToDB(todoList);
      return listToBeAdded;
    }
    if (insertPosition >= 0)
      // add to list only
      _todoLists.insert(insertPosition, listToBeAdded);
    else
      _todoLists.add(listToBeAdded);
    notifyListeners();
  }

  void updateTodoList(TodoList todoList) async {
    int index = _findIndexbyId(todoList.id);
    TodoList updatedList =
        await TodoListsRepositoryService.updtaeTodoListInDB(todoList);
    todoLists.removeAt(index);
    todoLists.insert(index, updatedList);
    notifyListeners();
  }

  removeTodoList(TodoList todoList, {bool deleteFromDB = false}) {
    int index = _findIndexbyId(todoList.id);
    _todoLists.removeAt(index);
    if (deleteFromDB) {
      TodoListsRepositoryService.deleteTodoListFromDB(todoList.id);
    }
    notifyListeners();
  }

  int _findIndexbyId(int todoListId) {
    return this.todoLists.indexWhere((todoList) => todoList.id == todoListId);
  }
}
