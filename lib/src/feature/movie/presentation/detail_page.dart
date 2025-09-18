import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../data/movie_repository.dart';
import '../data/demo_favorites.dart';
import '../data/local_favorites.dart';
import '../../../core/widgets/modern_dialog.dart';
import '../presentation/favorites_page.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/strings.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.movieId, required this.imageUrl, required this.title});

  final String movieId;
  final String imageUrl;
  final String title;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  bool _fav = false;
  final MovieRepository _repo = MovieRepository();

  @override
  void initState() {
    super.initState();
    if (widget.movieId.startsWith('demo') || widget.movieId.startsWith('m')) {
      LocalFavorites.isFavorite(widget.movieId).then((bool v) async {
        DemoFavorites.setFavorite(widget.movieId, v);
        if (mounted) setState(() => _fav = v);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        if (widget.movieId.startsWith('demo') || widget.movieId.startsWith('m')) {
          _fav = _fav || DemoFavorites.isFavorite(widget.movieId);
        }
        return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.85)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        if (_fav && (widget.movieId.startsWith('demo') || widget.movieId.startsWith('m'))) {
                          final bool ok = await showModernConfirmDialog(
                            context,
                            title: t.removeFavorite,
                            message: t.removeFavoriteMessage,
                            confirmText: t.remove,
                            cancelText: t.cancel,
                          );
                          if (!ok) return;
                        }

                        setState(() => _fav = !_fav);
                        if (widget.movieId.startsWith('demo') || widget.movieId.startsWith('m')) {
                          DemoFavorites.toggle(widget.movieId);
                          await LocalFavorites.toggle(widget.movieId);
                          FavoritesPageState.refreshTicker.value++;
                          return;
                        }
                        try {
                          await _repo.toggleFavorite(widget.movieId);
                          FavoritesPageState.refreshTicker.value++;
                        } catch (_) {}
                      },
                      icon: Icon(_fav ? Icons.favorite : Icons.favorite_outline),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: <Widget>[
                      AnimatedScale(
                        duration: const Duration(milliseconds: 180),
                        scale: _fav ? 1.1 : 1.0,
                        child: Icon(
                          Icons.favorite,
                          color: _fav ? Colors.redAccent : Colors.white24,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(_fav ? t.addedToFavorites : t.addToFavorites,
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(t.watchTrailer),
      ),
        );
      },
    );
  }
}


