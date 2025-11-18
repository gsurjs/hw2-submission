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
    {
      'name': 'Games',
      'image': 'assets/images/games_img.png', 
      'color': Color(0xFFFF6B6B), // Red/Orange
    },
    {
      'name': 'Business',
      'image': 'assets/images/business_img.png',
      'color': Color(0xFF4ECDC4), // Teal
    },
    {
      'name': 'Public Health',
      'image': 'assets/images/health_img.png',
      'color': Color(0xFFFF8FA3), // Pink
    },
    {
      'name': 'Study',
      'image': 'assets/images/study_img.png',
      'color': Color(0xFF9D4EDD), // Deep Purple
    },
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
        padding: const EdgeInsets.all(16.0), // Add some spacing around the edges
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          
          // Logic: Even numbers (0, 2) = Image Right. Odd numbers (1, 3) = Image Left.
          bool isImageRight = index % 2 == 0;

          return GestureDetector(
            onTap: () {
              // Navigate to Chat
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(boardName: board['name']),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20.0), // Space between banners
              height: 180, // Banner Height
              decoration: BoxDecoration(
                color: board['color'], // Use the specific color
                borderRadius: BorderRadius.circular(20), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              // Use ClipRRect to make sure the image doesn't spill out of the rounded corners
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // BACKGROUND CIRCLE DECORATION
                    Positioned(
                      right: isImageRight ? -20 : null,
                      left: isImageRight ? null : -20,
                      top: -20,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white.withOpacity(0.15),
                      ),
                    ),

                    // CONTENT: Row with Text and Image
                    Row(
                      // Swap direction based on index
                      textDirection: isImageRight ? TextDirection.ltr : TextDirection.rtl,
                      children: [
                        // 1. The Text Side
                        Expanded(
                          flex: 3, // Takes up 60% of width
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: isImageRight ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                              children: [
                                Text(
                                  board['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3.0,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                  textAlign: isImageRight ? TextAlign.left : TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 2. The Image Side
                        Expanded(
                          flex: 2, // Takes up 40% of width
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              board['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}