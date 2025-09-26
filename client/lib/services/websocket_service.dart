import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService extends ChangeNotifier {
  late WebSocketChannel? _channel;
  bool connected = false;
  String lastCommand = "None";

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen((message) {
      final data = jsonDecode(message);
      final status = data['status'];
      if (status != null) {
        connected = (status == 'connected' || status == 'start' || status == 'pause' || status == 'stop');
        lastCommand = status;
        notifyListeners(); // Update UI
      }
    }, onDone: () {
      connected = false;
      notifyListeners();
    }, onError: (error) {
      connected = false;
      notifyListeners();
    });
  }

  void sendCommand(String command) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode({"command": command}));
    }
  }

  void disconnect() {
    _channel?.sink.close();
    connected = false;
    notifyListeners();
  }
}
