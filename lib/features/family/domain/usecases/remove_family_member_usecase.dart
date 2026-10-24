import '../repositories/family_repository.dart';

class RemoveFamilyMemberUseCase {
  const RemoveFamilyMemberUseCase(this._repository);

  final FamilyRepository _repository;

  Future<void> call({
    required String familyId,
    required String memberId,
  }) {
    return _repository.removeFamilyMember(familyId, memberId);
  }
}