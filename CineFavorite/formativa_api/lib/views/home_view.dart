import 'package:flutter/material.dart';
import '../controllers/movie_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final MovieController movieController = MovieController();
  final TextEditingController searchController = TextEditingController();

  Future<void> buscar() async {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      return;
    }

    setState(() {
      movieController.carregando = true;
    });

    await movieController.buscarFilmes(query);

    setState(() {
      movieController.carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineFavorite'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Digite o nome de um filme',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: buscar,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => buscar(),
            ),
          ),

          if (movieController.carregando)
            const CircularProgressIndicator(),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemCount: movieController.filmes.length,
              itemBuilder: (context, index) {
                final filme = movieController.filmes[index];

                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: filme.posterPath != null
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w500${filme.posterPath}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : const Icon(
                                Icons.movie,
                                size: 80,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          filme.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}