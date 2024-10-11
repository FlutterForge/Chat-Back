import 'dart:io';

import 'package:chat_server/models/user_model.dart';
import 'package:hive/hive.dart';

class HiveService {
  static late Box box;
  static const userBox = 'user_box';

  //! Singleton
  HiveService.init();
  static HiveService get instance => _instance;
  static final HiveService _instance = HiveService.init();

  //! init
  void createBox() async {
    final currentDirectory = Directory.current.path;
    Hive.init(currentDirectory);
    Hive.registerAdapter(UserModelAdapter());
    box = await Hive.openBox(userBox);
  }

  //! write
  void addUser({required key, required value}) async {
    await box.put(key, value);
    print('write ${[
      key,
      value
    ]}');
  }

  //! read
  dynamic getUser({required key}) {
    print(box.get(key));
    return box.get(key);
  }

  //! read all
  Map get getAllUsers {
    return box.toMap();
  }

  //! delete
  void deleteUser({required key}) {
    box.delete(key);
    print('Deleted $key');
  }
}
