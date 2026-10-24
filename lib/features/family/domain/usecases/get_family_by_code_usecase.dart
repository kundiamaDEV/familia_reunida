import '../entities/family_entity.dart';
import '../repositories/family_repository.dart';

class GetFamilyByCodeUseCase {
  const GetFamilyByCodeUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyEntity?> call(String familyCode) {
    return _repository.getFamilyByCode(familyCode);
  }
}