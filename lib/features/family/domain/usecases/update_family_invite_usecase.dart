import '../entities/family_invite_entity.dart';
import '../repositories/family_repository.dart';

class UpdateFamilyInviteUseCase {
  const UpdateFamilyInviteUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyInviteEntity> call(FamilyInviteEntity invite) {
    return _repository.updateFamilyInvite(invite);
  }
}