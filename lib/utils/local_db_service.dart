import 'dart:io';

import 'package:chat_server/models/chats_model.dart';
import 'package:chat_server/models/message_model.dart';
import 'package:chat_server/models/user_model.dart';
import 'package:hive/hive.dart';

//? To use any method of Hive service give parameters and HiveBox name

class HiveService {
  static late Box users;
  static late Box chats;
  static const usersBox = 'user_box';
  static const chatsBox = 'chats_box';

  //! Singleton
  HiveService.init() {
    createBox();
  }
  static HiveService get instance => _instance;
  static final HiveService _instance = HiveService.init();

  //! init
  Future<void> createBox() async {
    final currentDirectory = Directory.current.path;
    Hive.init(currentDirectory);

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ChatModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(MessageModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    chats = await Hive.openBox(chatsBox);
    users = await Hive.openBox(usersBox);
  }

  //! write
  void addData({required key, required value, required DbBoxes boxName}) async {
    if (!Hive.isBoxOpen(usersBox)) {
      users = await Hive.openBox(usersBox);
    }

    if (!Hive.isBoxOpen(chatsBox)) {
      chats = await Hive.openBox(chatsBox);
    }

    final Box box = boxName == DbBoxes.users ? users : chats;

    await box.put(key, value);

    print("""write $key
    $value""");
  }

  //! read
  dynamic getData({required key, required DbBoxes boxName}) async {
    if (!Hive.isBoxOpen(usersBox)) {
      users = await Hive.openBox(usersBox);
    }

    if (!Hive.isBoxOpen(chatsBox)) {
      chats = await Hive.openBox(chatsBox);
    }

    final Box box = boxName == DbBoxes.users ? users : chats;

    print(box.get(key));

    return box.get(key);
  }

  //! read all
  Future<Map> getAllData({required DbBoxes boxName}) async {
    if (!Hive.isBoxOpen(usersBox)) {
      users = await Hive.openBox(usersBox);
    }

    if (!Hive.isBoxOpen(chatsBox)) {
      chats = await Hive.openBox(chatsBox);
    }

    final Box box = boxName == DbBoxes.users ? users : chats;

    print(box.toMap());

    return box.toMap();
  }

  //! delete
  void deleteData({required key, required DbBoxes boxName}) async {
    if (!Hive.isBoxOpen(usersBox)) {
      users = await Hive.openBox(usersBox);
    }

    if (!Hive.isBoxOpen(chatsBox)) {
      chats = await Hive.openBox(chatsBox);
    }

    final Box box = boxName == DbBoxes.users ? users : chats;

    box.delete(key).then((value) {
      print('Deleted $key');
    });
  }

  // //! clean - WARNING use only for some reasons
  // Future<void> cleanDB() async {
  //   if (!Hive.isBoxOpen(usersBox)) {
  //     users = await Hive.openBox(usersBox);
  //   }

  //   if (!Hive.isBoxOpen(chatsBox)) {
  //     chats = await Hive.openBox(chatsBox);
  //   }
  //   users.deleteFromDisk();
  //   chats.deleteFromDisk();
  //   print("CLEARED");
  // }
}

enum DbBoxes {
  users,
  chats
}
