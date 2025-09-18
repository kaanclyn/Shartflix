import 'models/movie_models.dart';

class MockMovieDataSource {
  static const int pageSize = 5;

  static final List<MovieModel> _all = <MovieModel>[
    MovieModel(id: 'm1', title: 'Nebula Drift', description: 'Sci‑Fi epic.', posterUrl: 'https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg'),
    MovieModel(id: 'm2', title: 'Midnight Run', description: 'Chase thriller.', posterUrl: 'https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg'),
    MovieModel(id: 'm3', title: 'Crimson Tide', description: 'Submarine drama.', posterUrl: 'https://image.tmdb.org/t/p/w500/2CAL2433ZeIihfX1Hb2139CX0pW.jpg'),
    MovieModel(id: 'm4', title: 'Echoes', description: 'Psychological mystery.', posterUrl: 'https://image.tmdb.org/t/p/w500/6bCplVkhowCjTHXWv49UjRPn0eK.jpg'),
    MovieModel(id: 'm5', title: 'Silverline', description: 'Neo‑noir.', posterUrl: 'https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg'),
    MovieModel(id: 'm6', title: 'Aurora', description: 'Space survival.', posterUrl: 'https://image.tmdb.org/t/p/w500/fYPGMbF3jkpe48zTqbpYFzYUOov.jpg'),
    MovieModel(id: 'm7', title: 'Afterlight', description: 'Time‑bender.', posterUrl: 'https://image.tmdb.org/t/p/w500/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg'),
    MovieModel(id: 'm8', title: 'The Blackout', description: 'Apocalypse.', posterUrl: 'https://image.tmdb.org/t/p/w500/2LZDXtTLosJBFCW9PxFNGgV5DkS.jpg'),
    MovieModel(id: 'm9', title: 'Harbor', description: 'Coastal drama.', posterUrl: 'https://image.tmdb.org/t/p/w500/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg'),
    MovieModel(id: 'm10', title: 'Low Orbit', description: 'Orbital heist.', posterUrl: 'https://image.tmdb.org/t/p/w500/ceG9VzoRAVGwivFU403Wc3AHRys.jpg'),

    MovieModel(id: 'm11', title: 'Sentinel', description: 'Cyber thriller.', posterUrl: 'https://image.tmdb.org/t/p/w500/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg'),
    MovieModel(id: 'm12', title: 'Skyline', description: 'Aerial action.', posterUrl: 'https://image.tmdb.org/t/p/w500/2CAL2433ZeIihfX1Hb2139CX0pW.jpg'),
    MovieModel(id: 'm13', title: 'Rogue Wave', description: 'Sea survival.', posterUrl: 'https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg'),
    MovieModel(id: 'm14', title: 'Shadows', description: 'Noir mystery.', posterUrl: 'https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg'),
    MovieModel(id: 'm15', title: 'Mirage', description: 'Desert drama.', posterUrl: 'https://image.tmdb.org/t/p/w500/8YFL5QQVPy3AgrEQxNYVSgiPEbe.jpg'),
    MovieModel(id: 'm16', title: 'Relay', description: 'Heist ride.', posterUrl: 'https://image.tmdb.org/t/p/w500/ceG9VzoRAVGwivFU403Wc3AHRys.jpg'),
    MovieModel(id: 'm17', title: 'Quantum Edge', description: 'Sci‑Fi action.', posterUrl: 'https://image.tmdb.org/t/p/w500/6bCplVkhowCjTHXWv49UjRPn0eK.jpg'),
    MovieModel(id: 'm18', title: 'Overwatch', description: 'Tactical ops.', posterUrl: 'https://image.tmdb.org/t/p/w500/2LZDXtTLosJBFCW9PxFNGgV5DkS.jpg'),
    MovieModel(id: 'm19', title: 'Nightfall', description: 'Crime drama.', posterUrl: 'https://image.tmdb.org/t/p/w500/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg'),
    MovieModel(id: 'm20', title: 'Luminance', description: 'Tech future.', posterUrl: 'https://image.tmdb.org/t/p/w500/fYPGMbF3jkpe48zTqbpYFzYUOov.jpg'),
  ];

  static List<MovieModel> all() => _all;

  static Future<MovieListResponse> list({required int page}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final int start = (page - 1) * pageSize;
    final int end = (start + pageSize).clamp(0, _all.length);
    final List<MovieModel> chunk = start < _all.length ? _all.sublist(start, end) : <MovieModel>[];
    final int totalPages = (_all.length / pageSize).ceil();
    return MovieListResponse(movies: chunk, totalPages: totalPages, currentPage: page);
  }
}


