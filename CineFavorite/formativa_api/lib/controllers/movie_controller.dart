import '../models/filme_model.dart';
import '../services/tmdb_service.dart';

class MovieController {
  final TmdbService tmdbService = TmdbService();

  List<Movie> filmes = [];
  bool carregando = false;

  Future<void> buscarFilmes(String query) async {
    carregando = true;

    try {
      filmes = await tmdbService.buscarFilmes(query);
    } catch (e) {
      print('Erro: $e');
    } finally {
      carregando = false;
    }
  }
}