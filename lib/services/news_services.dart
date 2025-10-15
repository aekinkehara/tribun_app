import 'dart:convert';

import 'package:tribun_app/models/news_response.dart';
import 'package:tribun_app/utils/constants.dart';
// mendefinisikan sebuah package atau library menjadi sebuah variable secara langsung
import 'package:http/http.dart' as http;

class NewsServices {
  static const String _baseUrl = Constants.baseUrl;
  static final String _apiKey = Constants.apiKey;

  // fungsi yang bertujuan untuk membuat request GET ke server
  Future<NewsResponse> getTopHeadlines({
    String country = Constants.defaultCountry,
    String? category,
    int page = 1,
    int pageSize = 20
  }) async {
    try {
      final Map<String, String> queryParams = {
        'apiKey': _apiKey,
        'country': country,
        'page': page.toString(),
        'pageSize': pageSize.toString()
      };

      // statement yang akan dijalankan ketika category tidak kosong
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      // Uri = mengidentifkasi sebuah URL
      // berfungsi untuk parsing(melempar & mengambil) data dari json ke UI
      // simplenya: kita daftarin baseUrl + endpoint yang akan digunakan
      final uri = Uri.parse('$_baseUrl${Constants.topHeadlines}')
      .replace(queryParameters: queryParams);

      // untuk menyimpan respon yang diberikan oleh server
      final response = await http.get(uri);

      // kode yang akan dijalankan jika request ke API sukses
      if (response.statusCode == 200) {
        // untuk merubah data dari json ke bahasa dart
        final jsonData = json.decode(response.body);
        return NewsResponse.fromJson(jsonData);
        // kode yang akan dijalankan jika request ke API gagal (status HTTP =! 200)
      } else {
        throw Exception('Failed to load news, please try again later.');

      }
      // kode yang akan dijalankan ketika terjadi error lain, selain yang sudah dibuat di atas
    } catch (e) {
      throw Exception('Another problem occured, please try again later.');
    }
  }
  Future<NewsResponse> searchNews({
    // ini adalah nilai yang dimasukkan ke kolom pencarian
    required String query, 
    // ini untuk mendefinisikan halaman berita keberapa
    int page = 1,
    // berapa banyak berita yang ingin ditampilkan ketika sekali proses rendering data
    int pageSize = 20,
    String? sortBy,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'apiKey': _apiKey,
        'q': query,
        'page': page.toString(),
        'pageSize': pageSize.toString()
      };

      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      final uri = Uri.parse('$_baseUrl${Constants.everything}')
            .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NewsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to find news, please try again later.');
      }
    } catch (e) {
      throw Exception('Another problem occured, please try again later.');
    }
  }
}