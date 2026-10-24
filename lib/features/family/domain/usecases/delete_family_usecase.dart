import '../repositories/family_repository.dart';

class DeleteFamilyUseCase {
  const DeleteFamilyUseCase(this._repository);

  final FamilyRepository _repository;

  Future<void> call(String familyId) {
    return _repository.deleteFamily(familyId);
  }
}