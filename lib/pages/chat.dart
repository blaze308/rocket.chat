// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../connections/connections.dart';
import '../provider/auth_provider.dart';

class Chat extends StatefulWidget {
  final String username;
  final String roomId;
  const Chat({super.key, required this.username, required this.roomId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
    // String provider = AuthProvider().receiver;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: Column(
        children: [
          Consumer<AuthProvider>(
            builder: (context, provider, child) {
              List<Map<String, dynamic>> messages =
                  provider.getMessagesByUsername(widget.username);
              return Expanded(
                  child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  String senderName = provider.username;
                  String msg = messages[index]["msg"];
                  if (senderName == provider.username) {
                    return ListTile(
                      title: Text(provider.username),
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

              // await Connections().syncMessages(context);
            },
            child: const Text("send message"),
          ),
          ElevatedButton(
            onPressed: () async {
              // await Connections().postMessage(
              //   text: _textcontroller.text,
              //   username: widget.username,
              //   context: context,
              // );

              await Connections().syncMessages(context);
            },
            child: const Text("sync message"),
          ),
        ],
      ),
    );
  }
}
