import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/dio_client.dart';
import 'models/auth_models.dart';

class AuthRepository {
  AuthRepository({Dio? dio, FlutterSecureStorage? storage})
      : _dio = dio ?? DioClient.instance.dio,
        _storage = storage ?? const FlutterSecureStorage();

    static const String _tokenKey = 'auth_token';
    static const String _lastUserKey = 'auth_last_user';
    static const String _lastLoginAtKey = 'auth_last_login_at';

  final Dio _dio;
  final FlutterSecureStorage _storage;

  Future<AuthResponse> login({required String email, required String password}) async {
    final Response<dynamic> res = await _dio.post('/user/login', data: <String, dynamic>{'email': email, 'password': password});
    final Map<String, dynamic> data = (res.data is Map<String, dynamic>) ? res.data as Map<String, dynamic> : <String, dynamic>{};
    if (res.statusCode != null && res.statusCode! >= 400) {
      final String message = (data['message'] ?? data['error'] ?? 'Login failed (${res.statusCode})').toString();
      throw message;
    }
    final Map<String, dynamic> payload = (data['data'] is Map<String, dynamic>) ? data['data'] as Map<String, dynamic> : data;
    final AuthResponse parsed = AuthResponse.fromJson(payload);
    if (parsed.token.isNotEmpty) {
      await _storage.write(key: _tokenKey, value: parsed.token);
    }
    await _storage.write(key: _lastLoginAtKey, value: DateTime.now().toIso8601String());
    // Persist last successful login user (used as a fallback)
    await _storage.write(key: _lastUserKey, value: jsonEncode(<String, dynamic>{
      'id': parsed.user.id,
      'name': parsed.user.name,
      'email': parsed.user.email,
      'photoUrl': parsed.user.photoUrl,
    }));
    return parsed;
  }

  Future<AuthResponse> register({required String name, required String email, required String password}) async {
    final Response<dynamic> res = await _dio.post('/user/register', data: <String, dynamic>{'name': name, 'email': email, 'password': password});
    final Map<String, dynamic> data = (res.data is Map<String, dynamic>) ? res.data as Map<String, dynamic> : <String, dynamic>{};
    if (res.statusCode != null && res.statusCode! >= 400) {
      final String message = (data['message'] ?? data['error'] ?? 'Sign up failed (${res.statusCode})').toString();
      throw message;
    }
    final Map<String, dynamic> payload = (data['data'] is Map<String, dynamic>) ? data['data'] as Map<String, dynamic> : data;
    final AuthResponse parsed = AuthResponse.fromJson(payload);
    if (parsed.token.isNotEmpty) {
      await _storage.write(key: _tokenKey, value: parsed.token);
    }
    await _storage.write(key: _lastLoginAtKey, value: DateTime.now().toIso8601String());
    await _storage.write(key: _lastUserKey, value: jsonEncode(<String, dynamic>{
      'id': parsed.user.id,
      'name': parsed.user.name,
      'email': parsed.user.email,
      'photoUrl': parsed.user.photoUrl,
    }));
    return parsed;
  }

  Future<UserModel> profile() async {
    final String? token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) {
      throw 'No active session found. Please sign in again.';
    }
    final Response<dynamic> res = await _dio.get(
      '/user/profile',
      options: Options(headers: <String, dynamic>{'Authorization': 'Bearer $token'}),
    );
    if (res.statusCode != null && res.statusCode! >= 400) {
      final Map<String, dynamic> data = (res.data is Map<String, dynamic>) ? res.data as Map<String, dynamic> : <String, dynamic>{};
      final String message = (data['message'] ?? data['error'] ?? 'Failed to fetch profile (${res.statusCode})').toString();
      throw message;
    }
    final dynamic body = res.data;
    if (body is Map<String, dynamic>) {
      final Map<String, dynamic>? fromDirect = (body.containsKey('id') || body.containsKey('email')) ? body : null;
      final Map<String, dynamic>? fromUser = body['user'] is Map<String, dynamic> ? body['user'] as Map<String, dynamic> : null;
      final Map<String, dynamic>? fromData = body['data'] is Map<String, dynamic> ? body['data'] as Map<String, dynamic> : null;
      final Map<String, dynamic>? payload = fromDirect ?? fromUser ?? fromData;
      if (payload != null) {
        return UserModel.fromJson(payload);
      }
    }
    return UserModel.fromJson(<String, dynamic>{});
  }

  Future<UserModel> profileFromStoredToken() async {
    final String? token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) {
      throw 'No active session found. Please sign in again.';
    }
    try {
      final List<String> parts = token.split('.');
      if (parts.length < 2) throw 'Geçersiz token';
      final String payload = parts[1];
      String normalized = payload.replaceAll('-', '+').replaceAll('_', '/');
      while (normalized.length % 4 != 0) {
        normalized += '=';
      }
      final List<int> bytes = base64Decode(normalized);
      final Map<String, dynamic> decoded = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final String id = (decoded['sub'] ?? decoded['id'] ?? '').toString();
      final String name = (decoded['name'] ?? decoded['fullName'] ?? decoded['username'] ?? '').toString();
      final String email = (decoded['email'] ?? '').toString();
      final String? photoUrl = decoded['photoUrl']?.toString();
      return UserModel(id: id, name: name, email: email, photoUrl: photoUrl);
    } catch (_) {
      return UserModel.fromJson(<String, dynamic>{});
    }
  }

  Future<UserModel?> lastKnownUser() async {
    final String? raw = await _storage.read(key: _lastUserKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<String> uploadPhoto({required String filePath}) async {
    final String? token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) {
      throw 'No active session found. Please sign in again.';
    }
    final FormData formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
    });
    final Response<dynamic> res = await _dio.post(
      '/user/upload_photo',
      data: formData,
      options: Options(
        headers: <String, dynamic>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    final Map<String, dynamic> data = (res.data is Map<String, dynamic>) ? res.data as Map<String, dynamic> : <String, dynamic>{};
    if (res.statusCode != null && res.statusCode! >= 400) {
      final String message = (data['message'] ?? data['error'] ?? 'Upload failed (${res.statusCode})').toString();
      throw message;
    }
    final String url = (data['photoUrl'] ?? data['url'] ?? '').toString();
    if (url.isEmpty) return '';
    final UserModel? cached = await lastKnownUser();
    if (cached != null) {
      await _storage.write(
        key: _lastUserKey,
        value: jsonEncode(<String, dynamic>{
          'id': cached.id,
          'name': cached.name,
          'email': cached.email,
          'photoUrl': url,
        }),
      );
    }
    return url;
  }

  Future<DateTime?> getLastLoginAt() async {
    final String? raw = await _storage.read(key: _lastLoginAtKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.parse(raw);
    } catch (_) {
      return null;
    }
  }
}


