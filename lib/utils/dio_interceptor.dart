import 'dart:convert';

import 'package:aitie_demo/constants/api_status.dart';
import 'package:aitie_demo/routing/app_router.dart';
import 'package:aitie_demo/routing/route_names.dart';
import 'package:aitie_demo/utils/api_header.dart';
import 'package:aitie_demo/utils/api_result_class.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class DioInterceptor {
  GoRouter router = AppRouter.route;
  InterceptorsWrapper getInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        Map<String, dynamic> headers = await ApiHeaders.getHeaders();

        headers.addAll(options.headers);
        options.headers = headers;
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (response.statusCode == ApiStatus.s401) {
          return handler.next(response);
        }

        var data = response.data;

        if (data is String) {
          data = jsonDecode(data);
        }
        if (response.statusCode == ApiStatus.s200) {
          response.data = ApiResult.success(
            data: data['data'],
            message: data.containsKey('message') ? data['message'] : null,
          );
        } else {
          response.data = ApiResult.failure(
            errorMessage: data['message'] ?? '',
            statusCode: response.statusCode ?? ApiStatus.s1,
          );
        }

        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        String errorMessage = "Something went wrong";

        // 1. Get the current active route location from GoRouter
        final String currentLocation =
            router.routerDelegate.currentConfiguration.last.matchedLocation;

        // 2. Check if the current location is already the error screen
        final bool isAlreadyOnExternalError = currentLocation.contains(
          RouteNames.error,
        );

        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage = "Connection timed out. Please check your internet.";
          e.response?.data = ApiResult.failure(
            errorMessage: errorMessage,
            statusCode: e.response?.statusCode ?? ApiStatus.s1,
          );

          // Only navigate if we aren't already there
          if (!isAlreadyOnExternalError) {
            router.go('${RouteNames.error}?message=$errorMessage');
          }
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = "No internet connection.";
          e.response?.data = ApiResult.failure(
            errorMessage: errorMessage,
            statusCode: e.response?.statusCode ?? ApiStatus.s1,
          );

          // Only navigate if we aren't already there
          if (!isAlreadyOnExternalError) {
            router.push('${RouteNames.error}?message=$errorMessage');
          }
        } else {
          errorMessage = e.message ?? "Something went wrong";
          e.response?.data = ApiResult.failure(
            errorMessage: errorMessage,
            statusCode: e.response?.statusCode ?? ApiStatus.s1,
          );
        }

        return handler.next(e);
      },
    );
  }
}
