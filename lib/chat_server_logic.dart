import 'dart:convert';
import 'package:chat_server/models/chats_model.dart';
import 'package:chat_server/models/chatting_model.dart';
import 'package:chat_server/models/user_model.dart';
import 'package:chat_server/utils/local_db_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router chatServerLogic() {
  final api = Router();

  //! Create user - POST [ /user ]
  api.post(
    '/user',
    (Request request) async {
      try {
        final body = await request.readAsString();
        Map<String, dynamic> jsonBody = jsonDecode(body);

        UserModel data = UserModel.fromJson(jsonBody);

        data.id = HiveService.instance.getAllData(boxName: DbBoxes.users).length;

        HiveService.instance.addData(key: data.id, value: data, boxName: DbBoxes.users);

        return Response.ok(json.encode({
          "status": "success",
          "message": "The user has been created successfully.",
          "data": data.toJson()
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

  //! Get user info by ID - GET [ /user/id ]
  api.get(
    '/user/<id>',
    (Request request, String id) {
      try {
        UserModel? data = HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.users);
        if (data == null) {
          return Response.notFound(
            json.encode(
              {
                "status": "failure",
                "message": "user not found"
              },
            ),
          );
        }
        return Response.ok(json.encode(data));
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

  //! Create chat(channel, group) - POST [ /chats ]
  api.post(
    '/chats',
    (Request request) async {
      try {
        final body = await request.readAsString();
        Map<String, dynamic> jsonBody = jsonDecode(body);

        ChatModel data = ChatModel.fromJson(jsonBody);

        data.id = HiveService.instance.getAllData(boxName: DbBoxes.chats).length;
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
            "error": '$e'
          }),
        );
      }
    },
  );

  //! Get chat by ID - GET [ /chat/id ]
  api.get(
    '/chats/<id>',
    (Request request, String id) {
      try {
        ChatModel? data = HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.chats);
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
        return Response.ok(json.encode(data));
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

  //! Add new participants - PUT [ /chats/<id>/participants ]
  api.put(
    '/chats/<id>/participants',
    (Request request, String id) async {
      try {
        final body = await request.readAsString();
        Map<String, dynamic> jsonBody = jsonDecode(body);

        ChatModel? chat = HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.chats);
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
        HiveService.instance.addData(key: chat.id, value: chat, boxName: DbBoxes.chats);

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

  //! Get chat messages by chat ID - GET [ /chats/<id>/messages ]
  api.get(
    '/chats/<id>/messages',
    (Request request, String id) {
      try {
        ChatModel? chat = HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.chats);
        if (chat == null) {
          return Response.notFound(
            json.encode({
              "status": "failure",
              "message": "Chat not found"
            }),
          );
        }

        List<ChattingModel> messages = chat.messages;
        return Response.ok(json.encode({
          "status": "success",
          "data": messages.map((msg) => msg.toJson()).toList(),
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

  //! Delete a chat by ID - DELETE [ /chats/<id> ]
  api.delete(
    '/chats/<id>',
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

  //! Send message to chat - POST [ /chats/<id>/message ]
  api.post(
    '/chats/<id>/message',
    (Request request, String id) async {
      try {
        final body = await request.readAsString();
        Map<String, dynamic> jsonBody = jsonDecode(body);

        ChattingModel newMessage = ChattingModel.fromJson(jsonBody);

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
            "error": e.toString()
          }),
        );
      }
    },
  );

  //! Delete message by ID - DELETE [ /chats/<id>/message ]
  // api.delete(
  //   '/chats/<id>/message',
  //   (Request request, String id) {
  //     try {
  //       ChatModel chat = HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.chats);
  //       chat.messages.removeWhere((value) => value.uid == id);
  //       HiveService.instance.addData(key: chat.id, value: chat, boxName: DbBoxes.chats);

  //       return Response.ok(json.encode({
  //         "status": "success",
  //         "message": "Participants added successfully.",
  //         "data": chat.toJson()
  //       }));
  //     } catch (e) {
  //       return Response.badRequest(
  //         body: json.encode({
  //           "status": "failure",
  //           "message": "Invalid data",
  //           "error": e.toString()
  //         }),
  //       );
  //     }
  //   },
  // );

  return api;
}
