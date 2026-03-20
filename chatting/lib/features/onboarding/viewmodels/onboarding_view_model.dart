import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../models/nearby_user.dart';
import '../models/onboarding_form.dart';
import '../models/onboarding_screen.dart';

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

  final List<String> chats = const ['John', 'Alice'];

  OnboardingScreen get screen => _screen;
  String get activeTab => _activeTab;
  String get input => _input;
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

  void openChat() {
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
