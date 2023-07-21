import 'package:flutter/material.dart';
import 'package:mychatapp/connections/connections.dart';
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
        title: const Text('Users List'),
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
                    builder: (context) => Chat(
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
