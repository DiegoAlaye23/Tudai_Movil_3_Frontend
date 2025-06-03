import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:5284', // Cambia por la IP de tu máquina
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
    ),
  );

  Future<void> init() async {
    final token = await getToken();
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    // Opcionalmente agregar token en headers para futuras llamadas
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    dio.options.headers.remove('Authorization');
  }
}
