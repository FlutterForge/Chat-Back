import 'dart:convert';
import 'package:chat_server/models/user_model.dart';
import 'package:chat_server/utils/local_db_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router chatServerLogic() {
  Future<Response> createUserHandler(Request req) async {
    final body = await req.readAsString();
    Map<String, dynamic> jsonBody = jsonDecode(body);

    UserModel data = UserModel.fromJson(jsonBody);

    data.id = HiveService.instance.getAllUsers.length;

    HiveService.instance.addUser(key: data.id, value: data);

    print(HiveService.instance.getAllUsers);

    return Response.ok(json.encode({
      "status": "success",
      "message": "The user has been created successfully."
    }));
  }

  final router = Router()..post('/user', createUserHandler);

  return router;
}