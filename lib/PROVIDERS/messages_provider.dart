import 'dart:math';
import 'package:flutter/material.dart';

class ChatMessage {
  final String userName;
  final String message;
  final String time;
  final int unreadCount;
  final String avatarAsset; // Change from avatarUrl to avatarAsset
  final bool isOnline;

  ChatMessage({
    required this.userName,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.avatarAsset, // Update property name here
    required this.isOnline,
  });
}

class ChatMessageProvider extends ChangeNotifier {
  late BuildContext _context;
  late final List<ChatMessage> _messages;

  ChatMessageProvider() {
    _initProvider();
  }

  void _initProvider() {
    _generateChatMessages();
  }

  final Random _random = Random();

  final List<String> _avatarImages = [
    'mdp1.jpg',
    'mdp2.jpg',
    'mdp3.jpg',
    'mdp4.jpg',
    'mdp5.jpg',
    'mdp6.jpg',
    'mdp7.jpg',
    'mdp8.jpg',
    'fdp1.jpg',
    'fdp2.jpg',
    'fdp3.jpg',
    'fdp4.jpg',
    'fdp5.jpg',
    'fdp6.jpg',
    'fdp7.jpg',
    'fdp8.jpg',
    'fdp9.jpg',
    'fdp10.jpg',
    'fdp11.jpg',
    'fdp12.jpg',
  ];

  void _generateChatMessages() {
    _messages = [
      ChatMessage(
        userName: 'Paul Walker',
        message:
            'I found a hidden passage in the Great Pyramid. Who’s in for an adventure?',
        time: '12:34 PM',
        unreadCount: 2,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: true,
      ),
      ChatMessage(
        userName: 'Alice Johnson',
        message:
            'The hieroglyphics say “Beware of the sandstorm.” Creepy, right?',
        time: '9:15 AM',
        unreadCount: 3,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: false,
      ),
      ChatMessage(
        userName: 'Michael Brown',
        message:
            'I swear I saw a shadow move inside the tomb. Are we alone here?',
        time: '10:50 AM',
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: true,
        unreadCount: 2,
      ),
      ChatMessage(
        userName: 'Sophia Garcia',
        message:
            'I’m dusting off an ancient scroll. Looks like it’s a treasure map!',
        time: '11:25 AM',
        unreadCount: 3,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: true,
      ),
      ChatMessage(
        userName: 'James Wilson',
        message: 'I accidentally triggered a trap... the floor is moving!',
        time: 'Yesterday',
        unreadCount: 1,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: false,
      ),
      ChatMessage(
        userName: 'Olivia Martin',
        message: 'The golden scarab artifact is glowing. What does it mean?!',
        time: 'Yesterday',
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: false,
        unreadCount: 0,
      ),
      ChatMessage(
        userName: 'Liam Rodriguez',
        message: 'I found the Pharaoh’s chamber. It’s breathtaking!',
        time: '2 days ago',
        unreadCount: 4,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: true,
      ),
      ChatMessage(
        userName: 'Emily Clark',
        message: 'Beware of the Sphinx’s riddle—it’s trickier than it looks.',
        time: '3 days ago',
        unreadCount: 6,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: false,
      ),
      ChatMessage(
        userName: 'Benjamin Scott',
        message: 'The sandstorm is coming... we need to get out of here!',
        time: '12:34 PM',
        unreadCount: 0,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: true,
      ),
      ChatMessage(
        userName: 'Ava Moore',
        message: 'The Pyramid’s entrance just sealed itself! What now?!',
        time: '5 days ago',
        unreadCount: 2,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: true,
      ),
      ChatMessage(
        userName: 'Ethan Lee',
        message: 'I found a sarcophagus... do we open it?',
        time: '6 days ago',
        unreadCount: 0,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: false,
      ),
      ChatMessage(
        userName: 'Isabella King',
        message:
            'The amulet fits into the wall carving... it’s opening something!',
        time: '9:15 AM',
        unreadCount: 1,
        avatarAsset:
            'lib/images/${_avatarImages[_random.nextInt(_avatarImages.length)]}',
        isOnline: true,
      ),
    ];
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  List<ChatMessage> get messages => _messages;

  void navigateToChat(int index) {
    Navigator.pushNamed(
      _context,
      '/chat',
      arguments: _messages[index],
    );
  }
}
