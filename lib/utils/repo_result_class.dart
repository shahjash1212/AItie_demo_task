import 'package:aitie_demo/utils/result_class.dart';

abstract class RepoResult<T> extends Result<T> {
  const RepoResult._() : super.empty();
  const factory RepoResult.success({T data, String? message}) = RepoSuccess<T>;
  const factory RepoResult.failure({
    String errorMessage,
    required int statusCode,
  }) = RepoFailure<T>;
}

class RepoSuccess<T> extends RepoResult<T> {
  final T? data;
  final String? message;
  final String? token;
  const RepoSuccess({this.data, this.message, this.token}) : super._();
}

class RepoFailure<T> extends RepoResult<T> {
  final String errorMessage;
  final int statusCode;
  const RepoFailure({
    this.errorMessage = 'Something Went Wrong',
    required this.statusCode,
  }) : super._();
}
