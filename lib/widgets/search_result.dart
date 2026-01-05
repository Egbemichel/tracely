enum ResourceSourceType { web, pdf, youtube }

class SearchResult {
  final ResourceSourceType type;
  final String iconAsset; // W3Schools logo, PDF icon, YouTube icon
  final String domain;
  final String url;
  final String title;
  final String description;
  final String detail; // Pages/Duration/Size

  SearchResult({
    required this.type,
    required this.iconAsset,
    required this.domain,
    required this.url,
    required this.title,
    required this.description,
    required this.detail,
  });
}

// Mock Search Results Data (Based on image_1d001f.png)
final List<SearchResult> mockSearchResults = [
  SearchResult(
    type: ResourceSourceType.web,
    iconAsset: 'W', // Placeholder for W3Schools logo
    domain: 'W3Schools',
    url: 'https://www.w3schools.com',
    title: 'Introduction to Data Structures and Algorithms',
    description: 'Data structures are essential ingredients in creating fast and powerful algorithms. They help in managing and organizing data, reduce complexity, and increase...',
    detail: '',
  ),
  SearchResult(
    type: ResourceSourceType.youtube,
    iconAsset: 'Y', // Placeholder for YouTube thumbnail
    domain: 'YouTube',
    url: 'freeCodeCamp.org',
    title: 'Data Structures & Algorithms in 49...',
    description: 'https://www.youtube.com/watch?v=hU49nQEZW5o', // YouTube thumbnail replaces description
    detail: 'Video',
  ),
  SearchResult(
    type: ResourceSourceType.pdf,
    iconAsset: 'M', // Placeholder for Mount Allison University logo
    domain: 'Mount Allison University',
    url: 'https://mta.ca',
    title: 'Data Structures and Algorithms',
    description: 'By G Barne . 2008, This book provides implementations of common algorithms in pseudocode which is language independent and provides for easy porting to most',
    detail: '235',
  ),
];