import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_ui/flutter_chat_types.dart' as types;
import 'package:web_socket_client/web_socket_client.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.name});

  final String name;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final socket = WebSocket(Uri.parse('ws://echo.websocket.org'));
  final List<types.Message> _messages = [];
  late types.User otherUser;
  late types.User me;

  @override
  void initState() {
    super.initState();
    otherUser = types.User(id: widget.name, firstName: widget.name);
    me = const types.User(id: 'sergio', firstName: 'sergio');

    socket.messages.listen((incomingMessage) {
      List<String> parts = incomingMessage.split('from ');
      String jsonString = parts[0];

      Map<String, dynamic> data = jsonDecode(jsonString);

      String id = data['id'];
      String msg = data['msg'];
      String timestamp = data['timestamp'];

      onMessageReceived(msg);
    });
  }
}
