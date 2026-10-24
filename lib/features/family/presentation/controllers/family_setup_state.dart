import 'package:familia_reunida/features/family/domain/entities/family_entity.dart';

enum FamilySetupStatus {
  initial,
  loading,
  success,
  error,
}

class FamilySetupState {
  const FamilySetupState({
    this.status = FamilySetupStatus.initial,
    this.family,
    this.errorMessage,
  });

  final FamilySetupStatus status;
  final FamilyEntity? family;
  final String? errorMessage;

  bool get isLoading => status == FamilySetupStatus.loading;

  bool get isSuccess => status == FamilySetupStatus.success;

  bool get hasError => status == FamilySetupStatus.error;

  FamilySetupState copyWith({
    FamilySetupStatus? status,
    FamilyEntity? family,
    String? errorMessage,
    bool clearFamily = false,
    bool clearError = false,
  }) {
    return FamilySetupState(
      status: status ?? this.status,
      family: clearFamily ? null : family ?? this.family,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}