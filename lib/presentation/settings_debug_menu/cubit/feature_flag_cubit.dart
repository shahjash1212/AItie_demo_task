import 'package:aitie_demo/constants/app_snack_bar.dart';
import 'package:aitie_demo/presentation/settings_debug_menu/settings_screen.dart';
import 'package:aitie_demo/utils/feature_flag_service.dart';
import 'package:aitie_demo/utils/local_db_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'feature_flag_state.dart';

class FeatureFlagCubit extends Cubit<FeatureFlagState> {
  final FeatureFlagService _service;
  final LocalDbService _localDbService;

  FeatureFlagCubit({
    required FeatureFlagService service,
    required LocalDbService localDbService,
  }) : _service = service,
       _localDbService = localDbService,
       super(FeatureFlagState.initial());

  Future<void> loadFlags() async {
    await _service.initializeDefaults();
    emit(
      FeatureFlagState(
        isFavoritesEnabled: _service.isFavoritesEnabled,
        isCartEnabled: _service.isCartEnabled,
        isOfflineCachingEnabled: _service.isOfflineCachingEnabled,
        isDebugMenuEnabled: _service.isDebugMenuEnabled,
      ),
    );
  }

  Future<void> toggleFavorites(bool value) async {
    await _service.setFavoritesEnabled(value);
    emit(state.copyWith(isFavoritesEnabled: value));
  }

  Future<void> toggleCart(bool value) async {
    await _service.setCartEnabled(value);
    emit(state.copyWith(isCartEnabled: value));
  }

  Future<void> toggleOfflineCaching(bool value) async {
    await _service.setOfflineCachingEnabled(value);
    emit(state.copyWith(isOfflineCachingEnabled: value));

    if (!value) {
      await _localDbService.clearDatabase();
    }
  }

  Future<void> toggleDebugMenu(bool value) async {
    await _service.setDebugMenuEnabled(value);
    emit(state.copyWith(isDebugMenuEnabled: value));
  }

  // Enable debug menu with tap counter
  int _tapCount = 0;

  void incrementTapCount(BuildContext context) {
    _tapCount++;
    if (_tapCount >= 5) {
      toggleDebugMenu(true);
      _tapCount = 0;

      showSnackBar(context, '🔓 Debug menu activated!');
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          SettingsBottomSheet.show(context);
        }
      });
    }
  }

  void resetTapCount() {
    _tapCount = 0;
  }
}
