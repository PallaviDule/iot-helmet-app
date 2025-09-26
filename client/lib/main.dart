import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/helmet_control_screen.dart';
import 'services/websocket_service.dart';
import 'services/api_service.dart';
import 'providers/helmet_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wsService = WebSocketService("ws://localhost:8000");
    final apiService = ApiService(baseUrl: 'http://localhost:3000');

    return ChangeNotifierProvider(
      create: (_) => HelmetProvider(
        wsService: wsService,
        apiService: apiService,
        user: 'user123', // pass user identifier here
      ),
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
