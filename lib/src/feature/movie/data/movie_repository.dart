import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/dio_client.dart';
import 'models/movie_models.dart';

class MovieRepository {
  MovieRepository({Dio? dio, FlutterSecureStorage? storage})
      : _dio = dio ?? DioClient.instance.dio,
        _storage = storage ?? const FlutterSecureStorage();

  final Dio _dio;
  final FlutterSecureStorage _storage;

  Future<MovieListResponse> list({required int page}) async {
    final String? token = await _storage.read(key: 'auth_token');
    final Response<dynamic> res = await _dio.get(
      '/movie/list',
      queryParameters: <String, dynamic>{'page': page},
      options: Options(headers: <String, dynamic>{'Authorization': 'Bearer $token'}),
    );
    return MovieListResponse.fromJson(res.data as Map<String, dynamic>);
  }

  Future<bool> toggleFavorite(String movieId) async {
    final String? token = await _storage.read(key: 'auth_token');
    final Response<dynamic> res = await _dio.post(
      '/movie/favorite/$movieId',
      options: Options(headers: <String, dynamic>{'Authorization': 'Bearer $token'}),
    );
    final Map<String, dynamic> data = (res.data is Map<String, dynamic>) ? (res.data as Map<String, dynamic>) : <String, dynamic>{};
    return (data['success'] == true);
  }

  Future<List<MovieModel>> favorites() async {
    final String? token = await _storage.read(key: 'auth_token');
    final Response<dynamic> res = await _dio.get(
      '/movie/favorites',
      options: Options(headers: <String, dynamic>{'Authorization': 'Bearer $token'}),
    );
    final Map<String, dynamic> data = res.data as Map<String, dynamic>;
    final List<dynamic> list = (data['movies'] as List<dynamic>? ) ?? <dynamic>[];
    return list.map((dynamic e) => MovieModel.fromJson((e as Map<String, dynamic>))).toList();
  }
}


