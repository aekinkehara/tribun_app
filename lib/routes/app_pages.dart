// app pages adalah file induk, bisa berdiri sendiri tanpa app routes
import 'package:get/get.dart';
import 'package:tribun_app/bindings/home_bindings.dart';
import 'package:tribun_app/screens/home_screen.dart';
import 'package:tribun_app/screens/news_detail_screen.dart';
import 'package:tribun_app/screens/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
      // untuk manggil semua yg ada di controller
      binding: HomeBindings(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL,
      page: () => NewsDetailScreen(),
    )
  ];
}