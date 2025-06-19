import 'package:flutter/material.dart';
import 'package:digital_addressing_app/screens/inbox/support_chat_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.support_agent, color: Colors.white),
            ),
            title: const Text('Support', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('We will get back to you...'),
            trailing: Text('11:45 AM', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportChatScreen())),
          ),
          const Divider(height: 1, indent: 72),
        ],
      ),
    );
  }
}