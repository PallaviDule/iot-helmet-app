import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/websocket_service.dart';

class HelmetControlScreen extends StatelessWidget {
  const HelmetControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wsService = Provider.of<WebSocketService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Helmet Control")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection: ${wsService.connected ? "Connected" : "Disconnected"}'),
            Text('Last Command: ${wsService.lastCommand}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => wsService.sendCommand('pair'),
                  child: const Text('Pair'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => wsService.sendCommand('start'),
                  child: const Text('Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => wsService.sendCommand('pause'),
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => wsService.sendCommand('stop'),
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
