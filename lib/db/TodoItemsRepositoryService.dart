import 'package:todo_app/db/DBProvider.dart';
import 'package:todo_app/models/TodoItem.dart';

class TodoItemsRepositoryService {
  static Future<List<TodoItem>> getTodoItemsFromDB(int todoListId) async {
    final db = await DBProvider.db.database;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(
        TodoItemTable.TABLE_NAME,
        where: "${TodoItemTable.LIST_ID}=?",
        whereArgs: [todoListId]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    assert(maps != null);
    print(maps);
    return maps != null && maps.isNotEmpty
        ? List.generate(maps.length, (i) {
            return TodoItem(
              id: maps[i][TodoItemTable.ID],
              title: maps[i][TodoItemTable.TITLE],
              isDone: maps[i][TodoItemTable.IS_DONE] == 1,
              added: DateTime.fromMillisecondsSinceEpoch(
                  maps[i][TodoItemTable.ADDED]),
            );
          })
        : [];
  }

  static Future<TodoItem> addTodoItemToDB(
      int todoListId, TodoItem todoItem) async {
    final db = await DBProvider.db.database;
    List<Map<String, dynamic>> maxIdPlusOneQueryResult = await db.rawQuery(
        "SELECT MAX(${TodoItemTable.ID})+1 as ${TodoItemTable.ID} FROM ${TodoItemTable.TABLE_NAME}");
    int newId = maxIdPlusOneQueryResult.first[TodoListTable.ID] != null
        ? maxIdPlusOneQueryResult.first[TodoListTable.ID]
        : 1;
    assert(newId != null);
    int id = await db.rawInsert(
        "INSERT INTO ${TodoItemTable.TABLE_NAME} (${TodoItemTable.ID}, ${TodoItemTable.LIST_ID},${TodoItemTable.TITLE},${TodoItemTable.IS_DONE},${TodoItemTable.ADDED}) VALUES (?,?,?,?,?)",
        [
          newId,
          todoListId,
          todoItem.title,
          todoItem.isDone,
          todoItem.added.millisecondsSinceEpoch
        ]);
    todoItem.id = id;
    return todoItem;
  }

  static Future<TodoItem> updtaeTodoItemInDB(TodoItem todoItem) async {
    final db = await DBProvider.db.database;

    await db.rawUpdate(
        "UPDATE ${TodoItemTable.TABLE_NAME} SET ${TodoItemTable.ID} = ?, ${TodoItemTable.TITLE} = ?, ${TodoItemTable.IS_DONE} = ?, ${TodoItemTable.ADDED} = ? WHERE ${TodoItemTable.ID}=?",
        [
          todoItem.id,
          todoItem.title,
          todoItem.isDone,
          todoItem.added.millisecondsSinceEpoch,
          todoItem.id
        ]);

    return todoItem;
  }

  static Future<bool> deleteTodoItemFromDB(int todoItemId) async {
    final db = await DBProvider.db.database;

    int deletedRows = await db.delete(TodoItemTable.TABLE_NAME,
        where: "${TodoItemTable.ID}=?", whereArgs: [todoItemId]);

    return deletedRows == 1;
  }
}
