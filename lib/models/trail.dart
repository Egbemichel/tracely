import 'package:cloud_firestore/cloud_firestore.dart';

class Trail {
  String id;
  String userId;
  String title;
  String subtitle;

  /// NEW
  int resourceCount;
  Duration totalTimeSpent;
  DateTime createdAt;
  DateTime lastAccessed;

  Trail({
    this.id = '',
    this.userId = '',
    this.title = '',
    this.subtitle = '',
    this.resourceCount = 0,
    Duration? totalTimeSpent,
    DateTime? createdAt,
    DateTime? lastAccessed,
  })  : totalTimeSpent = totalTimeSpent ?? Duration.zero,
        createdAt = createdAt ?? DateTime.now(),
        lastAccessed = lastAccessed ?? DateTime.now();

  factory Trail.fromJson(String id, Map<String, dynamic> json) {
    return Trail(
      id: id,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      resourceCount: json['resourceCount'] ?? 0,
      totalTimeSpent:
      Duration(seconds: json['totalTimeSpentSeconds'] ?? 0),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastAccessed:
      (json['lastAccessed'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'title': title,
    'subtitle': subtitle,
    'resourceCount': resourceCount,
    'totalTimeSpentSeconds': totalTimeSpent.inSeconds,
    'createdAt': createdAt,
    'lastAccessed': lastAccessed,
  };

  Trail copyWith({
    String? id,
    String? userId,
    String? title,
    String? subtitle,
    int? resourceCount,
    Duration? totalTimeSpent,
    DateTime? createdAt,
    DateTime? lastAccessed,
  }) {
    return Trail(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      resourceCount: resourceCount ?? this.resourceCount,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      createdAt: createdAt ?? this.createdAt,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }
}
