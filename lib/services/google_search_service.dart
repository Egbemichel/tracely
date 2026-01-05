import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleSearchService {
  static final String _apiKey = dotenv.env['GOOGLE_API_KEY']!;
  static final String _searchEngineId = dotenv.env['SEARCH_ENGINE_ID']!;

  static Future<List<SearchResultDTO>> search(String query) async {
    final uri = Uri.https(
      'www.googleapis.com',
      '/customsearch/v1',
      {
        'key': _apiKey,
        'cx': _searchEngineId,
        'q': query,
      },
    );

    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Search request timed out. Please try again.');
        },
      );

      if (response.statusCode == 404) {
        throw Exception('Search service not found (404). Please check configuration.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key (401). Please check credentials.');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden (403). API quota may be exceeded.');
      } else if (response.statusCode == 400) {
        throw Exception('Invalid search request (400).');
      } else if (response.statusCode != 200) {
        throw Exception('Search failed with status ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      final items = decoded['items'] as List<dynamic>? ?? [];

      if (items.isEmpty) {
        return [];
      }

      return items.map((item) {
        return SearchResultDTO(
          title: item['title']?.toString() ?? 'Untitled',
          link: item['link']?.toString() ?? '',
          snippet: item['snippet']?.toString() ?? 'No description available',
        );
      }).toList();
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      }
      rethrow;
    }
  }
}

class SearchResultDTO {
  final String title;
  final String link;
  final String snippet;

  SearchResultDTO({
    required this.title,
    required this.link,
    required this.snippet,
  });
}
