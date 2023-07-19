// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:http/http.dart" as http;
import 'package:mychatapp/pages/chat_page.dart';
import 'package:provider/provider.dart';
import '../pages/login.dart';
import '../provider/auth_provider.dart';
import '../utils/snackbar.dart';

class Connections {
  final storage = const FlutterSecureStorage();

  Future createUser({
    required String username,
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/v1/users.register"),
        headers: <String, String>{"Content-type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "pass": password,
          "name": name
        }),
      );

      if (response.statusCode == 200) {
        mySnackBar(context, "user created...login with the same credentials");

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Login()));
      }
    } catch (e) {
      mySnackBar(context, "Register Error: ${e.toString()}");
    }
  }

  Future loginUser({
    required String user,
    required String password,
    required BuildContext context,
  }) async {
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/v1/login"),
        headers: <String, String>{"Content-type": "application/json"},
        body: jsonEncode({"user": user, "password": password}),
      );

      if (response.statusCode == 200) {
        mySnackBar(context, "user logged in");

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const ChatPage()));

        //get data from object
        var data = await jsonDecode(response.body)["data"];
        var jsonUserId = await data["userId"];
        var jsonUsername = await data["me"]["username"];
        var jsonAuthToken = await data["authToken"];

        //saving user data
        await storage.write(key: "userId", value: jsonEncode(jsonUserId));
        await storage.write(key: "authToken", value: jsonEncode(jsonAuthToken));
        await storage.write(key: "username", value: jsonEncode(jsonUsername));

        String? storageUserId = await storage.read(key: "userId");
        String? storageUsername = await storage.read(key: "username");
        String? storageAuthToken = await storage.read(key: "authToken");

        provider.userId = await jsonDecode(storageUserId!);
        provider.authToken = await jsonDecode(storageAuthToken!);
        provider.username = await jsonDecode(storageUsername!);
      }
    } catch (e) {
      mySnackBar(context, "Login Error: ${e.toString()}");
    }
  }

  Future getUsers(BuildContext context) async {
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);

    try {
      http.Response response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/v1/users.list"),
        headers: <String, String>{
          "X-Auth-Token": provider.authToken,
          "X-User-Id": provider.userId,
          "Content-type": "application/json"
        },
      );

      var users = jsonDecode(response.body)["users"];

      for (var user in users) {
        String username = user["username"];

        if (provider.username != username &&
            !provider.uList.contains(username)) {
          provider.addUsername(username);
        }
      }
    } catch (e) {
      mySnackBar(context, "Get Users Error: ${e.toString()}");
    }
  }

  Future postMessage({
    required String text,
    required String receiverName,
    required BuildContext context,
  }) async {
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/v1/chat.postMessage"),
        headers: <String, String>{
          "X-Auth-Token": provider.authToken,
          "X-User-Id": provider.userId,
          "Content-type": "application/json",
        },
        body: jsonEncode({"channel": "@$receiverName", "text": text}),
      );

      if (response.statusCode == 200) {
        mySnackBar(context, "message sent successfully");
      }
    } catch (e) {
      mySnackBar(context, "Post Message Error: ${e.toString()}");
    }
  }

  Future getChats(BuildContext context) async {
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      http.Response response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/v1/rooms.get"),
        headers: <String, String>{
          "X-Auth-Token": provider.authToken,
          "X-User-Id": provider.userId,
          "Content-type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        var rooms = data["update"];

        List<Map<String, String>> chatDataList = [];

        for (var room in rooms) {
          String roomId = room["_id"];
          String updatedAt = room["_updatedAt"];

          if ((room["usernames"] as List).isEmpty) {
            continue;
          }

          for (var name in room["usernames"]) {
            if (name != provider.username) {
              Map<String, String> chatData = {
                "name": name,
                "roomId": roomId,
                "updatedAt": updatedAt
              };
              chatDataList.add(chatData);
            }
          }
        }
        provider.setChatDataList(chatDataList);
      }
    } catch (e) {
      mySnackBar(context, "Get Chats Error: ${e.toString()}");
    }
  }

  syncMessages(BuildContext context) async {
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    var time =
        DateTime.parse(provider.timestamp).subtract(const Duration(hours: 1));
    provider.timestamp = time.toIso8601String();
    try {
      http.Response response = await http.get(
        Uri.parse(
            "http://10.0.2.2:3000/api/v1/chat.syncMessages?roomId=${provider.roomId}&lastUpdate=$time&sort=${provider.username}"),
        headers: <String, String>{
          "X-Auth-Token": provider.authToken,
          "X-User-Id": provider.userId,
          "Content-type": "application/json"
        },
      );

      // get jsondata
      var messages = await jsonDecode(response.body)["result"]["updated"];

      for (var message in messages) {
        String sender = message["u"]["name"];
        String msg = message["msg"];
        provider.addMessageByUsername(sender, msg);
      }
    } catch (e) {
      mySnackBar(context, "Sync Messages Error: ${e.toString()}");
    }
  }
}
