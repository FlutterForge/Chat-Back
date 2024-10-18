import 'dart:convert';

import 'package:chat_server/models/chats_model.dart';
import 'package:chat_server/utils/local_db_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ChatsEndpoints {
  ChatsEndpoints.init();
  static ChatsEndpoints get instance => _instance;
  static final ChatsEndpoints _instance = ChatsEndpoints.init();

  ///"Method used for creating chats(channel, group)"
  void createChat({required Router api, required String endpoint}) {
    return api.post(
      endpoint,
      (Request request) async {
        try {
          final body = await request.readAsString();
          Map<String, dynamic> jsonBody = jsonDecode(body);

          ChatModel? data = ChatModel.fromJson(jsonBody);

          int id = await HiveService.instance.getAllData(boxName: DbBoxes.chats).then((value) => value.values.length) ?? 0;
          if (await HiveService.instance.getData(key: id, boxName: DbBoxes.chats) != null) {
            id += 1;
          }

          data.id = id;
          HiveService.instance.addData(key: data.id, value: data, boxName: DbBoxes.chats);
          return Response.ok(
            json.encode({
              "status": "success",
              "message": "The chat has been created successfully.",
              "data": data.toJson()
            }),
          );
        } catch (e) {
          return Response.badRequest(
            body: json.encode({
              "status": "failure",
              "message": "Invalid data",
              "error": '$e',
              "sample: request body": {
                "name": "Flutter Forge",
                "chatType": "group",
                "participants": [
                  0,
                  1,
                  3,
                  4,
                  20
                ],
                "link": "https://tme/flutter_forge",
                "description": "",
                "picture": "https://example.com/group.png",
                "messages": []
              }
            }),
          );
        }
      },
    );
  }

  ///"Method used for serching channels, group or get current chat info"
  void getChat({required Router api, required String endpoint}) {
    return api.get(
      endpoint,
      (Request request, String id) async {
        try {
          ChatModel? data = await HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.chats);
          if (data == null) {
            return Response.notFound(
              json.encode(
                {
                  "status": "failure",
                  "message": "chat not found"
                },
              ),
            );
          }
          return Response.ok(json.encode(data.toJson()));
        } catch (e) {
          return Response.badRequest(
            body: json.encode({
              "status": "failure",
              "message": "Invalid data",
              "error": e.toString()
            }),
          );
        }
      },
    );
  }

  ///"Method used for add new participants to chat"
  void addNewParticipants({required Router api, required String endpoint}) {
    return api.put(
      endpoint,
      (Request request, String id) async {
        try {
          final body = await request.readAsString();
          Map<String, dynamic> jsonBody = jsonDecode(body);

          ChatModel? chat = await HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.chats);
          if (chat == null) {
            return Response.notFound(
              json.encode({
                "status": "failure",
                "message": "Chat not found"
              }),
            );
          }

          List<int> newParticipants = List<int>.from(jsonBody['participants']);
          chat.participants.addAll(newParticipants);
          chat.participants = chat.participants.toSet().toList();
          HiveService.instance.addData(key: chat.id, value: chat, boxName: DbBoxes.chats);

          ChatModel result = await HiveService.instance.getData(key: chat.id, boxName: DbBoxes.chats) ?? chat;

          return Response.ok(json.encode({
            "status": "success",
            "message": "Participants added successfully.",
            "data": result.toJson()
          }));
        } catch (e) {
          return Response.badRequest(
            body: json.encode({
              "status": "failure",
              "message": "Invalid data",
              "error": e.toString(),
              "sample request body": {
                "participants": [
                  2,
                  3,
                  4
                ]
              },
            }),
          );
        }
      },
    );
  }

  ///"Method used for deleting chat"
  void deleteChat({required Router api, required String endpoint}) {
    return api.delete(
      endpoint,
      (Request request, String id) {
        try {
          HiveService.instance.deleteData(key: int.parse(id), boxName: DbBoxes.chats);

          return Response.ok(
            json.encode({
              "status": "success",
              "message": "Chat deleted successfully"
            }),
          );
        } catch (e) {
          return Response.badRequest(
            body: json.encode({
              "status": "failure",
              "message": "Invalid data",
              "error": e.toString()
            }),
          );
        }
      },
    );
  }
}
