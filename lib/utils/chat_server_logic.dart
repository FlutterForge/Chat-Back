import 'package:chat_server/endpoints/chats_endpoints.dart';
import 'package:chat_server/endpoints/message_endpoints.dart';
import 'package:chat_server/endpoints/user_endpoints.dart';
import 'package:shelf_router/shelf_router.dart';

Router chatServerLogic() {
  final api = Router();

  //! Create user - POST
  UserEndpoints.instance.createUser(api: api, endpoint: '/user');

  //! Get user info by ID - GET
  UserEndpoints.instance.getUserInfo(api: api, endpoint: '/user/<id>');

  //! Update user info by ID - PUT
  UserEndpoints.instance.updateUserInfo(api: api, endpoint: '/users/<id>/update');

  //! Create chat(channel, group)
  ChatsEndpoints.instance.createChat(api: api, endpoint: '/chats');

  //! Get chat by ID - GET
  ChatsEndpoints.instance.getChat(api: api, endpoint: '/chats/<id>');

  //! Get all chats - GET
  ChatsEndpoints.instance.getAllChats(api: api, endpoint: '/chats');

  //! Add new participants - PUT
  ChatsEndpoints.instance.addNewParticipants(api: api, endpoint: '/chats/<id>/participants');

  //! Delete a chat by ID - DELETE
  ChatsEndpoints.instance.deleteChat(api: api, endpoint: '/chats/<id>');

  //! Send message to chat - POST
  MessageEndpoints.instance.sendMessage(api: api, endpoint: '/chats/<id>/message');

  //! Delete message by ID - DELETE
  MessageEndpoints.instance.deleteMessage(api: api, endpoint: '/chats/<id>/message');

  return api;
}
