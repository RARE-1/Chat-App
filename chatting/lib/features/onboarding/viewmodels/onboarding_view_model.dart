import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/chat_preview.dart';
import '../models/chat_message.dart';
import '../models/nearby_user.dart';
import '../models/onboarding_form.dart';
import '../models/onboarding_screen.dart';
import '../models/room_preview.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel() {
    _startSplashTimer();
  }

  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration connectDuration = Duration(seconds: 30);

  Timer? _splashTimer;
  Timer? _connectTimer;

  OnboardingScreen _screen = OnboardingScreen.splash;
  String _activeTab = 'home';
  String _input = '';
  String _selectedChatName = 'John';
  OnboardingForm _form = const OnboardingForm();

  final List<ChatMessage> _messages = [
    ChatMessage(id: 1, text: 'Hey! Welcome', sender: MessageSender.bot),
  ];

  List<NearbyUser> _nearbyUsers = const [
    NearbyUser(name: 'Alex'),
    NearbyUser(name: 'Riya'),
    NearbyUser(name: 'Sam'),
    NearbyUser(name: 'Neha'),
  ];

  final List<ChatPreview> chats = const [
    ChatPreview(
      name: 'John Carter',
      handle: '@johnny',
      lastMessage: 'Send me the deck when you are free.',
      timeLabel: '2m',
      unreadCount: 3,
      isOnline: true,
    ),
    ChatPreview(
      name: 'Alice Ray',
      handle: '@alice',
      lastMessage: 'That onboarding flow looks so much better now.',
      timeLabel: '18m',
      unreadCount: 1,
      isOnline: true,
    ),
    ChatPreview(
      name: 'Neha Singh',
      handle: '@neha',
      lastMessage: 'Let us sync after standup.',
      timeLabel: '1h',
      isOnline: false,
    ),
    ChatPreview(
      name: 'Sam Wilson',
      handle: '@sam',
      lastMessage: 'Voice note sent',
      timeLabel: '3h',
      isOnline: true,
    ),
  ];

  final List<RoomPreview> rooms = const [
    RoomPreview(
      name: 'Design Circle',
      topic: 'UI critiques, motion, launch polish',
      membersLabel: '18 members',
      lastActivity: 'Active now',
    ),
    RoomPreview(
      name: 'Startup Room',
      topic: 'Growth ideas and daily wins',
      membersLabel: '42 members',
      lastActivity: '12 new messages',
    ),
    RoomPreview(
      name: 'Flutter Guild',
      topic: 'Widgets, architecture, releases',
      membersLabel: '27 members',
      lastActivity: 'Updated 8m ago',
    ),
  ];

  OnboardingScreen get screen => _screen;
  String get activeTab => _activeTab;
  String get input => _input;
  String get selectedChatName => _selectedChatName;
  OnboardingForm get form => _form;
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  List<NearbyUser> get nearbyUsers => List.unmodifiable(_nearbyUsers);

  void setScreen(OnboardingScreen screen) {
    _screen = screen;
    _connectTimer?.cancel();

    if (screen == OnboardingScreen.connect) {
      _connectTimer = Timer(connectDuration, () {
        _screen = OnboardingScreen.found;
        notifyListeners();
      });
    }

    notifyListeners();
  }

  void updateForm({
    String? name,
    String? email,
    String? password,
  }) {
    _form = _form.copyWith(
      name: name,
      email: email,
      password: password,
    );
    notifyListeners();
  }

  void setActiveTab(String value) {
    _activeTab = value;
    notifyListeners();
  }

  void setInput(String value) {
    _input = value;
    notifyListeners();
  }

  void createAccount() {
    setScreen(OnboardingScreen.connect);
  }

  void skipConnection() {
    setScreen(OnboardingScreen.chatList);
  }

  void openChat([String? chatName]) {
    if (chatName != null) {
      _selectedChatName = chatName;
    }
    setScreen(OnboardingScreen.chat);
  }

  void followUser(String name) {
    _nearbyUsers = _nearbyUsers
        .map(
          (user) => user.name == name
              ? user.copyWith(isFollowing: !user.isFollowing)
              : user,
        )
        .toList(growable: false);
    notifyListeners();
  }

  void sendMessage() {
    final trimmed = _input.trim();
    if (trimmed.isEmpty) {
      return;
    }

    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch,
        text: trimmed,
        sender: MessageSender.user,
      ),
    );
    _input = '';
    notifyListeners();
  }

  void _startSplashTimer() {
    _splashTimer = Timer(splashDuration, () {
      _screen = OnboardingScreen.welcome;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _connectTimer?.cancel();
    super.dispose();
  }
}
