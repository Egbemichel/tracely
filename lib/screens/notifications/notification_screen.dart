import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../app/theme.dart';
import '../../data/dummy.dart';
import '../../widgets/icons.dart';
import '../../widgets/notification_empty.dart';
import '../../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  final bool hasNotifications;

  const NotificationsScreen({super.key, this.hasNotifications = true});

  static const String routeName = "notifications";
  static const String path = "/notifications";

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String activeFilter = "All"; // "All" or "Unread"
  Set<AppNotification> unread = {}; // track unread items

  @override
  void initState() {
    super.initState();

    // Initialize ALL notifications from dummy list
    unread = dummyNotifications.values
        .expand((list) => list)
        .toSet();

    // Auto mark each unread notification after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        unread.clear(); // all read after 3 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNotifications = widget.hasNotifications;

    // Filter Logic
    final filteredData = dummyNotifications.map((section, items) {
      final filteredItems = activeFilter == "Unread"
          ? items.where((n) => unread.contains(n)).toList()
          : items;

      return MapEntry(section, filteredItems);
    });

    // Count unread
    final int unreadCount = unread.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(IconsaxPlusLinear.arrow_left,
                            color: TracelyTheme.primary900),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: TracelyTheme.primary900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            if (hasNotifications) ...[
              // FILTER CHIPS
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => activeFilter = "All"),
                      child: Chip(
                        side: BorderSide(color: activeFilter == 'All' ? TracelyTheme.secondary500 : TracelyTheme.neutral100),
                        label: Text(
                          'All',
                          style: TextStyle(
                            color: activeFilter == "All"
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: activeFilter == "All"
                            ? TracelyTheme.secondary500
                            : TracelyTheme.neutral100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // UNREAD CHIP
                    GestureDetector(
                      onTap: () => setState(() => activeFilter = "Unread"),
                      child: Chip(
                        side: const BorderSide(color: TracelyTheme.neutral100),
                        label: Text(
                          'Unread ($unreadCount)',
                          style: TextStyle(
                            color: activeFilter == "Unread"
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: activeFilter == "Unread"
                            ? TracelyTheme.secondary500
                            : TracelyTheme.neutral100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ],
                ),
              ),

              // LIST OF NOTIFICATIONS
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  children: filteredData.entries.expand((entry) {
                    final section = entry.key;
                    final items = entry.value;

                    if (items.isEmpty) return <Widget>[];

                    return [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                        child: Text(
                          section,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TracelyTheme.primary900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ...items.map((n) => NotificationItem(
                        notification: n,
                        isUnread: unread.contains(n),
                      )),
                    ];
                  }).toList(),
                ),
              ),
            ] else
              const Expanded(
                child: Center(child: NotificationsEmptyState()),
              ),
          ],
        ),
      ),
    );
  }
}
