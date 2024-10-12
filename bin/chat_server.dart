import 'dart:io';
import 'package:chat_server/utils/local_db_service.dart';
import 'package:shelf/shelf.dart';
import 'package:chat_server/utils/base_url.dart';
import 'package:chat_server/chat_server_logic.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  HiveService.instance.createBox();
  final router = chatServerLogic();

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  HttpServer server = await io.serve(handler, baseUrl, 8000);

  print("Server has successfully launched server: http://${server.address.host}:${server.port}");
  
}