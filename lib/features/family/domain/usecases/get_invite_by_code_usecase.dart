import '../entities/family_invite_entity.dart';
import '../repositories/family_repository.dart';

class GetInviteByCodeUseCase {
  const GetInviteByCodeUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyInviteEntity?> call(String code) {
    return _repository.getInviteByCode(code);
  }
}