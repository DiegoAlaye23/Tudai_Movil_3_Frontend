import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import '../services/contact_service.dart';

class ContactProvider extends ChangeNotifier {
  final ContactService _contactService = ContactService();

  List<Contact> _contactos = [];
  bool _isLoading = false;

  List<Contact> get contactos => _contactos;
  bool get isLoading => _isLoading;

  ContactProvider() {
    fetchContactsFromApi();
  }

  // Cargar contactos desde el backend
  Future<void> fetchContactsFromApi() async {
    notifyListeners();
    _isLoading = true;
    try {
      _contactos = await _contactService.getContacts();
    } catch (e) {
      print('Error fetching contacts: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Agregar contacto (API + local)
  Future<bool> addContact(Contact contact) async {
    try {
      final success = await _contactService.addContact(contact);

      if (success) {
        await fetchContactsFromApi();
      }
      return success;
    } catch (e) {
      print('Error adding contact: $e');
      return false;
    }
  }

  // Actualizar contacto (API + local)
  Future<bool> updateContact(Contact updatedContact) async {
    try {
      final success = await _contactService.updateContact(updatedContact);
      if (success) {
        int index = _contactos
            .indexWhere((c) => c.contactoId == updatedContact.contactoId);
        if (index != -1) {
          _contactos[index] = updatedContact;
          await fetchContactsFromApi();
        }
      }

      return success;
    } catch (e) {
      print('Error updating contact: $e');
      return false;
    }
  }

  // Eliminar contacto (API + local)
  Future<bool> deleteContact(Contact contact) async {
    try {
      if (contact.contactoId == null) return false;
      final success = await _contactService.deleteContact(contact.contactoId!);
      if (success) {
        _contactos.removeWhere((c) => c.contactoId == contact.contactoId);
        await fetchContactsFromApi();
      }
      return success;
    } catch (e) {
      print('Error deleting contact: $e');
      return false;
    }
  }

  void refreshContacts() {
    fetchContactsFromApi();
  }

  // Opcional: limpiar lista local (no afecta backend)
  void clearContacts() {
    _contactos.clear();
    notifyListeners();
  }
}
