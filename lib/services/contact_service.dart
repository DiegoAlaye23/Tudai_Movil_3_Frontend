import 'package:dio/dio.dart';

import '../models/contact_model.dart';
import 'api_service.dart';

class ContactService {
  final ApiService _apiService = ApiService();

  ContactService() {
    _apiService.init();
    _initialize(); // Asegura que el token se carga
  }

  Future<void> _initialize() async {
    await _apiService.init();
  }

  Future<List<Contact>> getContacts() async {
    final response = await _apiService.dio.get('/api/contactos');
    final List data = response.data as List;
    return data.map((json) => Contact.fromMap(json)).toList();
  }

  Future<Contact> getContactById(int id) async {
    final response = await _apiService.dio.get('/api/contactos/$id');
    return Contact.fromMap(response.data);
  }

  Future<bool> addContact(Contact contact) async {
    try {
      final response = await _apiService.dio.post(
        '/api/contactos',
        data: contact.toMap(),
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      print('Error al agregar contacto: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> updateContact(Contact contact) async {
    if (contact.contactoId == null) return false;

    try {
      final response = await _apiService.dio.put(
        '/api/contactos/${contact.contactoId}',
        data: contact.toMap(),
      );
      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('Error 401: No autorizado - token inválido o expirado');
        // Aquí podrías lanzar excepción, mostrar login, etc.
      }
      return false;
    }
  }

  Future<List<Contact>> getAll() async {
    final response = await _apiService.dio.get('/api/contactos');
    final List data = response.data as List;
    return data.map((json) => Contact.fromMap(json)).toList();
  }

  // Función para eliminar un contacto
  Future<bool> deleteContact(int id) async {
    final response = await _apiService.dio.delete('/api/contactos/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }
}
