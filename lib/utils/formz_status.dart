enum FormzStatus { pure, inProgress, success, failure, initial }

extension FormzStatusExtension on FormzStatus {
  bool get isSuccess => this == FormzStatus.success;
  bool get isFailure => this == FormzStatus.failure;
  bool get isInital => this == FormzStatus.initial;
  bool get isInProgress => this == FormzStatus.inProgress;
  bool get isInPure => this == FormzStatus.pure;
}
