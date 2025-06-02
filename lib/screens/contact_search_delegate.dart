import 'package:contactos_app/models/contact_model.dart';
import 'package:flutter/material.dart';

class ContactSearchDelegate extends SearchDelegate {
  final List<Contact> contactos;

  ContactSearchDelegate(this.contactos);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = contactos.where((contact) {
      return contact.nombre.toLowerCase().contains(query.toLowerCase()) ||
          contact.apellido.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final contact = results[index];
        return ListTile(
          title: Text('${contact.nombre} ${contact.apellido}'),
          subtitle: Text('Tel: ${contact.telefono}'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
