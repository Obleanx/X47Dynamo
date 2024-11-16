import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 30), // Spacing at the top
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // Navigate to the previous screen
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 100),
                const Center(
                  child: CircleAvatar(
                    radius: 30, // Increased radius
                    backgroundImage: AssetImage(
                      'lib/images/mdp6.jpg',
                    ),
                  ),
                ),
              ],
            ),

            const Text('Paul Walker',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                return chatProvider.isOnline
                    ? const Text('Online', style: TextStyle(fontSize: 14))
                    : const SizedBox.shrink();
              },
            ),
            //  const Divider(),

            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  return ListView.builder(
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return Align(
                        alignment: message.isSentByUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: message.isSentByUser
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Text(message.text),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        // Handle voice note functionality
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  return IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        chatProvider.sendMessage(message);
                        _messageController.clear();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
