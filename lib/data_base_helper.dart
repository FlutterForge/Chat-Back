import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DataBaseHelper {
  // * Initilize data base
  static Future<Database> initDataBase() async {
    sqfliteFfiInit();
    var dataBaseFactory = databaseFactoryFfi;
    var db = await dataBaseFactory.openDatabase(
      'chat_database.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
                CREATE TABLE chats (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                message TEXT NOT NULL,
                isMe BOOLEAN NOT NULL
                )
                ''');
        },
      ),
    );
    return db;
  }

  // ! Yangi message qoshish db ga
  static Future<void> addMessage(String message, bool isMe) async {
    final db = await initDataBase();
    await db.insert('chats', {'message': message, 'isMe': isMe ? 1 : 0});
  }

  static Future<void> deleteMessage(int id) async {
    final db = await initDataBase();
    await db.execute('''
      DELETE FROM chats WHERE ID = $id
''');
  }

  // ! Get all values of db
  static Future<List<Map<String, dynamic>>> getDbChats() async {
    final db = await initDataBase();
    print('>>DB CHATS<<');
    print(db.query('chats'));
    return db.query('chats');
  }
}
