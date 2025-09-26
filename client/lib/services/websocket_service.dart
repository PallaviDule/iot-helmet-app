import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketService {
  final String url;
  WebSocketChannel? _channel;

  WebSocketService(this.url);

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void disconnect() {
    _channel?.sink.close();
  }

  void sendCommand(String command) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode({"command": command}));
    }
  }

  Stream<Map<String, dynamic>> get stream {
    if (_channel == null) {
      return Stream.empty();
    }
    return _channel!.stream.map((event) => jsonDecode(event));
  }
}
