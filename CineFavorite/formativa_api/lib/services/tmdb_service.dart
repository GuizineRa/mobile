import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/filme_model.dart';

class TmdbService {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> buscarFilmes(String query) async {
    final url = Uri.parse(
      '$baseUrl/search/movie?query=$query&language=pt-BR',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhMzliOGJkMDk2YmZjMTg5NzFjNzJlZTRlZTc1NGYyYiIsIm5iZiI6MTc4NzY1NjE4Mi4zNzUsInN1YiI6IjZhOGQ3N2Y2MTY1MjFmMjk3NzExMTc2ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NeM6AhnXVhUCNedLao014PgIHyCxXBuerbysosNwaXs',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List results = data['results'];

      return results
          .map((filme) => Movie.fromJson(filme))
          .toList();
    } else {
      throw Exception('Erro ao buscar filmes');
    }
  }
}