import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'home_screen.dart'; // will create next

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _role = TextEditingController(); // e.g., Student, Teacher
  final AuthService _authService = AuthService();

  void _register() async {
    String? error = await _authService.signUp(
      email: _email.text.trim(),
      password: _pass.text.trim(),
      firstName: _fName.text.trim(),
      lastName: _lName.text.trim(),
      role: _role.text.trim(),
    );

    if (error == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _fName, decoration: const InputDecoration(labelText: "First Name")),
            TextField(controller: _lName, decoration: const InputDecoration(labelText: "Last Name")),
            TextField(controller: _role, decoration: const InputDecoration(labelText: "Role (e.g. User)")),
            TextField(controller: _email, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _pass, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}