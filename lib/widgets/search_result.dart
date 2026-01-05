enum ResourceSourceType { web, pdf, youtube }

class SearchResult {
  final ResourceSourceType type;
  final String iconAsset; // W3Schools logo, PDF icon, YouTube icon
  final String domain;
  final String url;
  final String title;
  final String description;
  final String detail; // Pages/Duration/Size

  /// NEW: Extracted data from WebView and time spent
  final Map<String, dynamic>? extractedData;
  final Duration? timeSpent;

  SearchResult({
    required this.type,
    required this.iconAsset,
    required this.domain,
    required this.url,
    required this.title,
    required this.description,
    required this.detail,
    this.extractedData,
    this.timeSpent,
  });

  /// Helper to return a new SearchResult with consumption info
  SearchResult withConsumptionData({
    required Map<String, dynamic> extractedData,
    required Duration timeSpent,
  }) {
    return SearchResult(
      type: type,
      iconAsset: iconAsset,
      domain: domain,
      url: url,
      title: title,
      description: description,
      detail: detail,
      extractedData: extractedData,
      timeSpent: timeSpent,
    );
  }
}
