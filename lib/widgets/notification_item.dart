import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../data/dummy.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final bool isUnread;

  const NotificationItem({
    super.key,
    required this.notification,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot indicator
          if (!notification.isRead)
            Container(
              margin: const EdgeInsets.only(top: 6, right: 10),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: TracelyTheme.secondary500,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(width: 16),
          // Space to align with the dot

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: TracelyTheme.primary900,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      notification.timeAgo,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Body
                Text(
                  notification.body,
                  style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}