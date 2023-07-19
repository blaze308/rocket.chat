import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import 'chat.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, provider, child) {
          List<String> userList = provider.uList;
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              String username = userList[index];
              return ListTile(
                title: Text(username),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Chat(
                        username: username,
                        roomId: "",
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
