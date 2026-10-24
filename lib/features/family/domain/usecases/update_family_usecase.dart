import '../entities/family_entity.dart';
import '../repositories/family_repository.dart';

class UpdateFamilyUseCase {
  const UpdateFamilyUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyEntity> call(FamilyEntity family) {
    return _repository.updateFamily(family);
  }
}