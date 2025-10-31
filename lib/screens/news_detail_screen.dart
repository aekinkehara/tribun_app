import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsDetailScreen extends StatelessWidget {
  final NewsArticles article = Get.arguments as NewsArticles;

  NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // Stack biar tombol tetep nempel di bawah
      body: Stack(
        children: [
          Column(
            children: [
              // Compact AppBar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.primary,
                        ),
                        onPressed: () => Get.back(),
                        iconSize: 22,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Image.asset(
                        isDark
                            ? 'assets/images/goodablewhite.png'
                            : 'assets/images/goodable logo.png',
                        height: isDark ? 25 : 50,
                        fit: BoxFit.contain,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: AppColors.secondary,
                        ),
                        onPressed: () {},
                        iconSize: 22,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),

              // Konten berita scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Gambar header
                      article.urlToImage != null
                          ? CachedNetworkImage(
                              imageUrl: article.urlToImage!,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 300,
                                color: AppColors.divider,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 300,
                                color: AppColors.divider,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Container(
                              height: 300,
                              color: AppColors.divider,
                              child: const Icon(
                                Icons.newspaper,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),

                      // Container isi berita
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(50),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (article.source?.name != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      article.source!.name!,
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 10),
                                if (article.publishedAt != null)
                                  Text(
                                    timeago.format(DateTime.parse(article.publishedAt!)),
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.orange,
                                  ),
                                  onPressed: _shareArticle,
                                  iconSize: 20,
                                ),
                                PopupMenuButton(
                                  color: theme.cardColor,
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'copy_link':
                                        _copyLink();
                                        break;
                                      case 'open_browser':
                                        _openInBrowser();
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'copy_link',
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.copy,
                                            color: AppColors.primary,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Copy Link',
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'open_browser',
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.open_in_browser,
                                            color: AppColors.secondary,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Open in browser',
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            if (article.title != null)
                              Text(
                                article.title!,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.28,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),

                            const SizedBox(height: 10),

                            if (article.description != null)
                              Text(
                                article.description!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 15,
                                  height: 1.45,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[800],
                                ),
                              ),

                            const SizedBox(height: 12),

                            if (article.content != null)
                              Text(
                                article.content!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: isDark
                                      ? Colors.grey[300]
                                      : Colors.black87,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Tombol tetap di bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: theme.cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: implement comments action
                      },
                      icon: Icon(
                        Icons.comment,
                        color: AppColors.secondary,
                      ),
                      label: Text(
                        'Comments',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: theme.cardColor,
                        side: BorderSide(color: AppColors.secondary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _openInBrowser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Read Full Article',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareArticle() {
    if (article.url != null) {
      Share.share(
        '${article.title ?? 'Check out this news'}\n\n${article.url!}',
        subject: article.title,
      );
    }
  }

  void _copyLink() {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar(
        'Success',
        'Link copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _openInBrowser() async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open the link',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
