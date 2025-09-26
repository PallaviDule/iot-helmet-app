import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/helmet_provider.dart';

class HelmetControlScreen extends StatelessWidget {
  const HelmetControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final helmetProvider = Provider.of<HelmetProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Helmet Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection: ${helmetProvider.connectionStatus}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                helmetProvider.connect();
              },
              child: Text('Pair'),
            ),
          ],
        ),
      ),
    );
  }
}
