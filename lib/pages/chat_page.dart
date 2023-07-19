import 'package:flutter/material.dart';
import 'package:mychatapp/connections/connections.dart';
import 'package:mychatapp/pages/users_page.dart';
import 'package:mychatapp/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  void _fetchChats() {
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    Connections()
        .getChats(context)
        .then((chatDataList) => provider.setChatDataList(chatDataList))
        .onError((error, stackTrace) => Text(error.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Page"),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          List<Map<String, String>> chatDataList = provider.chatDataList;
          return ListView.builder(
            itemCount: chatDataList.length,
            itemBuilder: (context, index) {
              Map<String, String> chatData = chatDataList[index];
              String? name = chatData["name"];
              String? roomId = chatData["roomId"];
              String? updatedAt = chatData["updatedAt"];

              return ListTile(
                title: Text(name.toString()),
                subtitle: Text(updatedAt.toString()),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.contact_page),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const UsersPage(),
        )),
      ),
    );
  }
}
