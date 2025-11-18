import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    if (user != null) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        setState(() {
          _firstNameController.text = doc['firstName'];
          _lastNameController.text = doc['lastName'];
        });
      }
    }
  }

  void _updateProfile() async {
    setState(() => _isLoading = true);
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
    });
    setState(() => _isLoading = false);
    if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _firstNameController, decoration: const InputDecoration(labelText: "First Name")),
            TextField(controller: _lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
            const SizedBox(height: 20),
            _isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _updateProfile, child: const Text("Save Changes"))
          ],
        ),
      ),
    );
  }
}