import 'dart:async';
import 'package:flutter/material.dart';
import '../services/websocket_service.dart';

class HelmetProvider with ChangeNotifier {
  final WebSocketService wsService;
  String connectionStatus = "Disconnected";

  int retryCount = 0;
  final int maxRetries = 3;

  HelmetProvider({required this.wsService});

  void connect() {
    connectionStatus = "Connecting...";
    notifyListeners();

    wsService.connect();

    // Listen to WebSocket messages
    wsService.stream.listen((data) {
      if (data['status'] != null) {
        // If pair succeeded
        if (data['status'] == "connected") {
          connectionStatus = "Connected";
          notifyListeners();
        }
      }
    }, onError: (error) {
      connectionStatus = "Error";
      notifyListeners();
    }, onDone: () {
      connectionStatus = "Disconnected";
      notifyListeners();
    });

    // Send pair command
    _sendPairCommand();
  }

  void _sendPairCommand() {
    wsService.sendCommand("pair");

    // Retry mechanism if not connected after 2 seconds
    Timer(Duration(seconds: 2), () {
      if (connectionStatus != "Connected" && retryCount < maxRetries) {
        retryCount++;
        _sendPairCommand();
      }
    });
  }

  void disconnect() {
    wsService.disconnect();
    connectionStatus = "Disconnected";
    notifyListeners();
  }
}
