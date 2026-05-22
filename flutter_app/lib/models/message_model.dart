class MessageModel {
  final int id;
  final String senderType;
  final String message;
  final String? imageUrl;
  final DateTime? createdAt;

  const MessageModel({
    required this.id,
    required this.senderType,
    required this.message,
    this.imageUrl,
    this.createdAt,
  });

  bool get isUser => senderType == 'user';

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      senderType: json['sender_type'] as String,
      message: json['message'] as String,
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
