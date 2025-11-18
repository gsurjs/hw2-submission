import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Requirement: Change login information (Password reset is the standard way to do this safely)
  void _changePassword() async {
    if (FirebaseAuth.instance.currentUser?.email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser!.email!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password reset email sent!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text("Change Password"),
            subtitle: const Text("Send a reset link to your email"),
            onTap: _changePassword,
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("App Version"),
            subtitle: const Text("1.0.0"),
          ),
        ],
      ),
    );
  }
}