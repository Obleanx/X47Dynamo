import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hey, how are you?',
      isSentByUser: false,
    ),
    ChatMessage(
      text: 'I\'m doing great, thanks for asking!',
      isSentByUser: true,
    ),
    ChatMessage(
      text: 'Are we still on for the meeting today?',
      isSentByUser: false,
    ),
    ChatMessage(
      text: 'Yes, definitely. I\'ll send you the details later.',
      isSentByUser: true,
    ),
    ChatMessage(
      text: 'Sounds good. Looking forward to it!',
      isSentByUser: false,
    ),
    ChatMessage(
      text: 'Me too. Have a great rest of your day!',
      isSentByUser: true,
    ),
    ChatMessage(
      text: 'You too, bye!',
      isSentByUser: false,
    ),
    ChatMessage(
      text: 'Hey, did you get the report I sent?',
      isSentByUser: false,
    ),
    ChatMessage(
      text: 'Yes, I just finished reviewing it. Great work!',
      isSentByUser: true,
    ),
    ChatMessage(
      text: 'Glad you liked it. Let me know if you need anything else.',
      isSentByUser: false,
    ),
    ChatMessage(
      text: 'Will do, thanks!',
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
