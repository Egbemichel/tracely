import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/dummy.dart';
import '../../models/trail.dart';
import '../../widgets/card.dart';
import '../../widgets/filters.dart';
import '../../widgets/searchbar.dart';
import '../../widgets/welcome_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = "home";
  static const String path = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "All";

  // --- FILTER LOGIC (applied only to list under banner) ---
  List<Trail> filterTrails(List<Trail> trails) {
    // Since Trail doesn't have progress property, just return all trails
    // Filter logic can be extended when progress tracking is added
    return trails;
  }

  @override
  Widget build(BuildContext context) {
    // Sort ALL trails first → find true banner
    final sortedAll = List<Trail>.from(dummyTrails)
      ..sort((a, b) => (b.lastAccessed ?? DateTime(1970)).compareTo(a.lastAccessed ?? DateTime(1970)));

    final bannerTrail = sortedAll.first;

    // Everything except the banner
    final rest = sortedAll.skip(1).toList();

    // Apply filters ONLY to the rest
    final listTrails = filterTrails(rest);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    const WelcomeHeader(userName: "Egbe"),
                    const SizedBox(height: 20),

                    const TracelySearchBar(text: 'What are you looking for?'),
                    const SizedBox(height: 25),

                    const Text(
                      "Where you left off",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "PlusJakartaSans",
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // --- FIXED BANNER (NEVER CHANGES) ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          context.push('/trail/${bannerTrail.id}');
                        },
                        child: TrailCard(trail: bannerTrail, isBanner: true),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Filters
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CourseFilters(
                        selected: selectedFilter,
                        onFilterChanged: (value) {
                          setState(() => selectedFilter = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --- FILTERED LIST (NO BANNER INCLUDED) ---
                    // LIST OF TRAILS (AFTER FILTER)
                    if (listTrails.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: listTrails.map((trail) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                context.push('/trail/${trail.id}');
                              },
                              child: TrailCard(trail: trail, isBanner: false),
                            ),
                          );
                        }).toList(),
                      ),


                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
