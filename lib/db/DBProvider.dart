import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;
  static const int VERSION = 1;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    /*Directory documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: VERSION, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(TodoListTable.CREATE_TABLE);
      await db.execute(TodoItemTable.CREATE_TABLE);
    });*/

    final Future<Database> database = openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'TestDB.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (Database db, int version) async {
        await db.execute(TodoListTable.CREATE_TABLE);
        await db.execute(TodoItemTable.CREATE_TABLE);
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: DATABASE_VERSION,
    );
    return database;
  }
}

const int DATABASE_VERSION = 8;

class TodoListTable {
  static const String TABLE_NAME = "todo_Lists";
  static const String ID = "id";
  static const String TITLE = "title";
  static const String LAST_MODIFICATION = "last_modification";

  static const String CREATE_TABLE = "CREATE TABLE $TABLE_NAME ("
      "$ID INTEGER PRIMERY KEY , "
      "$TITLE TEXT NOT NULL , "
      "$LAST_MODIFICATION INTEGER NOT NULL ) ";
}

class TodoItemTable {
  static const String TABLE_NAME = "todo_items";
  static const String ID = "id";
  static const String LIST_ID = "list_id";
  static const String TITLE = "title";
  static const String IS_DONE = "is_done";
  static const String ADDED = "added";

  static const String CREATE_TABLE = "CREATE TABLE $TABLE_NAME ("
      "$ID INTEGER PRIMERY KEY , "
      "$TITLE TEXT NOT NULL , "
      "$LIST_ID INTEGER , "
      "$IS_DONE BIT  , "
      "$ADDED INTEGER NOT NULL , "
      "FOREIGN KEY($LIST_ID) REFERENCES ${TodoListTable.TABLE_NAME}(${TodoListTable.ID}) )";
}
