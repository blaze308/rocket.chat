// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _authToken;
  String? _userId;
  String? _username;
  List<String> _uList = [];
  List<Map<String, String>> _chatDataList = [];

  String get authToken => _authToken!;
  String get userId => _userId!;
  String get username => _username!;
  List<String> get uList => _uList;
  List<Map<String, String>> get chatDataList => _chatDataList;

  void setChatDataList(List<Map<String, String>> chatDataList) {
    _chatDataList = chatDataList;
    notifyListeners();
  }

  String? _roomId;
  String _timestamp = "2019-04-16T18:30:46.669Z";
  Map<String, List<Map<String, dynamic>>> _userMessages = {};
  List<Map<String, dynamic>> _mList = [];
  List<Map<String, dynamic>> _myChats = [];
  Map<String, List<Map<String, dynamic>>> _messagesByRoomId = {};

  String get roomId => _roomId!;
  String get timestamp => _timestamp;
  Map<String, List<Map<String, dynamic>>> get userMessages => _userMessages;
  List<Map<String, dynamic>> get mList => _mList;
  List<Map<String, dynamic>> get myChats => _myChats;

  Map<String, List<Map<String, dynamic>>> get messagesByRoomId =>
      _messagesByRoomId;

  set userId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  set authToken(String? authToken) {
    _authToken = authToken;
    notifyListeners();
  }

  set username(String? username) {
    _username = username;
    notifyListeners();
  }

  set timestamp(String timestamp) {
    _timestamp = timestamp;
    notifyListeners();
  }

  set roomId(String? roomId) {
    _roomId = roomId;
    notifyListeners();
  }

  void addtoList(String sender, String msg) {
    _mList.add({
      "senderName": sender,
      "msg": msg,
    });
    notifyListeners();
  }

  void addUsername(String name) {
    _uList.add(name);
    notifyListeners();
  }

  void addtoMyChats(String chatName, String chatRoomId) {
    _myChats.add({
      "chatName": chatName,
      "roomId": chatRoomId,
    });
    notifyListeners();
  }

//byusernames
  void addMessageByUsername(String username, String message) {
    final newMessage = {
      "senderName": username,
      "msg": message,
    };
    if (_userMessages.containsKey(username)) {
      _userMessages[username]!.add(newMessage);
    } else {
      _userMessages[username] = [newMessage];
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> getMessagesByUsername(String username) {
    return _userMessages.containsKey(username) ? _userMessages[username]! : [];
  }

//byroomId
  void addMessageByRoomId(String roomId, String senderName, String message) {
    final newMessage = {
      "senderName": senderName,
      "msg": message,
    };
    if (_messagesByRoomId.containsKey(roomId)) {
      _messagesByRoomId[roomId]!.add(newMessage);
    } else {
      _messagesByRoomId[roomId] = [newMessage];
    }
    notifyListeners();
  }

// //   List<Map<String, dynamic>> getMessagesByRoomId(String roomId) {
// //     return _messagesByRoomId.containsKey(roomId)
// //         ? _messagesByRoomId[roomId]!
// //         : [];
// //   }
}
