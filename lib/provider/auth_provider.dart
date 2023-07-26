// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _authToken;
  String? _userId;
  String? _username;
  List<String> _allUsersList = [];
  List<Map<String, String>> _chatDataList = [];
  List<Map<String, dynamic>> _syncMessagesList = [];
  Map<String, List<Map<String, dynamic>>> _chatDataMap = {};

  String get authToken => _authToken!;
  String get userId => _userId!;
  String get username => _username!;
  List<String> get allUsersList => _allUsersList;
  List<Map<String, String>> get chatDataList => _chatDataList;
  List<Map<String, dynamic>> get syncMessagesList => _syncMessagesList;

  set authToken(String? authToken) {
    _authToken = authToken;
    notifyListeners();
  }

  void setChatData(String roomId, List<Map<String, dynamic>> chatData) {
    _chatDataMap[roomId] = chatData;
    notifyListeners();
  }

  List<Map<String, dynamic>> getChatData(String roomId) {
    return _chatDataMap[roomId] ?? [];
  }

  set userId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  set username(String? username) {
    _username = username;
    notifyListeners();
  }

  void addUsername(String username) {
    _allUsersList.add(username);
    notifyListeners();
  }

  void setChatDataList(List<Map<String, String>> chatDataList) {
    _chatDataList = chatDataList;
    notifyListeners();
  }

  void setSyncMessagesList(List<Map<String, dynamic>> syncMessagesList) {
    _syncMessagesList = syncMessagesList;
    notifyListeners();
  }
}
