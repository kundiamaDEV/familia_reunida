import '../repositories/family_repository.dart';

class CancelFamilyInviteUseCase {
  const CancelFamilyInviteUseCase(this._repository);

  final FamilyRepository _repository;

  Future<void> call(String code) {
    return _repository.cancelInvite(code);
  }
}