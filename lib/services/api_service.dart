import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const int _frameTimeoutSeconds = 10;

  // ─────────────────────────────────────────────────────────────────────────
  // Send one JPEG frame for streaming prediction.
  //
  // Backend expects multipart/form-data:
  //   file    : JPEG image
  //   user_id : stable string identifying this device session
  //
  // Returns null on any failure so the stream keeps running.
  // ─────────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> predictFrame({
    required List<int> jpegBytes,
    required String userId,
  }) async {
    try {
      final uri     = Uri.parse('$baseUrl/predict-frame');
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = userId
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',                       // ← backend expects 'file'
            jpegBytes,
            filename: 'frame.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );

      final streamed = await request.send().timeout(
        const Duration(seconds: _frameTimeoutSeconds),
        onTimeout: () => throw Exception('Frame timeout'),
      );

      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'prediction':   body['prediction']   ?? 'Detecting...',
          'hand_visible': body['hand_visible']  ?? false,
          'buffer_ready': body['buffer_ready']  ?? false,
          'frame_count':  body['frame_count']   ?? 0,
        };
      } else {
        print("ERROR: /predict-frame returned ${response.statusCode}: ${response.body}");
        return null;
      }
    } catch (e) {
      print("ERROR in predictFrame: $e");
      return null;           // stream continues silently
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Tell backend to clear this user's frame buffer.
  // Call when streaming stops so next session starts fresh.
  // ─────────────────────────────────────────────────────────────────────────
  static Future<void> resetSession(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/reset-session');
      await http.post(
        uri,
        body: {'user_id': userId},
      ).timeout(const Duration(seconds: 5));
      print("DEBUG: Session reset for $userId");
    } catch (e) {
      print("DEBUG: resetSession failed (non-critical): $e");
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Health check — returns true if server is up
  // ─────────────────────────────────────────────────────────────────────────
  static Future<bool> checkServerHealth() async {
    final uri = Uri.parse('$baseUrl/');
    print("DEBUG: Health check → $uri");
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 8),
          onTimeout: () => throw Exception('Health timeout'));
      print("DEBUG: Health status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['status'] == 'ok';
      }
      return false;
    } on SocketException catch (e) {
      print("ERROR: SocketException in health check: $e");
      return false;
    } catch (e) {
      print("ERROR: Health check failed: $e");
      return false;
    }
  }
}