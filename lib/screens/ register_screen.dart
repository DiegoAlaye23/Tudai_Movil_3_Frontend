import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Lista de contactos temporales para enviar
  List<Map<String, dynamic>> _contactos = [];

  bool _isLoading = false;

  void _addContactoDialog() {
    final nombreCtrl = TextEditingController();
    final apellidoCtrl = TextEditingController();
    final telefonoCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar contacto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  controller: apellidoCtrl,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                ),
                TextFormField(
                  controller: telefonoCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                ),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nombreCtrl.text.isNotEmpty &&
                    apellidoCtrl.text.isNotEmpty) {
                  setState(() {
                    _contactos.add({
                      'contactoId': 0,
                      'nombre': nombreCtrl.text.trim(),
                      'apellido': apellidoCtrl.text.trim(),
                      'telefono': int.tryParse(telefonoCtrl.text) ?? 0,
                      'email': emailCtrl.text.trim(),
                      'activo': true,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = AuthService();

    final success = await authService.register(
      nombreApellido: _nombreController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      contactos: _contactos.isEmpty ? null : _contactos,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
        Navigator.of(context).pop(); // Volver al login o anterior
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en el registro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration:
                    const InputDecoration(labelText: 'Nombre y Apellido'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese su nombre' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese un email';
                  final emailReg = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailReg.hasMatch(value)) return 'Email inválido';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Contraseña debe tener al menos 6 caracteres'
                    : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Contactos adicionales',
                      style: TextStyle(fontSize: 16)),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar'),
                    onPressed: _addContactoDialog,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._contactos.map((contacto) {
                return ListTile(
                  title: Text('${contacto['nombre']} ${contacto['apellido']}'),
                  subtitle: Text(
                      'Tel: ${contacto['telefono']} - Email: ${contacto['email']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _contactos.remove(contacto);
                      });
                    },
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text('Registrarse'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
