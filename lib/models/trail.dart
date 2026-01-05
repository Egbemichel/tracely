class Trail {
  late String id;
  late String userId;
  late String title;
  late String subtitle;
  late DateTime createdAt;
  late DateTime lastAccessed;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'title': title,
    'subtitle': subtitle,
    'createdAt': createdAt,
    'lastAccessed': lastAccessed,
  };
}
