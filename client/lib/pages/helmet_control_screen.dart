import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/helmetProvider.dart';

class HelmetControlScreen extends StatelessWidget {
  const HelmetControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final helmetProvider = Provider.of<HelmetProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Helmet Control")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection: ${helmetProvider.connectionStatus}'),
            Text('Last Command: ${helmetProvider.lastCommand}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: helmetProvider.connect,
                  child: const Text('Pair'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => helmetProvider.send('start'),
                  child: const Text('Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => helmetProvider.send('pause'),
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => helmetProvider.send('stop'),
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
