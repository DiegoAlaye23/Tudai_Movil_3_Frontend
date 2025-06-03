import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/contact_provider.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/contact_list_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactProvider()),
      ],
      child: const ContactosApp(),
    ),
  );
}

class ContactosApp extends StatelessWidget {
  const ContactosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: AuthCheckScreen(),
    );
  }
}

// Pantalla que verifica autenticación al iniciar la app
class AuthCheckScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return snapshot.data == true
              ? const ContactListScreen()
              : const LoginScreen();
        }
      },
    );
  }
}
