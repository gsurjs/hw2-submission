import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String boardName;
  const ChatScreen({super.key, required this.boardName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    if (_msgController.text.isEmpty) return;

    String msg = _msgController.text;
    _msgController.clear();

    // Get current user details to display name with message
    User? user = _auth.currentUser;
    
    // Requirement: Datetime, message, username 
    await _firestore.collection('boards').doc(widget.boardName).collection('messages').add({
      'text': msg,
      'senderId': user?.uid,
      'senderEmail': user?.email, 
      'datetime': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Board Name in Title Bar
      appBar: AppBar(title: Text(widget.boardName)),
      body: Column(
        children: [
          Expanded(
            // Real-time display 
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('boards')
                  .doc(widget.boardName)
                  .collection('messages')
                  .orderBy('datetime', descending: false) // Ordered list
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                var docs = snapshot.data!.docs;
                
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    DateTime dt = DateTime.parse(data['datetime']);
                    String time = DateFormat('MM/dd HH:mm').format(dt);

                    return ListTile(
                      title: Text(data['senderEmail'] ?? 'Unknown'), // Username 
                      subtitle: Text(data['text']), // Message 
                      trailing: Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)), // Datetime 
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(hintText: "Enter message..."),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          )
        ],
      ),
    );
  }
}