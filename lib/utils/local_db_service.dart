import 'dart:io';

import 'package:chat_server/models/chats_model.dart';
import 'package:chat_server/models/chatting_model.dart';
import 'package:chat_server/models/user_model.dart';
import 'package:hive/hive.dart';

//? To use any method of Hive service give parameters and HiveBox name

class HiveService {
  static late Box users;
  static late Box chats;
  static const usersBox = 'user_box';
  static const chatsBox = 'chats_box';

  //! Singleton
  HiveService.init();
  static HiveService get instance => _instance;
  static final HiveService _instance = HiveService.init();

  //! init
  void createBox() async {
    final currentDirectory = Directory.current.path;
    Hive.init(currentDirectory);
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ChatModelAdapter());
    Hive.registerAdapter(ChattingModelAdapter());
    users = await Hive.openBox(usersBox);
    chats = await Hive.openBox(chatsBox);
  }

  //! write
  void addData({required key, required value, required DbBoxes boxName}) async {
    final Box box = boxName == DbBoxes.users ? users : chats;

    await box.put(key, value);

    print('write ${[
      key,
      value
    ]}');
  }

  //! read
  dynamic getData({required key, required DbBoxes boxName}) {
    final Box box = boxName == DbBoxes.users ? users : chats;

    print(box.get(key));

    return box.get(key);
  }

  //! read all
  Map getAllData({required DbBoxes boxName}) {
    final Box box = boxName == DbBoxes.users ? users : chats;

    print(box.toMap());

    return box.toMap();
  }

  //! delete
  void deleteData({required key, required DbBoxes boxName}) {
    final Box box = boxName == DbBoxes.users ? users : chats;

    box.delete(key);
    print('Deleted $key');
  }
}

enum DbBoxes {
  users,
  chats
}
