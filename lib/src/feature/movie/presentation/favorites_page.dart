import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../data/movie_repository.dart';
import '../data/models/movie_models.dart';
import '../data/demo_favorites.dart';
import '../data/local_favorites.dart';
import '../data/mock_movies.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/strings.dart';
import '../../home/presentation/widgets/poster_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  final MovieRepository _repo = MovieRepository();
  List<MovieModel> _items = <MovieModel>[];
  bool _loading = true;

  static final ValueNotifier<int> refreshTicker = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _load();
    refreshTicker.addListener(() {
      if (mounted) {
        _load();
      }
    });
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    try {
      final List<MovieModel> list = await _repo.favorites();
      final List<String> localIds = await LocalFavorites.all();
      if (localIds.isNotEmpty) {
        final List<MovieModel> mockAll = MockMovieDataSource.all();
        for (final String id in localIds) {
          if (id.startsWith('demo')) {
            list.add(
              MovieModel(
                id: 'demo-1',
                title: 'Demo Movie',
                description: 'Demo description',
                posterUrl: 'https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg',
              ),
            );
          } else {
            final MovieModel found = mockAll.firstWhere(
              (MovieModel m) => m.id == id,
              orElse: () => MovieModel(id: id, title: 'Unknown', description: '', posterUrl: ''),
            );
            list.add(found);
          }
        }
      }
      if (!mounted) return;
      setState(() {
        _items = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load favorites: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        if (_loading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (_items.isEmpty) {
          return Center(child: Text(t.noFavorites));
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2/3,
            ),
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              final MovieModel m = _items[index];
              return PosterCard(movieId: m.id, imageUrl: m.posterUrl, title: m.title);
            },
          ),
        );
      },
    );
  }
}


