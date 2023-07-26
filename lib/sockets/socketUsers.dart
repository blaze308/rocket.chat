import 'package:flutter/material.dart';
import 'package:mychatapp/connections/connections.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import 'socketChat.dart';

class SocketUsers extends StatefulWidget {
  const SocketUsers({Key? key}) : super(key: key);

  @override
  State<SocketUsers> createState() => _SocketUsersState();
}

class _SocketUsersState extends State<SocketUsers> {
  @override
  void initState() {
    getUsers();
    super.initState();
  }

  Future getUsers() async {
    await Connections().getUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Page'),
      ),
      body: FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return const GetAllUsers();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUsers();
        },
        child: const Icon(Icons.refresh_outlined, size: 30),
      ),
    );
  }
}

class GetAllUsers extends StatelessWidget {
  const GetAllUsers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        List<String> userList = provider.allUsersList;
        return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            String username = userList[index];
            return ListTile(
              title: Text(username),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SocketChat(
                      username: username,
                      roomId: "",
                      updatedAt: "",
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
