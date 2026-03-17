import 'dart:convert';
import 'package:http/http.dart' as http;
import '../UserStatus/user.dart';

class AuthService {

  static const String baseUrl = 'http://localhost:3000/api';
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Conectando a: $baseUrl/auth/login');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));
      
      print('Status: ${response.statusCode}');
      print('Respuesta: ${response.body}');
      
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        final user = User.fromJson(data['user']);
        user.login();
        
        return {
          'success': true,
          'user': user,
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error en login',
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
}