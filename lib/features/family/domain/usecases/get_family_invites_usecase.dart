import '../entities/family_invite_entity.dart';
import '../repositories/family_repository.dart';

class GetFamilyInvitesUseCase {
  const GetFamilyInvitesUseCase(this._repository);

  final FamilyRepository _repository;

  Future<List<FamilyInviteEntity>> call(String familyId) {
    return _repository.getFamilyInvites(familyId);
  }
}