import '../entities/family_entity.dart';
import '../repositories/family_repository.dart';

class GetFamilyByIdUseCase {
  const GetFamilyByIdUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyEntity?> call(String familyId) {
    return _repository.getFamilyById(familyId);
  }
}