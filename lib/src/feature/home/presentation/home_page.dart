import 'package:flutter/material.dart';
import 'widgets/poster_card.dart';
import 'widgets/hero_banner.dart';
import 'widgets/glass_search_bar.dart';
import 'widgets/category_chips.dart';
import '../../auth/data/auth_repository.dart';
import '../../movie/data/movie_repository.dart';
import '../../movie/data/mock_movies.dart';
import '../../../core/widgets/modern_dialog.dart';
import '../../movie/data/models/movie_models.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<MovieModel> _items = <MovieModel>[];
  bool _isLoadingMore = false;
  int _page = 1;
  String? _displayName;
  late final MovieRepository _movieRepository;
  bool _useMock = false;
  String _selectedCategory = 'trending';
  String _query = '';

  @override
  void initState() {
    super.initState();
    _movieRepository = MovieRepository();
    _loadInitial();
    _scrollController.addListener(_onScroll);
    _loadProfile();
  }

  double _computeHeaderHeight(BuildContext context) {
    final Size s = MediaQuery.of(context).size;
    final double h = s.height * 0.42; 
    return h.clamp(340, 520); 
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    _page = 1;
    _items.clear();
    await _fetchPage(reset: true);
    if (mounted) setState(() {});
  }

  Future<void> _fetchPage({bool reset = false}) async {
    try {
      final MovieListResponse res = _useMock
          ? await MockMovieDataSource.list(page: _page)
          : await _movieRepository.list(page: _page);
      if (reset) _items.clear();
      _items.addAll(res.movies);
    } catch (e) {
      if (!mounted) return;
      final S tt = S.of(AppLocaleController.instance.locale);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${tt.failedToLoadMovies}: $e')),
      );
    }
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    _page += 1;
    await _fetchPage();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  Future<void> _onRefresh() async {
    await _loadInitial();
  }

  void _onCategoryChanged(String cat) {
    setState(() => _selectedCategory = cat);
  }

  void _onSearchChanged(String q) {
    setState(() => _query = q.trim());
  }

  List<MovieModel> _applyCategoryFilter(List<MovieModel> list) {
    bool _hasCover(MovieModel m) {
      final String u = m.posterUrl.trim();
      if (u.isEmpty) return false;
      if (!u.startsWith('http')) return false;
      final String lu = u.toLowerCase();
      if (!(lu.endsWith('.jpg') || lu.endsWith('.jpeg') || lu.endsWith('.png'))) return false;
      return true;
    }
    final List<MovieModel> withCovers = list.where(_hasCover).toList();

    List<MovieModel> base = _query.isEmpty
        ? withCovers
        : withCovers.where((MovieModel m) => m.title.toLowerCase().contains(_query.toLowerCase())).toList();
    if (_selectedCategory == 'trending') return base;
    bool matches(MovieModel m) {
      final String id = m.id;
      final String last = id.isNotEmpty ? id[id.length - 1] : '0';
      switch (_selectedCategory) {
        case 'action':
          return <String>['1', '4', '7', '0'].contains(last);
        case 'scifi':
          return <String>['2', '5', '8'].contains(last);
        case 'drama':
          return <String>['3', '6', '9'].contains(last);
        case 'comedy':
          return <String>['0', '5'].contains(last);
        default:
          return true;
      }
    }
    return base.where(matches).toList();
  }

  Future<void> _loadProfile() async {
    try {
      final AuthRepository repo = AuthRepository();
      final user = await repo.profile();
      if (mounted) setState(() => _displayName = user.name.isNotEmpty ? user.name : null);
    } catch (_) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _displayName == null ? t.shartflix : '${t.shartflix} · ${_displayName!}',
          style: const TextStyle(fontWeight: FontWeight.w800),
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              if (!_useMock) {
                final bool ok = await showModernConfirmDialog(
                  context,
                  title: t.useLocalDataTitle,
                  message: t.useLocalDataMessage,
                  confirmText: t.useLocal,
                  cancelText: t.cancel,
                );
                if (!ok) return;
                setState(() => _useMock = true);
                await _loadInitial();
              } else {
                final bool back = await showModernConfirmDialog(
                  context,
                  title: t.switchBackToBackend,
                  message: t.switchBackMessage,
                  confirmText: t.useBackendButton,
                  cancelText: t.stayLocal,
                );
                if (!back) return;
                setState(() => _useMock = false);
                await _loadInitial();
              }
            },
            icon: Icon(_useMock ? Icons.cloud_queue : Icons.cloud_off, size: 18),
            label: Text(_useMock ? t.useBackend : t.useLocalData),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GlassSearchBar(onChanged: _onSearchChanged),
                const SizedBox(height: 12),
                const HeroBanner(),
                const SizedBox(height: 12),
                SizedBox(height: 40, child: CategoryChips(onChanged: _onCategoryChanged)),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: _onRefresh,
              child: _items.isEmpty
                  ? ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: <Widget>[
                        Center(child: Text(t.noMoviesYet, style: const TextStyle(color: Colors.white70))),
                        const SizedBox(height: 12),
                        PosterCard(
                          movieId: 'demo-1',
                          imageUrl: 'https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg',
                          title: t.demoMovie,
                        ),
                        SizedBox(height: 16),
                      ],
                    )
                  : Builder(
                      builder: (BuildContext context) {
                        final List<MovieModel> withCovers = _items.where((MovieModel m) => m.posterUrl.isNotEmpty).toList();
                        if (withCovers.isEmpty && !_useMock) {
                          return ListView(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            children: <Widget>[
                              PosterCard(
                                movieId: 'demo-1',
                                imageUrl: 'https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg',
                                title: t.demoMovie,
                              ),
                              SizedBox(height: 16),
                            ],
                          );
                        }
                        return GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2/3,
                          ),
                          itemCount: _applyCategoryFilter(withCovers).length + (_isLoadingMore ? 2 : 0),
                          itemBuilder: (BuildContext context, int index) {
                            final List<MovieModel> filtered = _applyCategoryFilter(withCovers);
                            if (index >= filtered.length) {
                              return const Center(child: CircularProgressIndicator.adaptive());
                            }
                            final MovieModel m = filtered[index % filtered.length];
                            return PosterCard(movieId: m.id, imageUrl: m.posterUrl, title: m.title);
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
        );
      },
    );
  }
}

