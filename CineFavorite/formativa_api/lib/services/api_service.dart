import 'dart:convert';
import 'package:http/http.dart' as http;

class TmdbService {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<void> buscarFilmes(String query) async {
    final url = Uri.parse(
      '$baseUrl/search/movie?query=$query&language=pt-BR',
    );

    final response = await http.get(url);

    print(response.statusCode);
    print(response.body);
  }
}