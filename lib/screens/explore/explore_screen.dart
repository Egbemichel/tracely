import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../app/theme.dart';
import '../../services/google_search_service.dart';
import '../../widgets/searchbar.dart';
import '../../widgets/search_result_card.dart';
import '../../widgets/search_result.dart' as widget_models;
import '../../widgets/resource_preview_drawer.dart';

/// ===============================
/// CONFIG
/// ===============================
final String googleApiKey = dotenv.env['GOOGLE_API_KEY']?? '';
final String searchEngineId = dotenv.env['SEARCH_ENGINE_ID']?? '';

/// ===============================
/// MODELS
/// ===============================
enum SearchResultType { web, pdf, youtube }

class SearchResult {
  final String id;
  final String title;
  final String snippet;
  final String url;
  final SearchResultType type;
  final String source;

  SearchResult({
    required this.id,
    required this.title,
    required this.snippet,
    required this.url,
    required this.type,
    required this.source,
  });
}

/// ===============================
/// UI
/// ===============================
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  static const String routeName = "explore";
  static const String path = "/explore";

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<SearchResult> _results = [];
  bool _isLoading = false;
  String? _error;

  void _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _results.clear();
      _error = null;
    });

    try {
      final results = await GoogleSearchService.search(query);

      if (!mounted) return;

      setState(() {
        _results.clear();
        _results.addAll(results.map((r) {
          // Determine type based on URL
          SearchResultType type = SearchResultType.web;
          try {
            if (r.link.contains('youtube.com') || r.link.contains('youtu.be')) {
              type = SearchResultType.youtube;
            } else if (r.link.toLowerCase().endsWith('.pdf')) {
              type = SearchResultType.pdf;
            }
          } catch (e) {
            debugPrint('Error determining type: $e');
          }

          // Safely parse URI
          String source = 'Unknown';
          try {
            source = Uri.parse(r.link).host;
            if (source.isEmpty) source = 'Unknown';
          } catch (e) {
            debugPrint('Error parsing URI: $e');
          }

          return SearchResult(
            id: '${DateTime.now().millisecondsSinceEpoch}_${r.link.hashCode}',
            title: r.title.isEmpty ? 'No title' : r.title,
            snippet: r.snippet.isEmpty ? 'No description available' : r.snippet,
            url: r.link,
            type: type,
            source: source,
          );
        }).toList());
      });
    } catch (e) {
      debugPrint('Search error: $e');
      if (!mounted) return;

      String errorMessage = 'Unable to complete search';
      if (e.toString().contains('404')) {
        errorMessage = 'Search service not found (404)';
      } else if (e.toString().contains('401') || e.toString().contains('403')) {
        errorMessage = 'Search access denied. Please check API credentials';
      } else if (e.toString().contains('SocketException') || e.toString().contains('NetworkException')) {
        errorMessage = 'No internet connection';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Search request timed out';
      }

      setState(() {
        _error = errorMessage;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _performSearch(query),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onResultTap(SearchResult result) async {
    print('🔥 Search result tapped: ${result.title}');

    // Show the resource preview drawer
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ResourcePreviewDrawer(
        searchResult: _mapToWidgetSearchResult(result),
      ),
    );
  }

  // Helper method to convert SearchResult to widget SearchResult
  widget_models.SearchResult _mapToWidgetSearchResult(SearchResult result) {
    return widget_models.SearchResult(
      type: _mapToResourceSourceType(result.type),
      iconAsset: _getIconAsset(result.type),
      domain: result.source,
      url: result.url,
      title: result.title,
      description: result.snippet,
      detail: _getDetail(result.type),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TracelyTheme.neutral100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Explore",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TracelyTheme.primary900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),

              TracelySearchBar(
                text: "Search anything",
                onSubmitted: _performSearch,
              ),

              const SizedBox(height: 20),

              Expanded(child: _buildResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: TracelyTheme.secondary500),
            SizedBox(height: 16),
            Text(
              'Searching...',
              style: TextStyle(
                color: TracelyTheme.secondary500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TracelyTheme.secondary500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: TracelyTheme.secondary500.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "Search the web to begin",
              style: TextStyle(
                color: TracelyTheme.secondary500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      primary: false, // Prevents ListView from blocking parent gestures
      physics: const BouncingScrollPhysics(),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];

        try {
          // Convert to widget SearchResult
          final widgetResult = widget_models.SearchResult(
            type: _mapToResourceSourceType(result.type),
            iconAsset: _getIconAsset(result.type),
            domain: result.source,
            url: result.url,
            title: result.title,
            description: result.snippet,
            detail: _getDetail(result.type),
          );

          return SearchResultCard(
            result: widgetResult,
            onTap: () => _onResultTap(result),
          );
        } catch (e) {
          debugPrint('Error building search result card: $e');
          // Return empty container if card fails to build
          return const SizedBox.shrink();
        }
      },
    );
  }

  widget_models.ResourceSourceType _mapToResourceSourceType(SearchResultType type) {
    switch (type) {
      case SearchResultType.youtube:
        return widget_models.ResourceSourceType.youtube;
      case SearchResultType.pdf:
        return widget_models.ResourceSourceType.pdf;
      case SearchResultType.web:
        return widget_models.ResourceSourceType.web;
    }
  }

  String _getIconAsset(SearchResultType type) {
    switch (type) {
      case SearchResultType.youtube:
        return 'Y';
      case SearchResultType.pdf:
        return 'P';
      case SearchResultType.web:
        return 'W';
    }
  }

  String _getDetail(SearchResultType type) {
    switch (type) {
      case SearchResultType.youtube:
        return 'Video';
      case SearchResultType.pdf:
        return 'PDF';
      case SearchResultType.web:
        return '';
    }
  }
}
