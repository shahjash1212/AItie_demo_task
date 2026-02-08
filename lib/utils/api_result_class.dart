import 'package:aitie_demo/utils/result_class.dart';

abstract class ApiResult<T> extends Result<T> {
  const ApiResult._() : super.empty();
  const factory ApiResult.success({T data, String? message}) = ApiSuccess<T>;
  const factory ApiResult.failure({
    String errorMessage,
    required int statusCode,
  }) = ApiFailure<T>;
}

class ApiSuccess<T> extends ApiResult<T> {
  final T? data;
  final String? message;
  final bool? success;
  const ApiSuccess({this.data, this.message, this.success}) : super._();
}

class ApiFailure<T> extends ApiResult<T> {
  final String errorMessage;
  final bool? success;
  final int statusCode;
  const ApiFailure({
    required this.statusCode,
    this.success,
    this.errorMessage = 'Something Went Wrong',
  }) : super._();
}
