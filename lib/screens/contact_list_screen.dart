import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'add_contact_screen.dart';
import 'contact_search_delegate.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);

    void logout() async {
      await AuthService().logout(); // Llama al método para cerrar sesión
      contactProvider
          .clearContacts(); // Limpia la lista de contactos en el proveedor
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      ); // Navega a la pantalla de inicio de sesión y elimina el historial de rutas
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Contactos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Cerrar sesión',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ContactSearchDelegate(contactProvider.contactos),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddContactScreen()),
              ).then((value) {
                if (value == true) {
                  // Esto forzará la reconstrucción de la UI
                  contactProvider.refreshContacts();
                }
              });
            },
          ),
        ],
      ),
      body: contactProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : contactProvider.contactos.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.contacts,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text('Aún no tienes contactos'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: contactProvider.contactos.length,
                  itemBuilder: (context, index) {
                    final contact = contactProvider.contactos[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          '${contact.nombre} ${contact.apellido}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tel: ${contact.telefono}'),
                            Text('Domicilio: ${contact.email}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddContactScreen(
                                      contact:
                                          contact, // Enviar el contacto actual para edición
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                contactProvider.deleteContact(contact);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
