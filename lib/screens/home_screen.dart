import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/controllers/news_controller.dart';
import 'package:tribun_app/routes/app_pages.dart';
import 'package:tribun_app/utils/app_colors.dart';
import 'package:tribun_app/widgets/category_chip.dart';
import 'package:tribun_app/widgets/loading_shimmer.dart';
import 'package:tribun_app/widgets/news_card.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  void toggleTheme() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      themeMode.value = ThemeMode.light;
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      themeMode.value = ThemeMode.dark;
    }
  }
}

class HomeScreen extends StatelessWidget {
  final NewsController newsController = Get.put(NewsController());
  final ThemeController themeController = Get.put(ThemeController());
  final RxInt _selectedIndex = 0.obs;

  final List<Widget> _screens = [
    _HomeContent(),
    _ProfileSection()
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings,
                          color: AppColors.secondary),
                      onPressed: () {},
                    ),
                    // Logo adaptif dark/light mode
                    Image.asset(
                      isDark
                          ? 'assets/images/goodablewhite.png'
                          : 'assets/images/goodable logo.png',
                       height: isDark ? 25 : 50,
                      fit: BoxFit.contain,
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: AppColors.primary),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            String query = '';
                            return Dialog(
                              insetPadding: const EdgeInsets.all(20),
                              backgroundColor: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Search News",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground)),
                                    const SizedBox(height: 12),
                                    TextField(
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Type keyword...',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onChanged: (value) => query = value,
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            newsController.searchNews(query);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                          ),
                                          child: const Text('Search'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: _screens[_selectedIndex.value],
          bottomNavigationBar: Obx(() {
            final isDark = Get.isDarkMode;
            return BottomNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              currentIndex: _selectedIndex.value,
              selectedItemColor: AppColors.primary, 
              unselectedItemColor:
                  isDark ? Colors.grey[500] : Colors.grey[700],
              onTap: (index) {
                if (index == 2) {
                  themeController.toggleTheme();
                } else {
                  _selectedIndex.value = index;
                }
              },
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                  label: isDark ? 'Light Mode' : 'Dark Mode',
                ),
              ],
            );
          }),
        ));
  }
}

class _HomeContent extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onBackground;
    final secondaryTextColor = Theme.of(context).textTheme.bodySmall?.color;

    return Obx(() {
      if (controller.isLoading) return const LoadingShimmer();

      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/wrong.png', width: 120, height: 120),
              const SizedBox(height: 16),
              Text('Something went wrong D:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 8),
              Text('Please check your internet connection',
                  style: TextStyle(color: secondaryTextColor)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.refreshNews,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.articles.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/nonews.png', height: 200, width: 200),
              const SizedBox(height: 12),
              Text('No news available :( !',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary)),
              const SizedBox(height: 8),
              Text('Please try again later 🙏',
                  style: TextStyle(color: secondaryTextColor)),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshNews,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category chips
              Container(
                height: 60,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return Obx(() => CategoryChip(
                          label: category.capitalize ?? category,
                          isSelected: controller.selectedCategory == category,
                          onTap: () => controller.selectCategory(category),
                        ));
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Good day, Ekin!",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    const SizedBox(height: 4),
                    Text("Here's your daily dose of good quality news",
                        style:
                            TextStyle(color: secondaryTextColor, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Carousel
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.articles.length > 5
                      ? 5
                      : controller.articles.length,
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(Routes.NEWS_DETAIL,
                          arguments: article),
                      child: Container(
                        width: 320,
                        margin: const EdgeInsets.only(left: 16, right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                          image: article.urlToImage != null
                              ? DecorationImage(
                                  image: NetworkImage(article.urlToImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.6),
                                Colors.transparent
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(article.title ?? '',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Text(
                                "${article.source?.name ?? 'Unknown'} • ${article.publishedAt ?? ''}",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Today’s news section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today’s News",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary)),
                    const SizedBox(height: 6),
                    Container(
                      height: 3,
                      width: double.infinity,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // News list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(
                    controller.articles.length > 5
                        ? controller.articles.length - 5
                        : 0,
                    (index) {
                      final article = controller.articles[index + 5];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: NewsCard(
                          article: article,
                          onTap: () => Get.toNamed(Routes.NEWS_DETAIL,
                              arguments: article),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
class _ProfileSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
       child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Biar tulisan Profile agak ke kanan
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                          AssetImage('assets/images/profile.jpeg'),
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Uyik Kuyurik",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "kurkuruyik@gmail.com",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),
                    Divider(
                      color: AppColors.primary
                    ),
                    const SizedBox(height: 8),

                    // Menu List
                    _buildProfileTile(
                      context,
                      icon: Icons.edit,
                      text: "Edit Profile",
                      onTap: () {},
                    ),
                    _buildProfileTile(
                      context,
                      icon: Icons.card_giftcard,
                      text: "Membership",
                      onTap: () {},
                    ),
                    _buildProfileTile(
                      context,
                      icon: Icons.support_agent,
                      text: "Support",
                      onTap: () {},
                    ),
                    _buildProfileTile(
                      context,
                      icon: Icons.settings,
                      text: "Settings",
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Log Out",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(BuildContext context,
      {required IconData icon, required String text, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      onTap: onTap,
    );
  }
}


