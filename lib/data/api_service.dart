import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:minshawy/models/surah_model.dart';

class ApiService {
  static const String baseUrl =
      'https://menshawy1-new.runasp.net/api/Suras';

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  static Future<List<SurahModel>> getSuras() async {
    try {
      Response response = await _dio.get(baseUrl);

      return (response.data as List)
          .map((surah) => SurahModel.fromJson(surah))
          .toList();
    } on DioException catch (e) {
      log(e.toString(), name: 'API Error');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw 'تعذر الاتصال بالخادم، حاول مرة أخرى لاحقاً';
      }

      throw 'حدث خطأ غير متوقع';
    }
  }
}