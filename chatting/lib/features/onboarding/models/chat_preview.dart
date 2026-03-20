class ChatPreview {
  const ChatPreview({
    required this.name,
    required this.handle,
    required this.lastMessage,
    required this.timeLabel,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  final String name;
  final String handle;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;
  final bool isOnline;
}
