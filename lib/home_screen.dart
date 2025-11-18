import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Hardcoded list of boards as permitted
  final List<Map<String, dynamic>> boards = const [
    {'name': 'Games', 'icon': Icons.videogame_asset},
    {'name': 'Business', 'icon': Icons.business},
    {'name': 'Public Health', 'icon': Icons.health_and_safety},
    {'name': 'Study', 'icon': Icons.book},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Message Boards")),
      // 5. Sliding Navigation Menu (Drawer) 
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Message Boards'),
              onTap: () => Navigator.pop(context), // Already on home
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      // 4. Ordered List of Message Boards 
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(boards[index]['icon'], size: 40),
              title: Text(boards[index]['name'], style: const TextStyle(fontSize: 20)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // 6. Selecting board opens Chat Window
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(boardName: boards[index]['name']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}