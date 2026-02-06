abstract class Result<T> {
  const Result.empty();
}

class SuccessResult<T> extends Result<T> {
  final T? data;
  final String? message;
  final bool? success;
  const SuccessResult({this.data, this.message, this.success}) : super.empty();
}

class FailureResult<T> extends Result<T> {
  final bool? success;
  final T? data;
  final int? statusCode;
  final dynamic error;
  const FailureResult({this.success, this.data, this.statusCode, this.error})
    : super.empty();
}
