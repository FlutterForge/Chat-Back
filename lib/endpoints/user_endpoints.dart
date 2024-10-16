import 'dart:convert';

import 'package:chat_server/models/user_model.dart';
import 'package:chat_server/utils/local_db_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserEndpoints {
  UserEndpoints.init();
  static UserEndpoints get instance => _instance;
  static final UserEndpoints _instance = UserEndpoints.init();

  ///"Method used for create new user in Server"
  void createUser({required Router api, required String endpoint}) {
    return api.post(
      endpoint,
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
            "data": data.toJson(),
          }));
        } catch (e) {
          return Response.badRequest(
            body: json.encode({
              "status": "failure",
              "message": "Invalid data",
              "error": e.toString(),
              "sample request body": {
                "username": "John Wick",
                "email": "johnwick@gmail.com",
                "phoneNumber": "+998907711655"
              },
            }),
          );
        }
      },
    );
  }

  ///"Method used to get current user info, search users, and view user profiles."
  void getUserInfo({required Router api, required String endpoint}) {
    return api.get(
      endpoint,
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

          final Map chats = HiveService.instance.getAllData(boxName: DbBoxes.chats);
          List result = List.from(data.chats);
          for (int index = 0; index < result.length; index++) {
            for (int index = 0; index < result.length; index++) {
              if (result[index] is int) {
                print(index);
                print(chats[result[index]]);
                result[index] = chats[result[index]];
              }
            }
          }

          print(result);
          data.chats = result;

          return Response.ok(json.encode(data));
        } catch (e) {
          return Response.badRequest(
            body: json.encode({
              "status": "failure",
              "message": "Invalid data",
              "error": e.toString(),
            }),
          );
        }
      },
    );
  }
}
