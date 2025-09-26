import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helmet_control_screen.dart';
import './services/websocket_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WebSocketService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helmet Control',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      home: const HelmetControlScreen(),
    );
  }
}
