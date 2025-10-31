import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsCard extends StatelessWidget {
  final NewsArticles article;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === TEKS DI KIRI ===
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Source + waktu
                    Row(
                      children: [
                        if (article.source?.name != null)
                          Text(
                            article.source!.name!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.orange, // tetap oranye, biar kontras
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(width: 8),
                        if (article.publishedAt != null)
                          Text(
                            timeago.format(DateTime.parse(article.publishedAt!)),
                            style: textTheme.bodySmall?.copyWith(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white60
                                  : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Judul berita
                    if (article.title != null)
                      Text(
                        article.title!,
                        style: textTheme.titleSmall?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            // === GAMBAR DI KANAN ===
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? '',
                height: 100,
                width: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 100,
                  width: 120,
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 100,
                  width: 120,
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey[500]
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
