import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helmet Control',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Helmet Control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String connectionStatus = "Disconnected";
  String lastCommand = "None";

  WebSocketChannel? channel;

  /// Connect to the helmet simulator
  void connect() {
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8000'));

    setState(() {
      connectionStatus = "Connecting...";
    });

    channel?.stream.listen((message) {
      final data = jsonDecode(message);
      final statusMsg = data['status'] ?? data['error'];
      setState(() {
        connectionStatus = statusMsg.toString();
      });
    }, onDone: () {
      setState(() {
        connectionStatus = "Disconnected";
      });
    }, onError: (error) {
      setState(() {
        connectionStatus = "Error: $error";
      });
    });
  }

  /// Send a command to the simulator
  void sendCommand(String command) {
    if (channel != null) {
      channel?.sink.add(jsonEncode({"command": command}));
      setState(() {
        lastCommand = command;
      });
    }
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection: $connectionStatus',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Last Command: $lastCommand',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: connect,
                  child: const Text('Pair'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => sendCommand('start'),
                  child: const Text('Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => sendCommand('pause'),
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => sendCommand('stop'),
                  child: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
