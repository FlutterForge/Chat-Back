import 'dart:convert';

import 'package:chat_server/models/chats_model.dart';
import 'package:chat_server/models/message_model.dart';
import 'package:chat_server/models/user_model.dart';
import 'package:chat_server/utils/local_db_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class MessageEndpoints {
  MessageEndpoints.init();
  static MessageEndpoints get instance => _instance;
  static final MessageEndpoints _instance = MessageEndpoints.init();

  ///"Method used for sending message to chat"
  void sendMessage({required Router api, required String endpoint}) {
    api.post(
      endpoint,
      (Request request, String id) async {
        try {
          final body = await request.readAsString();
          Map<String, dynamic> jsonBody = jsonDecode(body);

          MessageModel newMessage = MessageModel.fromJson(jsonBody);

          ChatModel? chat = HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.chats);
          if (chat == null) {
            return Response.notFound(
              json.encode({
                "status": "failure",
                "message": "Chat not found"
              }),
            );
          }

          chat.messages.add(newMessage);
          HiveService.instance.addData(key: chat.id, value: chat, boxName: DbBoxes.chats);

          UserModel userModel = HiveService.instance.getData(key: jsonBody['sender'], boxName: DbBoxes.users);

          userModel.chats.add(int.parse(id));

          userModel = HiveService.instance.getData(key: jsonBody['sender'], boxName: DbBoxes.users);

          // userModel.chats.add();

          return Response.ok(
            json.encode({
              "status": "success",
              "message": "Message sent successfully.",
              "data": newMessage.toJson(),
            }),
          );
        } catch (e) {
          return Response.badRequest(
            body: json.encode({
              "status": "failure",
              "message": "Invalid data",
              "error": e.toString(),
              "sample request body": {
                "sender": 20,
                "message": "Hi"
              }
            }),
          );
        }
      },
    );
  }

  void deleteMessage({required Router api, required String endpoint}) {
    return api.delete(
      endpoint,
      (Request request, String id) {
        try {
          ChatModel chat = HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.chats);
          chat.messages.removeWhere((value) => value.id == id);
          HiveService.instance.addData(key: chat.id, value: chat, boxName: DbBoxes.chats);
          chat = HiveService.instance.getData(key: chat.id, boxName: DbBoxes.chats);
          
          return Response.ok(json.encode({
            "status": "success",
            "message": "Participants added successfully.",
            "data": chat.toJson()
          }));
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
