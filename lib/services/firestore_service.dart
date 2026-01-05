import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracely_clean/services/trail_matcher.dart';

import '../models/resource.dart';
import '../models/trail.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<Trail> getOrCreateTrail({
    required String userId,
    required String title,
  }) async {
    final trails = await _db
        .collection('trails')
        .where('userId', isEqualTo: userId)
        .get();

    for (final doc in trails.docs) {
      if (TrailMatcher.sameTopic(doc['title'], title)) {
        return Trail(
          id: doc.id,
          userId: userId,
          title: doc['title'],
          subtitle: doc['subtitle'],
          createdAt: (doc['createdAt'] as dynamic)?.toDate(),
          lastAccessed: DateTime.now(),
        );
      }
    }

    final ref = await _db.collection('trails').add({
      'userId': userId,
      'title': title,
      'subtitle': 'Created from search',
      'createdAt': DateTime.now(),
      'lastAccessed': DateTime.now(),
      'resourceCount': 0,
      'totalTimeSpentSeconds': 0,
    });

    return Trail(
      id: ref.id,
      userId: userId,
      title: title,
      subtitle: 'Created from search',
      createdAt: DateTime.now(),
      lastAccessed: DateTime.now(),
    );
  }

  Future<void> saveResource(Resource resource) async {
    final batch = _db.batch();

    final resourceRef = _db.collection('resources').doc(resource.id);
    final trailRef = _db.collection('trails').doc(resource.trailId);

    batch.set(resourceRef, resource.toJson());

    // Safely extract timeSpentSeconds from metadata if present
    final timeSpentSeconds = resource.metadata['timeSpentSeconds'] ?? 0;

    batch.update(trailRef, {
      'resourceCount': FieldValue.increment(1),
      'totalTimeSpentSeconds': FieldValue.increment(timeSpentSeconds),
      'lastAccessed': DateTime.now(),
    });

    await batch.commit();
  }

  // Fetch all trails for a specific user
  Future<List<Trail>> getTrailsForUser(String userId) async {
    final snapshot = await _db
        .collection('trails')
        .where('userId', isEqualTo: userId)
        .get();

    final trails = snapshot.docs
        .map((doc) => Trail.fromJson(doc.id, doc.data()))
        .toList();
    trails.sort((a, b) => b.lastAccessed.compareTo(a.lastAccessed));
    return trails;
  }

  // Fetch a single trail by ID
  Future<Trail?> getTrailById(String trailId) async {
    final doc = await _db.collection('trails').doc(trailId).get();

    if (!doc.exists) {
      return null;
    }

    return Trail.fromJson(doc.id, doc.data()!);
  }

  // Fetch all resources for a specific trail
  Future<List<Resource>> getResourcesForTrail(String trailId) async {
    final snapshot = await _db
        .collection('resources')
        .where('trailId', isEqualTo: trailId)
        .get();

    final resources = snapshot.docs.map((doc) {
      final data = doc.data();
      return Resource()
        ..id = doc.id
        ..userId = data['userId'] ?? ''
        ..trailId = data['trailId'] ?? ''
        ..type = _parseResourceType(data['type'])
        ..title = data['title'] ?? ''
        ..source = data['source'] ?? ''
        ..domain = data['domain'] ?? ''
        ..metadata = Map<String, dynamic>.from(data['metadata'] ?? {})
        ..visitCount = data['visitCount'] ?? 0
        ..timeSpent = Duration(seconds: data['timeSpentSeconds'] ?? 0)
        ..createdAt = (data['createdAt'] as Timestamp).toDate()
        ..lastVisited = (data['lastVisited'] as Timestamp).toDate();
    }).toList();

    // Sort by lastVisited (most recent first)
    resources.sort((a, b) => b.lastVisited.compareTo(a.lastVisited));

    return resources;
  }

  // Helper method to parse ResourceType from string
  ResourceType _parseResourceType(String? type) {
    switch (type) {
      case 'youtube':
        return ResourceType.youtube;
      case 'document':
        return ResourceType.document;
      case 'link':
        return ResourceType.link;
      default:
        return ResourceType.link;
    }
  }
}
