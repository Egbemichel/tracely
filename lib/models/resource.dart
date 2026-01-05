enum ResourceType { link, document, youtube }

class Resource {
  late String id;
  late String userId;
  late String trailId;
  late ResourceType type;
  late String title;
  late String source;
  late Map<String, dynamic> metadata;
  late DateTime createdAt;
  late DateTime lastVisited;

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'trailId': trailId,
    'type': type.name,
    'title': title,
    'source': source,
    'metadata': metadata,
    'createdAt': createdAt,
    'lastVisited': lastVisited,
  };
}

