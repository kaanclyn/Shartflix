import 'package:dio/dio.dart';

class DioClient {
  DioClient._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://caseapi.servicelabs.tech',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: <String, dynamic>{
              'Content-Type': 'application/json',
            },
            validateStatus: (int? status) => status != null && status < 500,
          ),
        );

  static final DioClient instance = DioClient._internal();

  final Dio dio;
}


