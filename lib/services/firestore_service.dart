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
        return Trail()
          ..id = doc.id
          ..userId = userId
          ..title = doc['title']
          ..subtitle = doc['subtitle']
          ..createdAt = doc['createdAt'].toDate()
          ..lastAccessed = DateTime.now();
      }
    }

    final ref = await _db.collection('trails').add({
      'userId': userId,
      'title': title,
      'subtitle': 'Created from search',
      'createdAt': DateTime.now(),
      'lastAccessed': DateTime.now(),
    });

    return Trail()
      ..id = ref.id
      ..userId = userId
      ..title = title
      ..subtitle = 'Created from search'
      ..createdAt = DateTime.now()
      ..lastAccessed = DateTime.now();
  }

  Future<void> saveResource(Resource resource) async {
    await _db.collection('resources').add(resource.toJson());
  }
}
