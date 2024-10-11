import 'dart:convert';

import 'package:chat_server/data_base_helper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;

final _router = Router()
  ..get('/chats', _chatsHandler)
  ..post('/send', _chatHandler)
  ..delete(
    '/delete',
    _deleteHandler,
  );

Future<Response> _deleteHandler(Request req) async {
  final id = await req.readAsString();
  var converId = json.decode(id);

  if (converId['id'] == null) {
    return Response.badRequest(
        body: json.encode({"message": "Invalid data", "statusCode": 400}));
  }

  await DataBaseHelper.deleteMessage(converId['id']);

  return Response.ok(json.encode({"message": "chat has been deleted"}));
}

Future<Response> _chatsHandler(Request req) async {
  final chats = await DataBaseHelper.getDbChats();

  final chatList = chats.map((chat) {
    return {
      'id': chat['id'],
      'message': chat['message'],
      'isMe': chat['isMe'] == 1 ? true : false
    };
  }).toList();

  final data = jsonEncode(
    {"chats": chatList},
  );
  return Response.ok(data);
}

Future<Response> _chatHandler(Request req) async {
  var body = await req.readAsString();
  print('body before encoding $body');
  var responseBody = json.decode(body);

  print('body $responseBody');

  if (responseBody['isMe'] == null || responseBody['message'] == null) {
    return Response.badRequest(
      body: json.encode({"message": "Invalid data", "statusCode": 400}),
    );
  }

  await DataBaseHelper.addMessage(
      responseBody['message'], responseBody['isMe']);

  var responseToUI = jsonEncode({
    "text": "Chat has been added",
    "statusCode": 200,
    "message": responseBody['message']
  });

  return Response.ok(
    responseToUI,
    headers: {'Content-Type': 'application/json'},
  );
}

void main(List<String> args) async {
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(_router.call);
  var server = await io.serve(handler, 'localhost', 8000);
  print('Server listening on port ${server.port}');
}
