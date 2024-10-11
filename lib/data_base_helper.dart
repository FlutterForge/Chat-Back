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

class GroupDataBase {
  // * CREATE A GROUP
  static Future<void> createGroup(
      {required String name, required String description}) async {
    final db = await initGroups();
    await db.insert('groups', {'name': name, 'description': description});
  }

  // * CREATE A USER
  static Future<void> createUser(
      {required String username, required String email}) async {
    final db = await initUsers();
    await db.insert('users', {'username': username, 'email': email});
  }

  // * ADD MESSAGE IN GROUP
  static Future<void> addMessage(
      {required int groupId,
      required int userId,
      required String message}) async {
    final db = await initMessages();
    await db.insert('messages', {
      'groupId': groupId,
      'userId': userId,
      'message': message,
    });
  }

  // ! INIT ALL DATABASE
  static Future<Database> initDataBase() async {
    sqfliteFfiInit();
    var dataBaseFactory = databaseFactoryFfi;
    var db = await dataBaseFactory.openDatabase(
      'groups.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          // Enable foreign key support
          await db.execute('PRAGMA foreign_keys = ON;');

          // Create groups table
          await db.execute('''
                CREATE TABLE groups (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT
                )
                ''');

          // Create users table
          await db.execute('''
                CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                email TEXT NOT NULL
                )
                ''');

          // Create messages table with foreign key to groups and users
          await db.execute('''
                CREATE TABLE messages (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                groupId INTEGER NOT NULL,
                userId INTEGER NOT NULL,
                message TEXT NOT NULL,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (groupId) REFERENCES groups (id) ON DELETE CASCADE,
                FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
                )
                ''');
        },
      ),
    );
    return db;
  }

  // Initialize the groups table
  static Future<Database> initGroups() async {
    sqfliteFfiInit();
    var dataBaseFactory = databaseFactoryFfi;
    var db = await dataBaseFactory.openDatabase(
      'groups.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
                CREATE TABLE groups (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT
                )
                ''');
        },
      ),
    );
    return db;
  }

  // Initialize the users table
  static Future<Database> initUsers() async {
    sqfliteFfiInit();
    var dataBaseFactory = databaseFactoryFfi;
    var db = await dataBaseFactory.openDatabase(
      'groups.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
                CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                email TEXT NOT NULL
                )
                ''');
        },
      ),
    );
    return db;
  }

  // Initialize the messages table
  static Future<Database> initMessages() async {
    sqfliteFfiInit();
    var dataBaseFactory = databaseFactoryFfi;
    var db = await dataBaseFactory.openDatabase(
      'groups.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
                CREATE TABLE messages (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                groupId INTEGER NOT NULL,
                userId INTEGER NOT NULL,
                message TEXT NOT NULL,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (groupId) REFERENCES groups (id) ON DELETE CASCADE,
                FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
                )
                ''');
        },
      ),
    );
    return db;
  }
}
