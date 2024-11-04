import 'package:flutter/material.dart';
import 'package:kakra/SCREENS/Home_screens/bottom_navBar/messages.dart';

// Chat Message Provider
class ChatMessageProvider extends ChangeNotifier {
  late BuildContext _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  final List<ChatMessage> _messages = [
    ChatMessage(
      userName: 'Paul Walker',
      message: 'This is perfect',
      time: '12:34 PM',
      unreadCount: 2,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=1',
      isOnline: true,
    ),
    ChatMessage(
      userName: 'Emma Johnson',
      message: 'Hey! Are we still on for the meeting?',
      time: '9:15 AM',
      unreadCount: 5,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=2',
      isOnline: false,
    ),
    ChatMessage(
      userName: 'Michael Brown',
      message: 'Sure, I’ll get back to you later.',
      time: '10:50 AM',
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=3',
      isOnline: true,
    ),
    ChatMessage(
      userName: 'Sophia Garcia',
      message: 'Can you send over the report?',
      time: '11:25 AM',
      unreadCount: 3,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=4',
      isOnline: false,
    ),
    ChatMessage(
      userName: 'James Wilson',
      message: 'Great job on the project!',
      time: 'Yesterday',
      unreadCount: 1,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=5',
      isOnline: false,
    ),
    ChatMessage(
      userName: 'Olivia Martin',
      message: 'Looking forward to the weekend.',
      time: 'Yesterday',
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=6',
      isOnline: false,
    ),
    ChatMessage(
      userName: 'Liam Rodriguez',
      message: 'Let’s catch up soon!',
      time: '2 days ago',
      unreadCount: 4,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=7',
      isOnline: true,
    ),
    ChatMessage(
      userName: 'Emily Clark',
      message: 'I’ll send the details shortly.',
      time: '3 days ago',
      unreadCount: 6,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=8',
      isOnline: false,
    ),
    ChatMessage(
      userName: 'Benjamin Scott',
      message: 'Good morning! How are you?',
      time: '4 days ago',
      unreadCount: 0,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=9',
      isOnline: true,
    ),
    ChatMessage(
      userName: 'Ava Moore',
      message: 'I’ll be there in 10 minutes.',
      time: '5 days ago',
      unreadCount: 2,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=10',
      isOnline: true,
    ),
    ChatMessage(
      userName: 'Ethan Lee',
      message: 'See you at the event!',
      time: '6 days ago',
      unreadCount: 0,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=11',
      isOnline: false,
    ),
    ChatMessage(
      userName: 'Isabella King',
      message: 'Thanks for the help!',
      time: 'Last week',
      unreadCount: 1,
      avatarUrl: 'https://source.unsplash.com/random/200x200?sig=12',
      isOnline: true,
    ),
  ];

  List<ChatMessage> get messages => _messages;

  void navigateToChat(int index) {
    // Navigate to the chat screen for the selected message
    // You can pass the selected ChatMessage object as an argument
    Navigator.pushNamed(
      _context,
      '/chat',
      arguments: _messages[index],
    );
  }
}
