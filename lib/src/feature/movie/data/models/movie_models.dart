class MovieModel {
  MovieModel({required this.id, required this.title, required this.description, required this.posterUrl});
  final String id;
  final String title;
  final String description;
  final String posterUrl;

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
        posterUrl: (json['posterUrl'] ?? '').toString(),
      );
}

class MovieListResponse {
  MovieListResponse({required this.movies, required this.totalPages, required this.currentPage});
  final List<MovieModel> movies;
  final int totalPages;
  final int currentPage;

  factory MovieListResponse.fromJson(Map<String, dynamic> json) => MovieListResponse(
        movies: ((json['movies'] as List<dynamic>? ) ?? <dynamic>[])
            .map((dynamic e) => MovieModel.fromJson((e as Map<String, dynamic>)))
            .toList(),
        totalPages: int.tryParse((json['totalPages'] ?? '0').toString()) ?? 0,
        currentPage: int.tryParse((json['currentPage'] ?? '0').toString()) ?? 0,
      );
}


