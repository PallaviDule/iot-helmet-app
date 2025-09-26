import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<void> logCommand({
    required String user,
    required String command,
  }) async {
    final url = Uri.parse('$baseUrl/command');
    final payload = {
      "user": user,
      "command": command,
      "timestamp": DateTime.now().toUtc().toIso8601String()
    };

    print("sendCommand called with $command at ${DateTime.now()}");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        print('Failed to log command: ${response.body}');
      }
    } catch (e) {
      print('Error sending command to server: $e');
    }
  }

  Future<List<dynamic>> getSessions() async {
    final url = Uri.parse('$baseUrl/sessions');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch sessions: ${response.body}');
      }
    } catch (e) {
      print('Error fetching sessions: $e');
    }
    return [];
  }
}
