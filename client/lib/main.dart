import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connection: $connectionStatus'),
            Text('Last Command: $lastCommand'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Pair')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Text('Start')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Text('Pause')),
                SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: Text('Stop')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
