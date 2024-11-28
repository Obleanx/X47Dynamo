import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hey, did you find the entrance to the pyramid?',
      isSentByUser: false,
    ),
    ChatMessage(
      text: 'Yes, and you won’t believe it—it’s guarded by a giant sphinx!',
      isSentByUser: true,
    ),
    ChatMessage(
      text: 'What does the sphinx say? Is it another riddle?',
      isSentByUser: false,
    ),
    ChatMessage(
      text:
          'Exactly. “What walks on four legs in the morning, two at noon, and three in the evening.” Classic!',
      isSentByUser: true,
    ),
    ChatMessage(
      text: 'That’s easy. Did you solve it?',
      isSentByUser: false,
    ),
    ChatMessage(
      text: 'Of course! The door opened, but it’s pitch dark inside.',
      isSentByUser: true,
    ),
    ChatMessage(
      text: 'Don’t go alone! Did you find a torch?',
      isSentByUser: false,
    ),
    ChatMessage(
      text:
          'Yes, but it keeps flickering. The walls are covered in hieroglyphics!',
      isSentByUser: true,
    ),
    ChatMessage(
      text: 'Can you read them? What do they say?',
      isSentByUser: false,
    ),
    ChatMessage(
      text:
          'It’s a warning: “Disturb the Pharaoh, and the sands will swallow you.”',
      isSentByUser: true,
    ),
    ChatMessage(
      text: 'Creepy. Do you think the treasure is real?',
      isSentByUser: false,
    ),
    ChatMessage(
      text: 'Only one way to find out. I’m going deeper!',
      isSentByUser: true,
    ),
  ];

  bool _isOnline = true;

  List<ChatMessage> get messages => _messages;
  bool get isOnline => _isOnline;

  void sendMessage(String text) {
    _messages.add(ChatMessage(
      text: text,
      isSentByUser: true,
    ));
    notifyListeners();
  }

  void receiveMessage(String text) {
    _messages.add(ChatMessage(
      text: text,
      isSentByUser: false,
    ));
    notifyListeners();
  }
}

class ChatMessage {
  final String text;
  final bool isSentByUser;

  ChatMessage({
    required this.text,
    required this.isSentByUser,
  });
}
