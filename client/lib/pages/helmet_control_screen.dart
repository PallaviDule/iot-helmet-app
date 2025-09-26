import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/helmetProvider.dart';

class HelmetControlScreen extends StatelessWidget {
  const HelmetControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final helmetProvider = Provider.of<HelmetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Helmet Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection: ${helmetProvider.connectionStatus}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Last Command: ${helmetProvider.lastCommand}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => helmetProvider.send('pair'),
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

