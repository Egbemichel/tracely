import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../app/theme.dart';
import '../../data/dummy.dart';
import '../../widgets/resource_timeline.dart';

import '../../models/trail.dart';
import '../../models/resource.dart';

class TrailDetailScreen extends StatelessWidget {
  final Trail trail;

  const TrailDetailScreen({super.key, required this.trail});

  @override
  Widget build(BuildContext context) {
    // Get resources for this trail from dummy data
    final List<Resource> trailResources = getResourcesForTrail(trail.id);

    // Sort resources by lastVisited date (most recent first), handling nullable lastVisited
    final List<Resource> sortedResources = List<Resource>.from(trailResources)
      ..sort((a, b) => (b.lastVisited ?? DateTime(1970)).compareTo(a.lastVisited ?? DateTime(1970)));


    // Simple date formatter (e.g., "Nov 22")
    String formatDate(DateTime date) =>
        '${_monthAbrevs[date.month]} ${date.day}';
    String formatTime(DateTime date) =>
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';


    return Scaffold(
      backgroundColor: Colors.white,
      // Placeholder for Bottom Nav
      bottomNavigationBar: Container(height: 100, color: Colors.transparent),
      body: CustomScrollView(
        slivers: [
          // --- Custom Header (SliverAppBar) ---
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            pinned: true,
            // Increased toolbarHeight slightly to accommodate the new status chip
            toolbarHeight: 90,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  // Back Button (Using IconsaxPlusLinear.arrow_left)
                  IconButton(
                    icon: const Icon(IconsaxPlusLinear.arrow_left, color: TracelyTheme.primary900),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  // Created/Updated Info
                  Expanded( // Use Expanded to prevent overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Created Date/Time Chip (New Styling)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: TracelyTheme.primary100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            'Created ${formatDate(trail.createdAt)} at ${formatTime(trail.createdAt)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              // fontFamily: "PlusJakartaSans" // Removed font family check
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Trail Title
                        Text(
                          trail.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: TracelyTheme.primary900,
                            // fontFamily: "PlusJakartaSans"
                          ),
                        ),
                        // Resource Count and Last Updated
                        Text(
                          // Calculate total resources from the list
                          '${trailResources.length} ${trailResources.length == 1 ? 'resource' : 'resources'} • Last updated on ${formatDate(trail.lastAccessed ?? trail.createdAt)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            // fontFamily: "PlusJakartaSans"
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Placeholder for progress tracking when implemented
                  ],
                ),
              ),
            ),
          ),

          // --- Resources Viewed Timeline ---
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                  child: Text(
                    'Resources viewed',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: TracelyTheme.primary900
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      ...List.generate(sortedResources.length, (index) {
                        return ResourceTimelineItem(
                          resource: sortedResources[index],
                          isLast: index == sortedResources.length - 1,
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 100), // Space for the bottom nav bar
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Month Abbreviation map
const Map<int, String> _monthAbrevs = {
  1: 'Jan', 2: 'Feb', 3: 'Mar', 4: 'Apr', 5: 'May', 6: 'Jun',
  7: 'Jul', 8: 'Aug', 9: 'Sep', 10: 'Oct', 11: 'Nov', 12: 'Dec',
};