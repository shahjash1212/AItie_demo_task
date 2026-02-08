part of 'feature_flag_cubit.dart';

class FeatureFlagState extends Equatable {
  final bool isFavoritesEnabled;
  final bool isCartEnabled;
  final bool isOfflineCachingEnabled;
  final bool isDebugMenuEnabled;

  const FeatureFlagState({
    required this.isFavoritesEnabled,
    required this.isCartEnabled,
    required this.isOfflineCachingEnabled,
    required this.isDebugMenuEnabled,
  });

  factory FeatureFlagState.initial() {
    return const FeatureFlagState(
      isFavoritesEnabled: true,
      isCartEnabled: true,
      isOfflineCachingEnabled: true,
      isDebugMenuEnabled: false,
    );
  }

  FeatureFlagState copyWith({
    bool? isFavoritesEnabled,
    bool? isCartEnabled,
    bool? isOfflineCachingEnabled,
    bool? isDebugMenuEnabled,
  }) {
    return FeatureFlagState(
      isFavoritesEnabled: isFavoritesEnabled ?? this.isFavoritesEnabled,
      isCartEnabled: isCartEnabled ?? this.isCartEnabled,
      isOfflineCachingEnabled:
          isOfflineCachingEnabled ?? this.isOfflineCachingEnabled,
      isDebugMenuEnabled: isDebugMenuEnabled ?? this.isDebugMenuEnabled,
    );
  }

  @override
  List<Object?> get props => [
    isFavoritesEnabled,
    isCartEnabled,
    isOfflineCachingEnabled,
    isDebugMenuEnabled,
  ];
}
