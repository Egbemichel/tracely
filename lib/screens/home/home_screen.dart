import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/trail.dart';
import '../../services/firestore_service.dart';
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
  final _firestoreService = FirestoreService();
  String selectedFilter = "All";
  List<Trail> _trails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrails();
  }

  Future<void> _loadTrails() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Add timeout to prevent infinite loading
      final trails = await _firestoreService.getTrailsForUser(currentUser.uid)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timed out. Please check your internet connection.');
            },
          );
      print('Successfully loaded ${trails.length} trails');
      setState(() {
        _trails = trails;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error loading trails: $e');
      print('Stack trace: $stackTrace');

      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load trails: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- FILTER LOGIC (applied only to list under banner) ---
  List<Trail> filterTrails(List<Trail> trails) {
    // Since Trail doesn't have progress property, just return all trails
    // Filter logic can be extended when progress tracking is added
    return trails;
  }

  @override
  Widget build(BuildContext context) {
    // Get current user from Firebase
    final currentUser = FirebaseAuth.instance.currentUser;

    // Extract username from email (part before @)
    String userName = "Guest";
    if (currentUser != null && currentUser.email != null) {
      userName = currentUser.email!.split('@').first;
      // Capitalize first letter
      userName = userName[0].toUpperCase() + userName.substring(1);
    }

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

                    WelcomeHeader(userName: userName),
                    const SizedBox(height: 20),

                    const TracelySearchBar(text: 'What are you looking for?'),
                    const SizedBox(height: 25),

                    // Show loading indicator while fetching data
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    // Show message if no trails exist
                    else if (_trails.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No trails yet",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Start exploring to create your first learning trail",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    // Show trails when data is loaded
                    else
                      _buildTrailsContent(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrailsContent() {
    // Sort trails by lastAccessed
    final sortedAll = List<Trail>.from(_trails)
      ..sort((a, b) => b.lastAccessed.compareTo(a.lastAccessed));

    final bannerTrail = sortedAll.first;

    // Everything except the banner
    final rest = sortedAll.skip(1).toList();

    // Apply filters ONLY to the rest
    final listTrails = filterTrails(rest);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        // --- FIXED BANNER (MOST RECENTLY ACCESSED) ---
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
    );
  }
}
