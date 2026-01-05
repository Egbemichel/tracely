import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../app/theme.dart';
import '../models/resource.dart';

class ResourceTimelineItem extends StatelessWidget {
  final Resource resource;
  final bool isLast;

  const ResourceTimelineItem({super.key, required this.resource, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    // Determine icon based on ResourceType
    IconData leadingIcon;
    Color iconColor;
    String actionText;

    switch (resource.type) {
      case ResourceType.link:
        leadingIcon = IconsaxPlusLinear.global;
        iconColor = TracelyTheme.warning;
        actionText = 'You visited';
        break;
      case ResourceType.document:
        leadingIcon = IconsaxPlusLinear.note_2;
        iconColor = TracelyTheme.links;
        actionText = 'You uploaded';
        break;
      case ResourceType.youtube:
        leadingIcon = IconsaxPlusLinear.play;
        iconColor = Colors.red.shade600;
        actionText = 'You watched';
        break;
    }

    // Helper to format time (e.g., "Last visited 2 days ago")
    String timeAgo = _formatTimeAgo(resource.lastVisited ?? resource.createdAt);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Column (Icon and Line)
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.2,
                  ),
                  color: iconColor.withValues(alpha: 0.1),
                ),
                child: Icon(leadingIcon, color: iconColor, size: 20),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),
          // Content Column
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 30), // Padding between items
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action Text (e.g., You visited)
                  Text(
                    actionText,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),

                  // Title and Source
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          resource.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black, // default style for the rest
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(text: '• '),
                              TextSpan(
                                text: resource.source,
                                style: TextStyle(
                                  color: resource.type == ResourceType.link
                                      ? TracelyTheme.links
                                      : Colors.black, // example: different style if needed
                                  fontWeight: FontWeight.bold,
                                  fontStyle: resource.type == ResourceType.link
                                      ? FontStyle.italic
                                      : FontStyle.normal
                                  ,
                                ),
                              ),
                              TextSpan(text: ' • ${resource.metadata['detail'] ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Link/Timestamp and Last Visited time
                  Row(
                    children: [
                      // Link icon for non-YouTube/non-Document items
                      if (resource.type == ResourceType.document)
                        Text('Last opened ', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                      if (resource.type == ResourceType.youtube)
                        Text('Last watched ', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                      if (resource.type == ResourceType.youtube)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: TracelyTheme.primary100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Link',
                                style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: "PlusJakartaSans", fontWeight: FontWeight.bold),
                              ),
                              Transform.rotate(
                                angle: 50 * 3.1415926535 / 180, // 50 degrees in radians
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    IconsaxPlusLinear.arrow_up,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ),
                              )
                            ]
                          )
                        ),

                      const Spacer(),
                      Flexible(
                        child: Text(
                          timeAgo,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Simple time ago formatter (for demo purposes)
  String _formatTimeAgo(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return 'Last visited ${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return 'Last visited ${diff.inHours} hr${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes > 0) {
      return 'Last visited ${diff.inMinutes} min${diff.inMinutes > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }
}