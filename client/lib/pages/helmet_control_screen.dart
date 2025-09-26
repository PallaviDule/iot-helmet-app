import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/helmetProvider.dart';

class HelmetControlScreen extends StatelessWidget {
  const HelmetControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final helmet = Provider.of<HelmetProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Helmet Control")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection: ${helmet.connectionStatus}'),
            Text('Last Command: ${helmet.lastCommand}'),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: helmet.connect,
                  child: const Text('Pair'),
                ),
                ElevatedButton(
                  onPressed: () => helmet.send("start"),
                  child: const Text('Start'),
                ),
                ElevatedButton(
                  onPressed: () => helmet.send("pause"),
                  child: const Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: () => helmet.send("stop"),
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
