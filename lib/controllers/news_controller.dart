import 'package:get/get.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/services/news_services.dart';
import 'package:tribun_app/utils/constants.dart';

class NewsController extends GetxController{
  // untuk memproses request yang sudah dibuat oleh NewsServices
  final NewsServices _newsServices = NewsServices();

  // setter
  // observable variables (variable yang bisa berubah)
  final _isLoading = false.obs; //apakah aplikasi sedang memuat berita? (true)
  final _articles = <NewsArticles>[].obs; // untuk menampilkan daftar berita yang sudah/berhasil didapat
  final _selectedCategory = 'general'.obs; //untuk menghandle category yang sudah dipilih (yang akan muncul di homescreen)
  final _error = ''.obs; //kalau ada kesalahan, pesan error akan disimpan disini

  //Getters
  //getter ini, seperti jendela untuk melihat isi variable yang sudah didefinisikan
  //dengan ini, UI bisa dengan mudah melihat data dari controller
  bool get isLoading => _isLoading.value;
  List<NewsArticles> get articles => _articles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;

  // begitu aplikasi dibuka, aplikasi langsung menampilkan berita utama 
  //dari endpoint top-headlines
  // TODO: Fetching data dari endpoint top-headlines

  Future<void> fetchTopHeadlines({String? category}) async {
    // blok ini akan dijalankan ketika request ke API berhasil
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.getTopHeadlines(
        category: category ?? _selectedCategory.value,
      );

      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      // finally tetep akan diexecute setelah salah satu blok dari try atau catch sudah berhasil mendapatkan hasil
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshNews() async {
    await fetchTopHeadlines();
  } 

  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
    }
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value= '';

      final response = await _newsServices.searchNews(query: query);
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to find news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM
      );
    } finally {
      _isLoading.value = false;
    }
  }
}