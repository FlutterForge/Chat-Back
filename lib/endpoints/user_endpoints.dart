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

          data.isOnline = true;

          if (await HiveService.instance.getData(key: data.phoneNumber, boxName: DbBoxes.users) != null) {
            data = await HiveService.instance.getData(key: data.phoneNumber, boxName: DbBoxes.users);

            return Response.ok(
              json.encode({
                "status": "success",
                "message": "The user data fetched successfully.",
                "data": data.toJson(),
              }),
            );
          } else {
            if (data.username.isNotEmpty) {
              HiveService.instance.addData(key: data.phoneNumber, value: data, boxName: DbBoxes.users);
            }
            return Response(
              202,
              body: json.encode({
                "status": "success",
                "message": "The user has been created successfully.",
                "data": data.toJson(),
              }),
            );
          }
        } catch (e) {
          return Response.badRequest(
            body: json.encode({
              "status": "failure",
              "message": "Invalid data",
              "error": e.toString(),
              "sample request body": {
                'id': "[#e51e4]",
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
      (Request request, String id) async {
        try {
          UserModel? data = await HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.users);
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
              "error": e.toString(),
            }),
          );
        }
      },
    );
  }

  ///"Method used for update user info"
  void updateUserInfo({required Router api, required String endpoint}) {
    api.put(
      endpoint,
      (Request request, String id) async {
        try {
          final String body = await request.readAsString();
          Map<String, dynamic> data = jsonDecode(body);

          UserModel user = await HiveService.instance.getData(key: int.parse(id), boxName: DbBoxes.users);

          Map<String, dynamic> result = user.toJson();
          result.updateAll((key, value) {
            if (data.containsKey(key) && key != 'id') {
              return data[key];
            } else {
              return value;
            }
          });

          HiveService.instance.addData(key: user.id, value: UserModel.fromJson(result), boxName: DbBoxes.users);

          return Response.ok(json.encode(result));
        } catch (e) {
          return Response.badRequest(
            body: json.encode({
              "status": "failure",
              "message": "Invalid data",
              "error": e.toString(),
              "sample request body": {
                "status": "success",
                "message": "The user has been created successfully.",
                "sample request body": {
                  "bio": "Flutter developer",
                  "isOnline": true,
                },
              }
            }),
          );
        }
      },
    );
  }
}
