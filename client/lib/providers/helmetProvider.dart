import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/websocket_service.dart';

enum ProgramState { idle, running, paused }

class HelmetProvider with ChangeNotifier {
  final WebSocketService wsService;

  String connectionStatus = "Disconnected";
  String lastCommand = "None";
  ProgramState programState = ProgramState.idle;

  HelmetProvider({required this.wsService});

  void connect() {
    wsService.connect();
    connectionStatus = "Connecting...";
    notifyListeners();

    wsService.stream.listen((data) {
      if (data['status'] != null) {
        connectionStatus = data['status'];
        lastCommand = data['status'];

        if (data['status'] == 'start') programState = ProgramState.running;
        if (data['status'] == 'pause') programState = ProgramState.paused;
        if (data['status'] == 'stop') programState = ProgramState.idle;

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

  void sendCommand(String command) {
    wsService.sendCommand(command);
    lastCommand = command;

    if (command == 'start') programState = ProgramState.running;
    if (command == 'pause') programState = ProgramState.paused;
    if (command == 'stop') programState = ProgramState.idle;

    notifyListeners();

    // Send to Node.js server
    _sendToServer(command);
  }

  Future<void> _sendToServer(String command) async {
    final url = Uri.parse('http://localhost:3000/command');
    final payload = {
      "user": "user123",
      "command": command,
      "timestamp": DateTime.now().toIso8601String()
    };
    try {
      await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(payload));
    } catch (e) {
      print("Error sending command to server: $e");
    }
  }

  void disconnect() {
    wsService.disconnect();
    connectionStatus = "Disconnected";
    notifyListeners();
  }
}
