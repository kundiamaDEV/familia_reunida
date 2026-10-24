import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../family/domain/entities/family_entity.dart';
import '../../../family/domain/usecases/create_family_usecase.dart';
import 'family_setup_state.dart';

class FamilySetupController
    extends StateNotifier<FamilySetupState> {
  FamilySetupController(
    this._createFamilyUseCase,
  ) : super(const FamilySetupState());

  final CreateFamilyUseCase _createFamilyUseCase;

  Future<void> createFamily({
    required String officialName,
    required String shortName,
    required String country,
    required String createdBy,
    required String familyCode,
    required String inviteCode,
    String? nickname,
    String? province,
    String? description,
    String? photoUrl,
    String? coverPhotoUrl,
    FamilySettings settings = const FamilySettings(),
  }) async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(
      status: FamilySetupStatus.loading,
      clearError: true,
    );

    try {
      final params = CreateFamilyParams(
        id: _generateFamilyId(),
        officialName: officialName,
        shortName: shortName,
        nickname: nickname,
        country: country,
        province: province,
        description: description,
        createdBy: createdBy,
        photoUrl: photoUrl,
        coverPhotoUrl: coverPhotoUrl,
        familyCode: familyCode,
        inviteCode: inviteCode,
        settings: settings,
      );

      final family = await _createFamilyUseCase(params);

      state = state.copyWith(
        status: FamilySetupStatus.success,
        family: family,
        clearError: true,
      );
    } on CreateFamilyException catch (error) {
      state = state.copyWith(
        status: FamilySetupStatus.error,
        errorMessage: error.message,
      );
    } catch (_) {
      state = state.copyWith(
        status: FamilySetupStatus.error,
        errorMessage:
            'Não foi possível criar a família. '
            'Verifique a sua ligação à internet e tente novamente.',
      );
    }
  }

  void reset() {
    state = const FamilySetupState();
  }

  void clearError() {
    if (!state.hasError) {
      return;
    }

    state = state.copyWith(
      status: FamilySetupStatus.initial,
      clearError: true,
    );
  }

  String _generateFamilyId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(999999);

    return 'family_${timestamp}_$random';
  }
}