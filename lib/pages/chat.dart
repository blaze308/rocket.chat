// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mychatapp/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../connections/connections.dart';

class Chat extends StatefulWidget {
  final String username;
  final String roomId;
  final String updatedAt;
  const Chat({
    super.key,
    required this.username,
    required this.roomId,
    required this.updatedAt,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController _textcontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textcontroller = TextEditingController();
    _usernamecontroller = TextEditingController();
    _fetchData();
  }

  @override
  void dispose() {
    _textcontroller.dispose();
    _usernamecontroller.dispose();
    super.dispose();
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);

    try {
      List<Map<String, dynamic>> chatData = await Connections().syncMessages(
          context: context,
          roomId: widget.roomId,
          updatedAt: DateTime.parse(widget.updatedAt.toString())
              .subtract(const Duration(hours: 10))
              .toIso8601String());

      provider.setChatData(widget.roomId, chatData);
    } catch (e) {
      print("Error fetching chat data: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const Expanded(
                child: Center(
              child: CircularProgressIndicator.adaptive(),
            )),
          if (widget.roomId == "") Text("new Chat"),
          Consumer<AuthProvider>(
            builder: (context, provider, child) {
              List<Map<String, dynamic>> messages = provider.syncMessagesList;
              return Expanded(
                  child: ListView.builder(
                itemCount: messages.length,
                reverse: true,
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
              await Connections().syncMessages(
                context: context,
                roomId: widget.roomId.toString(),
                updatedAt: DateTime.parse(widget.updatedAt.toString())
                    .subtract(const Duration(hours: 10))
                    .toIso8601String(),
              );
            },
            child: const Text("send message"),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () async {
              await Connections().syncMessages(
                context: context,
                roomId: widget.roomId.toString(),
                updatedAt: DateTime.parse(widget.updatedAt.toString())
                    .subtract(const Duration(hours: 10))
                    .toIso8601String(),
              );
            },
          ),
        ],
      ),
    );
  }
}
