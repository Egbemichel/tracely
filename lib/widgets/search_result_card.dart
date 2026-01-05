import 'package:flutter/material.dart';
import 'package:tracely_clean/widgets/search_result.dart';

import '../app/theme.dart';

String extractYoutubeId(String url) {
  try {
    if (url.contains("v=")) {
      return url.split("v=")[1].split("&")[0];
    } else if (url.contains("youtu.be/")) {
      return url.split("youtu.be/")[1].split("?")[0];
    } else if (url.contains("/embed/")) {
      return url.split("/embed/")[1].split("?")[0];
    } else if (url.contains("/shorts/")) {
      return url.split("/shorts/")[1].split("?")[0];
    }
  } catch (_) {}

  return ""; // fallback (prevents crash)
}

class SearchResultCard extends StatelessWidget {
  final SearchResult result;

  const SearchResultCard({super.key, required this.result, required void Function() onTap});
  String get videoId => extractYoutubeId(result.url);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Source Row (Icon, Domain, URL)
          Row(
            children: [
              // Placeholder for Source Logo (e.g., W3Schools logo or Mount Allison University logo)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: TracelyTheme.neutral0,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(result.iconAsset, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.domain,
                      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      result.url,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 5),

          // Title
          Text(
            result.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: TracelyTheme.links,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 5),

          // Content Area (Changes based on type)
          if (result.type == ResourceSourceType.youtube)
          // YouTube Thumbnail/Link
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder for YouTube Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    'https://img.youtube.com/vi/$videoId/0.jpg',
                    height: 80,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 80,
                        width: 150,
                        decoration: BoxDecoration(
                          color: TracelyTheme.neutral100,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: const Icon(
                          Icons.play_circle_outline,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 80,
                        width: 150,
                        decoration: BoxDecoration(
                          color: TracelyTheme.neutral100,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.title,
                        style: const TextStyle(fontSize: 14, color: TracelyTheme.links, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.url,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            // Description (Web/PDF)
            Text(
              result.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
          ],

          // PDF/Detail Tag
          if (result.type == ResourceSourceType.pdf)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: TracelyTheme.neutral100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'PDF ${result.detail} pages',
                style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            )
        ],
      ),
    );
  }
}