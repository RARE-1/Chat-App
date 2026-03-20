import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/chat_message.dart';
import '../models/onboarding_screen.dart';
import '../viewmodels/onboarding_view_model.dart';
import '../widgets/gradient_button.dart';
import '../widgets/glass_bottom_nav.dart';
import '../widgets/nearby_user_tile.dart';
import '../widgets/ripple_indicator.dart';

class OnboardingFlowView extends StatefulWidget {
  const OnboardingFlowView({super.key});

  @override
  State<OnboardingFlowView> createState() => _OnboardingFlowViewState();
}

class _OnboardingFlowViewState extends State<OnboardingFlowView> {
  late final OnboardingViewModel _viewModel;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _viewModel = OnboardingViewModel();
    _messageController = TextEditingController();
    _viewModel.addListener(_syncMessageInput);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_syncMessageInput);
    _messageController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _syncMessageInput() {
    if (_messageController.text == _viewModel.input) {
      return;
    }

    _messageController.value = TextEditingValue(
      text: _viewModel.input,
      selection: TextSelection.collapsed(offset: _viewModel.input.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.colorsOf(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return Scaffold(
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: palette.shellGradient,
              ),
            ),
            child: SafeArea(
              child: _buildScreen(context, palette, isDarkMode),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScreen(
    BuildContext context,
    AppPalette palette,
    bool isDarkMode,
  ) {
    switch (_viewModel.screen) {
      case OnboardingScreen.splash:
        return _buildSplash();
      case OnboardingScreen.welcome:
        return _buildWelcome(palette);
      case OnboardingScreen.register:
        return _buildRegister(palette);
      case OnboardingScreen.connect:
        return _buildConnect(palette, isDarkMode);
      case OnboardingScreen.found:
        return _buildFound(palette);
      case OnboardingScreen.chatList:
        return _buildChatList(palette);
      case OnboardingScreen.chat:
        return _buildChat(palette);
    }
  }

  Widget _buildSplash() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.indigo, AppTheme.violet],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ChatX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Connect instantly',
              style: TextStyle(
                color: Color(0xCCFFFFFF),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome(AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          Column(
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Fast, secure messaging.',
                style: TextStyle(color: palette.textMuted, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          GradientButton(
            label: 'Get Started',
            onPressed: () => _viewModel.setScreen(OnboardingScreen.register),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => _viewModel.setScreen(OnboardingScreen.chatList),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
            child: Text(
              'Login',
              style: TextStyle(color: palette.textPrimary.withOpacity(0.82)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegister(AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => _viewModel.setScreen(OnboardingScreen.welcome),
            icon: Icon(Icons.arrow_back, color: palette.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Create Account',
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            onChanged: (value) => _viewModel.updateForm(name: value),
            style: TextStyle(color: palette.textPrimary),
            decoration: const InputDecoration(hintText: 'Full Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => _viewModel.updateForm(email: value),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: palette.textPrimary),
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => _viewModel.updateForm(password: value),
            obscureText: true,
            style: TextStyle(color: palette.textPrimary),
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          const Spacer(),
          GradientButton(
            label: 'Create Account',
            onPressed: _viewModel.createAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildConnect(AppPalette palette, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Text(
            "Let's connect nearby",
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This will take 30 seconds',
            style: TextStyle(color: palette.textMuted),
          ),
          const Spacer(),
          RippleIndicator(isDarkMode: isDarkMode),
          const Spacer(),
          TextButton(
            onPressed: _viewModel.skipConnection,
            child: Text(
              'Skip for now',
              style: TextStyle(color: palette.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFound(AppPalette palette) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'People nearby',
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: _viewModel.nearbyUsers.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final user = _viewModel.nearbyUsers[index];
                return NearbyUserTile(
                  user: user,
                  onFollow: () => _viewModel.followUser(user.name),
                );
              },
            ),
          ),
          TextButton(
            onPressed: _viewModel.skipConnection,
            child: Text(
              'Skip for now',
              style: TextStyle(color: palette.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(AppPalette palette) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 104),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chats',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _viewModel.chats.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final chat = _viewModel.chats[index];
                    return InkWell(
                      onTap: _viewModel.openChat,
                      borderRadius: BorderRadius.circular(18),
                      child: Ink(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: palette.surfaceSoft,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          chat,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          bottom: 18,
          child: GlassBottomNav(
            activeTab: _viewModel.activeTab,
            onChanged: _viewModel.setActiveTab,
          ),
        ),
      ],
    );
  }

  Widget _buildChat(AppPalette palette) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 18, 18, 18),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.indigo, Color(0xFF5B4FFF)],
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => _viewModel.setScreen(OnboardingScreen.chatList),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 4),
              const Text(
                'John',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _viewModel.messages.length,
            itemBuilder: (context, index) {
              final message = _viewModel.messages[index];
              final isUser = message.sender == MessageSender.user;

              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  constraints: const BoxConstraints(maxWidth: 250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: isUser ? AppTheme.indigo : palette.surfaceSoft,
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : palette.textPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: _viewModel.setInput,
                  controller: _messageController,
                  style: TextStyle(color: palette.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.indigo, AppTheme.violet],
                  ),
                ),
                child: IconButton(
                  onPressed: _viewModel.sendMessage,
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
