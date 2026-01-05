import '../models/resource.dart';
import '../models/trail.dart';

// --- DUMMY DATA & MODEL (Assuming TracelyTheme and other widgets are available) ---

// Helper function to create Resource instances
Resource _createResource({
  required String id,
  required String trailId,
  required ResourceType type,
  required String title,
  required String source,
  required String detail,
  required DateTime lastVisited,
}) {
  final resource = Resource()
    ..id = id
    ..userId = 'user1'
    ..trailId = trailId
    ..type = type
    ..title = title
    ..source = source
    ..metadata = {'detail': detail}
    ..createdAt = DateTime.now()
    ..lastVisited = lastVisited;
  return resource;
}

final List<Resource> dummyResources = [
  _createResource(
    id: "1",
    trailId: "1",
    type: ResourceType.link,
    title: "Wikipedia",
    source: "https://wikipedia.com",
    detail: "8 mins read",
    lastVisited: DateTime.now().subtract(const Duration(days: 2, minutes: 1)),
  ),
  _createResource(
    id: "2",
    trailId: "1",
    type: ResourceType.document,
    title: "Week 3 Security Slides.pdf",
    source: "30 KB",
    detail: "page 7 of 23",
    lastVisited: DateTime.now().subtract(const Duration(minutes: 20)),
  ),
  _createResource(
    id: "3",
    trailId: "2",
    type: ResourceType.youtube,
    title: "Networking basics",
    source: "freeCodeCamp",
    detail: "16:22 / 1:01:35",
    lastVisited: DateTime.now().subtract(const Duration(minutes: 40)),
  ),
  _createResource(
    id: "4",
    trailId: "1",
    type: ResourceType.document,
    title: "Week 4 Security Slides.pdf",
    source: "32 KB",
    detail: "page 5 of 17",
    lastVisited: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  _createResource(
    id: "5",
    trailId: "3",
    type: ResourceType.youtube,
    title: "IP addresses",
    source: "NetworkChuck",
    detail: "12:22 / 42:35",
    lastVisited: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
  ),
  _createResource(
    id: "6",
    trailId: "3",
    type: ResourceType.youtube,
    title: "Network Arch...",
    source: "freeCodeCamp",
    detail: "45:22 / 1:11:15",
    lastVisited: DateTime.now().subtract(const Duration(hours: 3)),

  ),
];

// Helper to get resources for a specific trail
List<Resource> getResourcesForTrail(String trailId) =>
    dummyResources.where((r) => r.trailId == trailId).toList();

// Helper function to create Trail instances
Trail _createTrail({
  required String id,
  required String title,
  required String subtitle,
  required DateTime createdAt,
  required DateTime lastAccessed,
}) {
  return Trail(
    id: id,
    userId: 'user1',
    title: title,
    subtitle: subtitle,
    createdAt: createdAt,
    lastAccessed: lastAccessed,
  );
}

// Dummy data with lastAccessed dates
final List<Trail> dummyTrails = [
  _createTrail(
    id: "1",
    title: "Web Security Essentials",
    subtitle: "Based on your recent activity on encryption",
    createdAt: DateTime(2025, 1, 22, 11, 47),
    lastAccessed: DateTime.now(), // MOST RECENTLY ACCESSED (Banner)
  ),
  _createTrail(
    id: "2",
    title: "Algorithm & data structures",
    subtitle: "progress",
    createdAt: DateTime(2025, 2, 22, 11, 47),
    lastAccessed: DateTime.now().subtract(const Duration(days: 1)),
  ),
  _createTrail(
    id: "3",
    title: "Object oriented programming with Python",
    subtitle: "progress",
    createdAt: DateTime(2025, 3, 22, 11, 47),
    lastAccessed: DateTime.now().subtract(const Duration(days: 5)),
  ),
  _createTrail(
    id: "4",
    title: "System software",
    subtitle: "progress",
    createdAt: DateTime(2025, 4, 22, 11, 47),
    lastAccessed: DateTime.now().subtract(const Duration(days: 15)),
  ),
];

// Dummy Stats (copied from previous response)
final Map<String, dynamic> dummyStats = {
  'time_spent': 17.52,
  'active_trail': 1,
  'resources_viewed': 8,
};

// --- Notification model (update/ensure this exists) ---
class AppNotification {
  final String title;
  final String body;
  final String timeAgo;
  final String category;
  bool isRead;

  AppNotification({
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.category,
    this.isRead = false,
  });
}

// --- Dummy data for populated state (with isRead set) ---
final Map<String, List<AppNotification>> dummyNotifications = {
  'Today': [
    AppNotification(
      title: 'Welcome to Tracely',
      body:
      'We at Tracely would like to welcome you to our amazing community, ready to 10X for studying? Enjoy and any feedback is much appreciated.',
      timeAgo: '12 mins ago',
      category: 'System',
      isRead: false,
    ),
    AppNotification(
      title: 'Feedback',
      body:
      'Do not be shy — leave feedback on your experience. We are devoted to making the most of your time with us.',
      timeAgo: '7h ago',
      category: 'System',
      isRead: true,
    ),
  ],
  'Yesterday': [
    AppNotification(
      title: 'Your course trail is expiring',
      body:
      'The "Web Security Essentials" trail is expiring soon. Complete it to save your progress.',
      timeAgo: '23h ago',
      category: 'Trail',
      isRead: true,
    ),
  ],
};

// --- Helper: unread count ---
int getUnreadCount() {
  return dummyNotifications.values
      .expand((list) => list)
      .where((n) => !n.isRead)
      .length;
}
