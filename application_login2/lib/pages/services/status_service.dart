import 'dart:convert';
import 'package:http/http.dart' as http;
import '../UserStatus/status.dart';

class StatusService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<Map<String, dynamic>> getStatuses(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/status'),
        headers: {'user-id': userId.toString()},
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {
          'success': true,
          'statuses': (data['statuses'] as List).map((s) => Status.fromJson(s)).toList(),
        };
      }
      return {'success': false, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> createStatus(int userId, String name, String color) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/status'),
        headers: {
          'Content-Type': 'application/json',
          'user-id': userId.toString(),
        },
        body: json.encode({
          'status_name': name,
          'color': color,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success']) {
        return {
          'success': true,
          'status': Status.fromJson(data['status']),
        };
      }
      return {'success': false, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  static Future<Map<String, dynamic>> deleteStatus(int id, int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/status/$id'),
        headers: {'user-id': userId.toString()},
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true};
      }
      return {'success': false, 'message': data['message']};
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión'};
    }
  }
}