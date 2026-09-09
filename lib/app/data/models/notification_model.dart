/// A single row in the notification inbox.
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.channel,
    required this.createdAt,
    this.readAt,
  });

  final int id;
  final String title;
  final String message;
  final String channel;
  final String createdAt;
  final String? readAt;

  bool get isUnread => readAt == null || readAt!.isEmpty;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final readAt = json['read_at']?.toString();

    return NotificationModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      channel: json['channel']?.toString() ?? 'push',
      createdAt: json['created_at']?.toString() ?? '',
      readAt: (readAt == null || readAt.isEmpty) ? null : readAt,
    );
  }
}
