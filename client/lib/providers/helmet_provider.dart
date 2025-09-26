import 'dart:async';
import 'package:flutter/material.dart';
import '../services/websocket_service.dart';
import '../services/api_service.dart';

enum ProgramState { idle, running, paused }

class HelmetProvider with ChangeNotifier {
  final WebSocketService wsService;
  final ApiService apiService;
  final String user;

  String connectionStatus = "Disconnected";
  String lastCommand = "None";
  ProgramState programState = ProgramState.idle;

  Timer? _autoStopTimer;
  int retryCount = 0;
  final int maxRetries = 3;

  HelmetProvider({
    required this.wsService, 
    required this.apiService,
    required this.user,
  });

  /// Connect and pair with device
  void connect() {
    connectionStatus = "Connecting...";
    notifyListeners();

    wsService.connect();

    wsService.stream.listen((data) async{
      final status = data['status'];
      if (status != null) {
        const realCommands = ['pair', 'start', 'pause', 'stop', 'continue'];
        if (realCommands.contains(status)) {
          lastCommand = status;
          await apiService.logCommand(user: user, command: status);
        }
        // Update program state
        switch (data['status']) {
          case 'connected':
            connectionStatus = "Connected";
            break;
          case 'start':
            programState = ProgramState.running;
            _startAutoStopTimer();
            break;
          case 'pause':
            programState = ProgramState.paused;
            _autoStopTimer?.cancel();
            print('Paused, auto-stop timer cancelled');
            break;
          case 'continue':
            programState = ProgramState.running;
            _startAutoStopTimer();
            break;
          case 'stop':
            programState = ProgramState.idle;
            _autoStopTimer?.cancel();
            break;
          default:
            break;
        }

        retryCount = 0;
        notifyListeners();
      }
    }, onError: (error) {
      connectionStatus = "Error";
      notifyListeners();
    }, onDone: () {
      connectionStatus = "Disconnected";
      notifyListeners();
    });

    _sendCommandWithRetry("pair");
  }

  /// Send command with retry mechanism
  void _sendCommandWithRetry(String command) {
    if (retryCount >= maxRetries) return;

    wsService.sendCommand(command);
    lastCommand = command;
    notifyListeners();

    Timer(Duration(seconds: 2), () {
      // Retry if connection or command not updated
      if ((command == "pair" && connectionStatus != "Connected") ||
          lastCommand == command && retryCount < maxRetries) {
        retryCount++;
        _sendCommandWithRetry(command);
      }
    });
  }

  void sendCommand(String command) {
    if (connectionStatus != "Connected") return; // only send if connected

    wsService.sendCommand(command);
    lastCommand = command;
    notifyListeners();

    // Update program state locally for immediate feedback
    switch (command) {
      case 'start':
        programState = ProgramState.running;
        _startAutoStopTimer();
        break;
      case 'pause':
        programState = ProgramState.paused;
        _autoStopTimer?.cancel();
        break;
      case 'stop':
        programState = ProgramState.idle;
        _autoStopTimer?.cancel();
        break;
      case 'continue':
        programState = ProgramState.running;
        _startAutoStopTimer();
        break;
    }

    notifyListeners();
    apiService.logCommand(user: user, command: command);
  }

  void _startAutoStopTimer() {
    _autoStopTimer?.cancel();
    _autoStopTimer = Timer(Duration(seconds: 60), () {
      sendCommand('stop');
    });
  }

  void disconnect() {
    wsService.disconnect();
    connectionStatus = "Disconnected";
    programState = ProgramState.idle;
    _autoStopTimer?.cancel();
    notifyListeners();
  }
}
