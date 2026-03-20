class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
  });

  final int id;
  final String text;
  final MessageSender sender;
}

enum MessageSender { bot, user }
