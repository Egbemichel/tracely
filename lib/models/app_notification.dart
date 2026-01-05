class AppNotification {
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  AppNotification({
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'createdAt': createdAt,
    'read': read,
  };
}
