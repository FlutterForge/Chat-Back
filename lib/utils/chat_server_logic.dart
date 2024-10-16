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

  //! Create chat(channel, group) - POST [ /chats ]
  ChatsEndpoints.instance.createChat(api: api, endpoint: '/chats');

  //! Get chat by ID - GET [ /chat/id ]
  ChatsEndpoints.instance.getChat(api: api, endpoint: '/chats/<id>');

  //! Add new participants - PUT [ /chats/<id>/participants ]
  ChatsEndpoints.instance.addNewParticipants(api: api, endpoint: '/chats/<id>/participants');

  //! Delete a chat by ID - DELETE [ /chats/<id> ]
  ChatsEndpoints.instance.deleteChat(api: api, endpoint: '/chats/<id>');

  //! Send message to chat - POST [ /chats/<id>/message ]
  MessageEndpoints.instance.sendMessage(api: api, endpoint: '/chats/<id>/message');

  //! Delete message by ID - DELETE [ /chats/<id>/message ]
  MessageEndpoints.instance.deleteMessage(api: api, endpoint: '/chats/<id>/message');

  return api;
}
