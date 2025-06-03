import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contact_provider.dart';
import '../models/contact_model.dart';

class AddContactScreen extends StatefulWidget {
  final Contact? contact; // Añadir este parámetro opcional

  const AddContactScreen({super.key, this.contact});

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _domicilioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Si se pasa un contacto, llena los controladores con su información
    if (widget.contact != null) {
      _nombreController.text = widget.contact!.nombre;
      _apellidoController.text = widget.contact!.apellido;
      _telefonoController.text = widget.contact!.telefono.toString();

      _domicilioController.text = widget.contact!.email;
    }
  }

  void _saveContact() async {
    String nombre = _nombreController.text;
    String apellido = _apellidoController.text;
    int telefono = int.parse(_telefonoController.text);
    String email = _domicilioController.text;

    if (nombre.isNotEmpty && apellido.isNotEmpty && email.isNotEmpty) {
      // Crear o actualizar el objeto Contact
      Contact newContact = Contact(
        id: widget.contact?.id, // Mantener el mismo ID si estamos editando
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
        email: email,
      );

      final contactProvider =
          Provider.of<ContactProvider>(context, listen: false);
      if (widget.contact == null) {
        contactProvider.addContact(newContact);
        await contactProvider.fetchContactsFromApi();
      } else {
        contactProvider.updateContact(newContact);
        await contactProvider.fetchContactsFromApi();
      }
      await contactProvider.fetchContactsFromApi();
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completa todos los campos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.contact == null ? 'Nuevo Contacto' : 'Editar Contacto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveContact,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _domicilioController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
