import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kakra/PROVIDERS/chat_provider.dart';
import 'package:kakra/PROVIDERS/profile_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageFocusNode.addListener(() {
      setState(() {
        _isTyping = _messageFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 40), // Spacing at the top
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
                Consumer<ProfileProvider>(
                  builder: (context, profileProvider, _) {
                    final profileImageUrl = profileProvider.profileImageUrl;

                    return Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: profileImageUrl != null &&
                                profileImageUrl.isNotEmpty
                            ? CachedNetworkImageProvider(profileImageUrl)
                            : const AssetImage('lib/images/kr5.png')
                                as ImageProvider,
                        child:
                            profileImageUrl == null || profileImageUrl.isEmpty
                                ? Icon(Icons.person, color: Colors.grey[400])
                                : null,
                      ),
                    );
                  },
                ),
              ],
            ),

            Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) {
                final firstName = profileProvider.firstName ?? 'User';
                final lastName = profileProvider.lastName ?? '';

                return Text('$firstName ${lastName.isNotEmpty ? lastName : ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ));
              },
            ),
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
                  // Use null check and provide a fallback
                  final messages = chatProvider.messages ?? [];
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
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
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: message.isSentByUser
                                  ? const Color.fromARGB(255, 212, 234, 250)
                                  : const Color.fromARGB(255, 245, 243, 243),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20),
                                topRight: const Radius.circular(20),
                                bottomLeft: message.isSentByUser
                                    ? const Radius.circular(20)
                                    : Radius.zero,
                                bottomRight: message.isSentByUser
                                    ? Radius.zero
                                    : const Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              message.text,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _isTyping ? _buildTypingArea() : _buildBottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingArea() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _messageController,
        focusNode: _messageFocusNode,
        decoration: InputDecoration(
          hintText: 'Type your message',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () {
                  // Handle voice note functionality
                },
              ),
              Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  return IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        chatProvider.sendMessage(message);
                        _messageController.clear();
                        _messageFocusNode.unfocus();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        maxLines: null,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocusNode,
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
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }
}
