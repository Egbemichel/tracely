enum ResourceType { link, document, youtube }

class Resource {
  late String id;
  late String userId;
  late String trailId;
  late ResourceType type;

  late String title;
  late String source; // URL
  late String domain;

  /// CORE METADATA
  late Map<String, dynamic> metadata;

  /// BEHAVIOR
  int visitCount = 0;
  Duration timeSpent = Duration.zero;
  DateTime createdAt;
  DateTime lastVisited;

  Resource({
    DateTime? createdAt,
    DateTime? lastVisited,
    Map<String, dynamic>? metadata,
    Duration? timeSpent,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastVisited = lastVisited ?? DateTime.now(),
        metadata = metadata ?? {},
        timeSpent = timeSpent ?? Duration.zero;

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'trailId': trailId,
    'type': type.name,
    'title': title,
    'source': source,
    'domain': domain,
    'metadata': {
      ...metadata,
      'timeSpentSeconds': timeSpent.inSeconds, // ensures FirestoreService can read it
    },
    'visitCount': visitCount,
    'timeSpentSeconds': timeSpent.inSeconds, // duplicate for easier queries
    'createdAt': createdAt,
    'lastVisited': lastVisited,
  };
}
