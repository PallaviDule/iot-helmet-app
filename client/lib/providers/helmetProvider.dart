import 'package:flutter/material.dart';
import '../services/websocket_service.dart';

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
  }

  void disconnect() {
    wsService.disconnect();
    connectionStatus = "Disconnected";
    notifyListeners();
  }
}
