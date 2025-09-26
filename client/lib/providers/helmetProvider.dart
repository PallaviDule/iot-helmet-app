import 'package:flutter/material.dart';
import '../services/websocket_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HelmetProvider with ChangeNotifier {
  final WebSocketService wsService;
  String connectionStatus = "Disconnected";
  String lastCommand = "None";

  HelmetProvider({required this.wsService});

  void connect() {
    wsService.connect();
    connectionStatus = "Connecting...";
    notifyListeners();

    wsService.stream.listen((data) {
      if (data['status'] != null) {
        connectionStatus = data['status'];
        lastCommand = data['status'];
        notifyListeners();
      }
    }, onError: (error) {
      connectionStatus = "Error";
      notifyListeners();
    }, onDone: () {
      connectionStatus = "Disconnected";
      notifyListeners();
    });
  }

  void send(String command) {
    wsService.sendCommand(command);
    lastCommand = command;
    notifyListeners();
    logCommandToServer(command);
  }

  void disconnect() {
    wsService.disconnect();
    connectionStatus = "Disconnected";
    notifyListeners();
  }

  Future<void> logCommandToServer(String command) async {
  final url = Uri.parse('http://localhost:3000/command');
  final payload = {
    "user": "user123",
    "command": command,
    "timestamp": DateTime.now().toUtc().toIso8601String(),
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200) {
      print("Failed to log command: ${response.body}");
    }
  } catch (e) {
    print("Error logging command: $e");
  }
}
}
