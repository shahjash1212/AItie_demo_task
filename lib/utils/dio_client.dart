import 'package:aitie_demo/utils/dio_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  static Dio? _dio;

  static String normalBaseUrl = 'asdlkjfasldkfj';

  static Dio getClient() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: normalBaseUrl,
          validateStatus: (status) => status != null && status <= 500,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        ),
      );

      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.baseUrl = normalBaseUrl;

            handler.next(options);
          },
        ),
      );

      _dio!.interceptors.add(DioInterceptor().getInterceptor());
    }
    return _dio!;
  }

  static Future<dynamic> get(
    String uri, {

    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await getClient().get(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: (options ?? Options()).copyWith(extra: {...?options?.extra}),
      );
      return response.data;
    } catch (_) {
      throw const FormatException('Unable to process the data');
    }
  }

  static Future<dynamic> post(
    String uri, {

    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await getClient().post(
        uri,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: (options ?? Options()).copyWith(extra: {...?options?.extra}),
      );
      return response.data;
    } catch (_) {
      throw const FormatException('Unable to process the data');
    }
  }

  Future<bool> download(
    String url,
    String saveFilePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    _dio!.interceptors.clear();
    try {
      await _dio!.download(url, saveFilePath);
      return true;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    }
  }

  Future<dynamic> postMultipartFile(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await getClient().post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    }
  }

  Future<dynamic> patch(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await getClient().patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    }
  }

  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await getClient().delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    }
  }
}
