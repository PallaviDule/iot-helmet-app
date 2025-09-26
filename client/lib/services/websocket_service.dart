import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;

  WebSocketService({required this.url});

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void sendCommand(String command) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode({"command": command}));
    }
  }

  Stream get stream => _channel!.stream;

  void disconnect() {
    _channel?.sink.close();
  }
}
