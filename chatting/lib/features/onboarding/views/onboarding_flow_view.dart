import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/chat_preview.dart';
import '../models/chat_message.dart';
import '../models/onboarding_screen.dart';
import '../models/room_preview.dart';
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
              style: TextStyle(color: palette.textPrimary.withValues(alpha: 0.82)),
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
          Expanded(
            child: Center(
              child: RippleIndicator(isDarkMode: isDarkMode),
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
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: _buildMainTabContent(palette),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: GlassBottomNav(
            activeTab: _viewModel.activeTab,
            onChanged: _viewModel.setActiveTab,
          ),
        ),
      ],
    );
  }

  Widget _buildMainTabContent(AppPalette palette) {
    switch (_viewModel.activeTab) {
      case 'home':
        return _buildHomeTab(palette);
      case 'chats':
        return _buildChatsTab(palette);
      case 'rooms':
        return _buildRoomsTab(palette);
      case 'profile':
        return _buildProfileTab(palette);
      default:
        return _buildHomeTab(palette);
    }
  }

  Widget _buildHomeTab(AppPalette palette) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good evening',
                    style: TextStyle(
                      color: palette.textMuted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ready to connect?',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: palette.surfaceSoft,
                shape: BoxShape.circle,
                border: Border.all(color: palette.stroke),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: palette.textPrimary,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _SectionTitle(title: 'Hype Up', emoji: '🔥', palette: palette),
        const SizedBox(height: 12),
        SizedBox(
          height: 88,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _HypeCard(title: 'Music', activity: '12 active'),
              SizedBox(width: 12),
              _HypeCard(title: 'Startup', activity: '18 active'),
              SizedBox(width: 12),
              _HypeCard(title: 'Crypto', activity: '09 active'),
              SizedBox(width: 12),
              _HypeCard(title: 'Gaming', activity: '21 active'),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionTitle(title: 'Jump Back In', emoji: '⏪', palette: palette),
        const SizedBox(height: 12),
        ..._viewModel.chats.take(2).map(
          (chat) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _JumpBackTile(
              chat: chat,
              palette: palette,
              subtitle: 'Continue chat',
              onTap: () => _viewModel.openChat(chat.name),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _JumpBackTile(
            chat: _viewModel.chats[2],
            palette: palette,
            subtitle: 'Continue chat',
            onTap: () => _viewModel.openChat(_viewModel.chats[2].name),
          ),
        ),
        const SizedBox(height: 6),
        _SectionTitle(title: 'Explore', emoji: '🌍', palette: palette),
        const SizedBox(height: 12),
        ..._viewModel.nearbyUsers.map(
          (user) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ExploreUserTile(
              name: user.name,
              palette: palette,
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatsTab(AppPalette palette) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: palette.surfaceSoft,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: palette.stroke),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: palette.textMuted),
              const SizedBox(width: 12),
              Text(
                'Search messages...',
                style: TextStyle(color: palette.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Active',
          style: TextStyle(
            color: palette.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _viewModel.chats.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final chat = _viewModel.chats[index];
              return _ActiveUserPill(chat: chat, palette: palette);
            },
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Recent DMs',
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ..._viewModel.chats.map(
          (chat) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RecentDmTile(
              name: chat.name.split(' ').first,
              timeLabel: chat.timeLabel,
              palette: palette,
              onTap: () => _viewModel.openChat(chat.name),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomsTab(AppPalette palette) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Text(
          'Rooms',
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Group chats and communities you can drop into anytime.',
          style: TextStyle(color: palette.textMuted),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: palette.surfaceSoft,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: palette.stroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured community',
                style: TextStyle(
                  color: palette.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Launch Lounge',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Where builders share progress, blockers, and product feedback in real time.',
                style: TextStyle(color: palette.textMuted, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ..._viewModel.rooms.map(
          (room) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RoomTile(
              room: room,
              palette: palette,
              onTap: () => _viewModel.openChat(room.name),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab(AppPalette palette) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.indigo, AppTheme.violet],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'RS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _viewModel.form.name.isEmpty ? 'Rohit Sharma' : _viewModel.form.name,
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _viewModel.form.email.isEmpty ? '@rohit' : _viewModel.form.email,
                style: TextStyle(color: palette.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                title: 'DMs',
                value: '128',
                subtitle: 'Total threads',
                palette: palette,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoCard(
                title: 'Groups',
                value: '16',
                subtitle: 'Joined rooms',
                palette: palette,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _ProfileSection(
          title: 'Profile',
          palette: palette,
          children: const [
            _ProfileRow(label: 'Display name', value: 'Rohit Sharma'),
            _ProfileRow(label: 'Status', value: 'Building quietly'),
            _ProfileRow(label: 'Theme', value: 'System'),
          ],
        ),
        const SizedBox(height: 12),
        _ProfileSection(
          title: 'Preferences',
          palette: palette,
          children: const [
            _ProfileRow(label: 'Notifications', value: 'Mentions only'),
            _ProfileRow(label: 'Privacy', value: 'Friends and rooms'),
            _ProfileRow(label: 'Media quality', value: 'High'),
          ],
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
              Text(
                _viewModel.selectedChatName,
                style: const TextStyle(
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.palette,
  });

  final String title;
  final String value;
  final String subtitle;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: palette.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: palette.textMuted)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.emoji,
    required this.palette,
  });

  final String title;
  final String emoji;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$emoji $title',
      style: TextStyle(
        color: palette.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _HypeCard extends StatelessWidget {
  const _HypeCard({
    required this.title,
    required this.activity,
  });

  final String title;
  final String activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.indigo, AppTheme.violet],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            activity,
            style: const TextStyle(
              color: Color(0xD9FFFFFF),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _JumpBackTile extends StatelessWidget {
  const _JumpBackTile({
    required this.chat,
    required this.palette,
    required this.subtitle,
    required this.onTap,
  });

  final ChatPreview chat;
  final AppPalette palette;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: palette.surfaceSoft,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: palette.stroke),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.indigo,
              ),
              alignment: Alignment.center,
              child: Text(
                chat.name.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.name.split(' ').first,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: palette.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreUserTile extends StatelessWidget {
  const _ExploreUserTile({
    required this.name,
    required this.palette,
    required this.onTap,
  });

  final String name;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.stroke),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.indigo,
            ),
            alignment: Alignment.center,
            child: Text(
              name.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: const Text(
              'View',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.palette,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String meta;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: palette.surfaceSoft,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.stroke),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppTheme.indigo, AppTheme.violet],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                title.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: palette.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(meta, style: TextStyle(color: palette.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _RoomHighlightCard extends StatelessWidget {
  const _RoomHighlightCard({
    required this.room,
    required this.palette,
  });

  final RoomPreview room;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            room.name,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            room.topic,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: palette.textMuted, height: 1.35),
          ),
          const Spacer(),
          Text(room.membersLabel, style: TextStyle(color: palette.textPrimary)),
          const SizedBox(height: 4),
          Text(room.lastActivity, style: TextStyle(color: palette.textMuted)),
        ],
      ),
    );
  }
}

class _ActiveUserPill extends StatelessWidget {
  const _ActiveUserPill({
    required this.chat,
    required this.palette,
  });

  final ChatPreview chat;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppTheme.indigo, AppTheme.violet],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                chat.name.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (chat.isOnline)
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          chat.name.split(' ').first,
          style: TextStyle(color: palette.textPrimary, fontSize: 12),
        ),
      ],
    );
  }
}

class _ChatListTile extends StatelessWidget {
  const _ChatListTile({
    required this.chat,
    required this.palette,
    required this.onTap,
  });

  final ChatPreview chat;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.surfaceSoft,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: palette.stroke),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppTheme.indigo, AppTheme.violet],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                chat.name.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        chat.timeLabel,
                        style: TextStyle(color: palette.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: palette.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.handle,
                    style: TextStyle(color: palette.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (chat.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: const BoxDecoration(
                  color: AppTheme.indigo,
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                ),
                child: Text(
                  '${chat.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecentDmTile extends StatelessWidget {
  const _RecentDmTile({
    required this.name,
    required this.timeLabel,
    required this.palette,
    required this.onTap,
  });

  final String name;
  final String timeLabel;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: palette.surfaceSoft,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: palette.stroke),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              timeLabel,
              style: TextStyle(
                color: palette.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  const _RoomTile({
    required this.room,
    required this.palette,
    required this.onTap,
  });

  final RoomPreview room;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: palette.surfaceSoft,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: palette.stroke),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [AppTheme.indigo, AppTheme.violet],
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.groups_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.topic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: palette.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${room.membersLabel}  •  ${room.lastActivity}',
                    style: TextStyle(color: palette.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.title,
    required this.palette,
    required this.children,
  });

  final String title;
  final AppPalette palette;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.colorsOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: palette.textMuted),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
