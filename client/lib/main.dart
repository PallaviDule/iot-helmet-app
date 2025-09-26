import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/helmet_control_screen.dart';
import 'services/websocket_service.dart';
import 'providers/helmet_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wsService = WebSocketService("ws://localhost:8000");

    return ChangeNotifierProvider(
      create: (_) => HelmetProvider(wsService: wsService),
      child: MaterialApp(
        title: 'Helmet Control',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const HelmetControlScreen(),
      ),
    );
  }
}
