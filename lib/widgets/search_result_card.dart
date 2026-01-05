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
  return "";
}

class SearchResultCard extends StatefulWidget {
  final SearchResult result;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  bool _isPressed = false;
  String get videoId => extractYoutubeId(widget.result.url);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // This ensures tap events are captured even on transparent areas
      onTap: () {
        print('🎯 Card tapped: ${widget.result.title}');
        widget.onTap();
      },
      onTapDown: (_) {
        print('👆 Tap down detected');
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        print('👆 Tap up detected');
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        print('❌ Tap cancelled');
        setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isPressed
                ? TracelyTheme.primary900
                : Colors.grey.shade200,
            width: _isPressed ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: _isPressed ? 8 : 4,
              offset: Offset(0, _isPressed ? 4 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SOURCE ROW
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: TracelyTheme.neutral0,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      widget.result.iconAsset,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.result.domain,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.result.url,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// TITLE
            Text(
              widget.result.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: TracelyTheme.links,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            /// CONTENT
            if (widget.result.type == ResourceSourceType.youtube)
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://img.youtube.com/vi/$videoId/0.jpg',
                      width: 140,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 140,
                          height: 80,
                          color: TracelyTheme.neutral100,
                          child: const Icon(Icons.play_circle_outline),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.result.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else
              Text(
                widget.result.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),

            if (widget.result.type == ResourceSourceType.pdf) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: TracelyTheme.neutral100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PDF • ${widget.result.detail} pages',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
