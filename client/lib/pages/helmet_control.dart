import 'package:flutter/material.dart';
import '../services/websocket_service.dart';
import '../models/helmet_state.dart';
import '../utils/constants.dart';

class HelmetControlScreen extends StatefulWidget {
  const HelmetControlScreen({super.key});

  @override
  State<HelmetControlScreen> createState() => _HelmetControlScreenState();
}

class _HelmetControlScreenState extends State<HelmetControlScreen> {
  late WebSocketService _wsService;
  HelmetStatus _status = HelmetStatus.disconnected;
  String _lastCommand = "None";
  late Stream _stream;

  @override
  void initState() {
    super.initState();
    _wsService = WebSocketService(url: Constants.websocketUrl);
    _wsService.connect();
    _status = HelmetStatus.pairing;
    _stream = _wsService.stream;

    _stream.listen((message) {
      final data = message; // Already string
      setState(() {
        try {
          final parsed = data is String ? data : data.toString();
          // Example simulator response: {"status":"connected"}
          final jsonData = parsed.isNotEmpty ? parsed : '{}';
          final map = Map<String, dynamic>.from(jsonDecode(jsonData));
          final status = map['status'];
          if (status != null) {
            _lastCommand = status;
            if (status == 'connected') _status = HelmetStatus.connected;
            else if (status == 'start' || status == 'pause' || status == 'stop' || status == 'continue') {
              _status = HelmetStatus.commandSent;
            }
          }
        } catch (e) {
          // ignore parse errors
        }
      });
    });
  }

  void _sendCommand(String command) {
    _wsService.sendCommand(command);
    setState(() {
      _lastCommand = command;
    });
  }

  @override
  void dispose() {
    _wsService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Helmet Control")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection: ${_status.name}'),
            Text('Last Command: $_lastCommand'),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(onPressed: () => _sendCommand('pair'), child: const Text('Pair')),
                ElevatedButton(onPressed: () => _sendCommand('start'), child: const Text('Start')),
                ElevatedButton(onPressed: () => _sendCommand('pause'), child: const Text('Pause')),
                ElevatedButton(onPressed: () => _sendCommand('stop'), child: const Text('Stop')),
                ElevatedButton(onPressed: () => _sendCommand('continue'), child: const Text('Continue')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
