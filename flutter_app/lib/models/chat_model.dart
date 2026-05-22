class ChatModel {
  final int id;
  final String title;
  final DateTime? createdAt;

  const ChatModel({
    required this.id,
    required this.title,
    this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Chat',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
