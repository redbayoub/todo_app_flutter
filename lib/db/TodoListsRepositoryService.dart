import 'package:todo_app/db/DBProvider.dart';
import 'package:todo_app/models/TodoList.dart';

class TodoListsRepositoryService {
  static Future<List<TodoList>> getTodoListsFromDB() async {
    final db = await DBProvider.db.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT * FROM ${TodoListTable.TABLE_NAME} ORDER BY ${TodoListTable
          .LAST_MODIFICATION} desc",
    );

    return maps != null && maps.isNotEmpty
        ? List.generate(maps.length, (i) {
            return TodoList(
              id: maps[i][TodoListTable.ID],
              title: maps[i][TodoListTable.TITLE],
              items: null,
              modified: DateTime.fromMillisecondsSinceEpoch(
                  maps[i][TodoListTable.LAST_MODIFICATION]),
            );
          })
        : [];
  }

  static Future<TodoList> addTodoListToDB(TodoList todoList) async {
    final db = await DBProvider.db.database;
    List<Map<String, dynamic>> maxIdPlusOneQueryResult = await db.rawQuery(
        "SELECT MAX(${TodoListTable.ID})+1 as ${TodoListTable.ID} FROM ${TodoListTable.TABLE_NAME}");
    int newId = maxIdPlusOneQueryResult.first[TodoListTable.ID] != null
        ? maxIdPlusOneQueryResult.first[TodoListTable.ID]
        : 1;
    assert(newId != null);
    int id = await db.rawInsert(
        "INSERT INTO ${TodoListTable.TABLE_NAME} (${TodoListTable.ID},${TodoListTable.TITLE},${TodoListTable.LAST_MODIFICATION}) VALUES (?, ?, ?)",
        [newId, todoList.title, todoList.modified.millisecondsSinceEpoch]);
    todoList.id = id;
    return todoList;
  }

  static Future<TodoList> updtaeTodoListInDB(TodoList todoList) async {
    final db = await DBProvider.db.database;

    await db.rawUpdate(
        "UPDATE ${TodoListTable.TABLE_NAME} SET ${TodoListTable.ID} = ?, ${TodoListTable.TITLE} = ?, ${TodoListTable.LAST_MODIFICATION} = ? WHERE ${TodoListTable.ID}=?",
        [
          todoList.id,
          todoList.title,
          todoList.modified.millisecondsSinceEpoch,
          todoList.id
        ]);

    return todoList;
  }


  static Future<bool> deleteTodoListFromDB(int todoListId) async {
    final db = await DBProvider.db.database;

    int deletedRows = await db.delete(TodoListTable.TABLE_NAME,
        where: "${TodoListTable.ID}=?", whereArgs: [todoListId]);

    return deletedRows == 1;
  }
}
