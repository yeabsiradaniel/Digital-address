import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String? imageUrl;
  ChatMessage({required this.text, this.isUser = false, this.imageUrl});
}

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Selam, I need complete parcel data on the properties: 2134-630-304 & 2134-984-371', isUser: true),
    ChatMessage(text: 'Yeah, no problem, here they are.'),
    ChatMessage(text: 'Ad good?', imageUrl: 'https://i.imgur.com/3Z0gY6Q.png'),
    ChatMessage(text: 'Awesome! So, how about the changes on the new building 2134-984-371?', isUser: true),
    ChatMessage(text: 'Yeah we are addressing that as we speak, we are registering the data.'),
    ChatMessage(text: 'We will get back to you with the changes tomorrow morning.'),
  ];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final newMessage = ChatMessage(text: _controller.text, isUser: true);
      _messages.add(newMessage);
      _listKey.currentState?.insertItem(_messages.length - 1, duration: const Duration(milliseconds: 300));
      _controller.clear();
      // To keep the view scrolled to the bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Scroll to the bottom after the animation
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              padding: const EdgeInsets.all(16.0),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: _buildMessageBubble(_messages[index]),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final align = message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = message.isUser ? Theme.of(context).colorScheme.primary : Colors.grey[200];
    final textColor = message.isUser ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(message.imageUrl!)),
                  ),
                if (message.text.isNotEmpty)
                  Text(message.text, style: TextStyle(color: textColor, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.add), onPressed: () {}),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Type your message...', border: InputBorder.none),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary), onPressed: _sendMessage),
          ],
        ),
      ),
    );
  }
}