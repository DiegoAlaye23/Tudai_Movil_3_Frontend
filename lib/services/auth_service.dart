import 'package:dio/dio.dart';
import 'api_service.dart';
import 'dart:developer' as developer;

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> login(String userName, String password) async {
    try {
      final response = await _apiService.dio.post('/api/Usuarios/login', data: {
        'userName': userName,
        'password': password,
      });
      developer.log('Código de respuesta: ${response.statusCode}');
      developer.log('Datos recibidos: ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token != null) {
          await _apiService.saveToken(token);
          return true;
        }
      }
      return false;
    } on DioException catch (e) {
      print('Error en login: ${e.response?.data ?? e.message}');
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null;
  }

  Future<bool> register({
    required String nombreApellido,
    required String email,
    required String password,
    List<Map<String, dynamic>>? contactos,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/Usuarios/register',
        data: {
          'usuarioId': 0,
          'nombreApellido': nombreApellido,
          'email': email,
          'password': password,
          'activo': true,
          'contactos': contactos ?? [],
        },
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      print('Error en registro: ${e.response?.data ?? e.message}');
      return false;
    }
  }
}
