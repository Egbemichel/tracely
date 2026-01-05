import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../app/theme.dart';
import '../models/resource.dart';
import '../services/firestore_service.dart';
import '../widgets/search_result.dart';

class ResourcePreviewDrawer extends StatefulWidget {
  final SearchResult searchResult;
  const ResourcePreviewDrawer({super.key, required this.searchResult});

  @override
  State<ResourcePreviewDrawer> createState() => _ResourcePreviewDrawerState();
}

class _ResourcePreviewDrawerState extends State<ResourcePreviewDrawer> {
  late final WebViewController _webController;
  final _firestoreService = FirestoreService();
  final _uuid = const Uuid();
  late final DateTime _openedAt;

  // New variables for trail management
  List<dynamic> _userTrails = [];
  String? _selectedTrailId;
  bool _isLoadingTrails = true;
  bool _isCreatingNewTrail = false;
  bool _showTrailSelector = false;
  final TextEditingController _newTrailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _openedAt = DateTime.now();

    // Create WebView controller with default parameters
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress if needed
          },
          onPageStarted: (String url) {
            // Page started loading
          },
          onPageFinished: (String url) {
            // Page finished loading
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      );

    // Load resource based on type
    if (widget.searchResult.type == ResourceSourceType.web) {
      _webController.loadRequest(Uri.parse(widget.searchResult.url));
    } else if (widget.searchResult.type == ResourceSourceType.youtube) {
      final youtubeEmbedUrl = _toYouTubeEmbedUrl(widget.searchResult.url);
      _webController.loadRequest(Uri.parse(youtubeEmbedUrl));
    } else if (widget.searchResult.type == ResourceSourceType.pdf) {
      // PDF loading via Google Docs viewer fallback
      final pdfUrl =
          'https://docs.google.com/gview?embedded=true&url=${widget.searchResult.url}';
      _webController.loadRequest(Uri.parse(pdfUrl));
    }

    // Load user trails
    _loadUserTrails();
  }

  Future<void> _loadUserTrails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isLoadingTrails = false);
      return;
    }

    try {
      final trails = await _firestoreService.getTrailsForUser(userId);
      setState(() {
        _userTrails = trails;
        _isLoadingTrails = false;
        // Don't auto-select - user must choose
        _selectedTrailId = null;
        // Always show selector so user can choose or create
        _showTrailSelector = true;
      });
    } catch (e) {
      print('Error loading trails: $e');
      setState(() => _isLoadingTrails = false);
    }
  }

  Future<void> _createNewTrail() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final trailName = _newTrailController.text.trim();
    if (trailName.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a trail name'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      // Create new trail using FirestoreService
      final newTrail = await _firestoreService.getOrCreateTrail(
        userId: userId,
        title: trailName,
      );

      // Reload trails and select the new one
      await _loadUserTrails();

      setState(() {
        _selectedTrailId = newTrail.id;
        _isCreatingNewTrail = false;
        _showTrailSelector = false;
        _newTrailController.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Trail "$trailName" created!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating trail: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _extractPageData() async {
    if (widget.searchResult.type != ResourceSourceType.web) return {};
    try {
      final result = await _webController.runJavaScriptReturningResult("""
        (function() {
          return {
            title: document.title,
            description: document.querySelector('meta[name="description"]')?.content,
            headings: Array.from(document.querySelectorAll('h1,h2')).map(h => h.innerText),
            language: document.documentElement.lang,
            wordCount: document.body.innerText.split(' ').length
          };
        })()
      """);
      return Map<String, dynamic>.from(result as Map);
    } catch (_) {
      return {};
    }
  }

  Future<void> _closeAndSave() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to save resources')),
        );
      }
      return;
    }

    // Check if a trail is selected
    if (_selectedTrailId == null || _selectedTrailId!.isEmpty) {
      // Show trail selector if not selected
      setState(() => _showTrailSelector = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a trail to add this resource'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final duration = DateTime.now().difference(_openedAt);
    final extractedData = await _extractPageData();

    // Map ResourceSourceType to ResourceType
    ResourceType resourceType;
    switch (widget.searchResult.type) {
      case ResourceSourceType.youtube:
        resourceType = ResourceType.youtube;
        break;
      case ResourceSourceType.pdf:
        resourceType = ResourceType.document;
        break;
      case ResourceSourceType.web:
        resourceType = ResourceType.link;
        break;
    }

    // Create resource object with valid trailId
    final resource = Resource()
      ..id = _uuid.v4()
      ..userId = userId
      ..trailId = _selectedTrailId! // Now guaranteed to be non-empty
      ..type = resourceType
      ..title = widget.searchResult.title
      ..source = widget.searchResult.url
      ..domain = widget.searchResult.domain
      ..metadata = {
        'domain': widget.searchResult.domain,
        'description': widget.searchResult.description,
        'detail': widget.searchResult.detail,
        'extractedData': extractedData,
      }
      ..timeSpent = duration
      ..createdAt = DateTime.now()
      ..lastVisited = DateTime.now();

    // Save to Firestore
    try {
      await _firestoreService.saveResource(resource);
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Resource saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving resource: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Convert YouTube link to embed URL
  String _toYouTubeEmbedUrl(String url) {
    final regExp = RegExp(r'(?:v=|youtu\.be/)([\w-]+)');
    final match = regExp.firstMatch(url);
    final videoId = match?.group(1) ?? '';
    return 'https://www.youtube.com/embed/$videoId';
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.99,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Preview Resource',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: TracelyTheme.primary900),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: _closeAndSave,
                      tooltip: 'Save Resource',
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Close',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Trail Selector (shown when needed)
              if (_showTrailSelector || _selectedTrailId == null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: TracelyTheme.primary100.withValues(alpha: 0.3),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.folder, size: 20, color: TracelyTheme.primary900),
                          const SizedBox(width: 8),
                          const Text(
                            'Select Trail',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: TracelyTheme.primary900,
                            ),
                          ),
                          const Spacer(),
                          if (!_showTrailSelector && _selectedTrailId != null)
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () => setState(() => _showTrailSelector = true),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_isLoadingTrails)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_isCreatingNewTrail)
                        // New trail creation form
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _newTrailController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Enter trail name...',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (_) => _createNewTrail(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _createNewTrail,
                                    icon: const Icon(Icons.check, size: 18),
                                    label: const Text('Create'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: TracelyTheme.primary900,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _isCreatingNewTrail = false;
                                        _newTrailController.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.close, size: 18),
                                    label: const Text('Cancel'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else if (_userTrails.isEmpty)
                        // Empty state with create button
                        Column(
                          children: [
                            const Text(
                              'No trails found. Create one to get started!',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => setState(() => _isCreatingNewTrail = true),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Create New Trail'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TracelyTheme.primary900,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        // Trail selector with create new option
                        Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedTrailId,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: _userTrails.map((trail) {
                                return DropdownMenuItem<String>(
                                  value: trail.id,
                                  child: Text(
                                    trail.title,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTrailId = value;
                                  _showTrailSelector = false;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => setState(() => _isCreatingNewTrail = true),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Create New Trail'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: TracelyTheme.primary900,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

              // WebView - No parent widget blocking scroll, takes all available space
              Expanded(
                child: WebViewWidget(controller: _webController),
              ),
            ],
          ),
        );
      },
    );
  }
}
