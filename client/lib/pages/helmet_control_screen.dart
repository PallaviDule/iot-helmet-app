import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/helmetProvider.dart';

class HelmetControlScreen extends StatelessWidget {
  const HelmetControlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HelmetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Helmet Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Connection Status
            Text(
              'Connection: ${provider.connectionStatus}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Program State
            Text(
              'Program State: ${provider.programState.toString().split('.').last}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Last Command
            Text(
              'Last Command: ${provider.lastCommand}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),

            // Buttons Row 1: Pair
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: provider.connect,
                  child: const Text('Pair'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Buttons Row 2: Start, Pause, Continue, Stop
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => provider.sendCommand('start'),
                  child: const Text('Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => provider.sendCommand('pause'),
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => provider.sendCommand('continue'),
                  child: const Text('Continue'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => provider.sendCommand('stop'),
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
