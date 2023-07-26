// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mychatapp/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../connections/connections.dart';

class SocketChat extends StatefulWidget {
  final String username;
  final String roomId;
  final String updatedAt;
  const SocketChat({
    super.key,
    required this.username,
    required this.roomId,
    required this.updatedAt,
  });

  @override
  State<SocketChat> createState() => _SocketChatState();
}

class _SocketChatState extends State<SocketChat> {
  TextEditingController _textcontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();

  @override
  void initState() {
    _textcontroller = TextEditingController();
    _usernamecontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textcontroller.dispose();
    _usernamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: Column(
        children: [
          Consumer<AuthProvider>(
            builder: (context, provider, child) {
              List<Map<String, dynamic>> messages = provider.syncMessagesList;
              return Expanded(
                  child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  String senderName = messages[index]["sender"];
                  String msg = messages[index]["msg"];
                  if (senderName == provider.username) {
                    return ListTile(
                      title: Text(senderName),
                      subtitle: Text(msg),
                    );
                  } else {
                    return ListTile(
                      title: Text(widget.username),
                      subtitle: Text(msg),
                    );
                  }
                },
              ));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              color: Colors.grey.shade300,
              child: TextFormField(
                controller: _textcontroller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  hintText: "Type your message here....",
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await Connections().postMessage(
                text: _textcontroller.text,
                receiverName: widget.username,
                context: context,
              );
            },
            child: const Text("send message"),
          ),
          ElevatedButton(
            onPressed: () async {
              await Connections().syncMessages(
                context: context,
                roomId: widget.roomId.toString(),
                updatedAt: DateTime.parse(widget.updatedAt.toString())
                    .subtract(const Duration(hours: 10))
                    .toIso8601String(),
              );
            },
            child: const Text("sync messages for this chat"),
          ),
        ],
      ),
    );
  }
}
