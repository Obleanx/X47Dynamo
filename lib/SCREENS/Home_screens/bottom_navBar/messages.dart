import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/messages_provider.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/chat_screen.dart';
import 'package:kakra/SCREENS/Home_screens/home_screen.dart';
import 'package:provider/provider.dart';

// Chat Message Model
class ChatMessage {
  final String userName;
  final String message;
  final String time;
  final int unreadCount;
  final String avatarUrl;
  final bool isOnline;

  ChatMessage({
    required this.userName,
    required this.message,
    required this.time,
    this.unreadCount = 0,
    required this.avatarUrl,
    required this.isOnline,
  });
}

// Chat Message Screen
class ChatMessageScreen extends StatelessWidget {
  const ChatMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = ChatMessageProvider();
        provider.setContext(context);
        return provider;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            ),
          ),
          title: const Text('Messages'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style:
                          const TextStyle(fontSize: 12.0), // Reduced font size
                      decoration: InputDecoration(
                        hintText: 'Search messages',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 6.0), // Reduced height
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<ChatMessageProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message = provider.messages[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 18.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(message.avatarUrl),
                                  ),
                                  if (message.isOnline)
                                    const CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.green,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      message.message,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    message.time,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      message.unreadCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
      ),
    );
  }
}
