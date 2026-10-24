import '../entities/family_member_entity.dart';
import '../repositories/family_repository.dart';

class GetFamilyMembersUseCase {
  const GetFamilyMembersUseCase(this._repository);

  final FamilyRepository _repository;

  Future<List<FamilyMemberEntity>> call(GetFamilyMembersParams params) async {
    final familyId = params.familyId.trim();

    if (familyId.isEmpty) {
      throw const GetFamilyMembersException(
        'O identificador da família é obrigatório.',
      );
    }

    final members = await _repository.getFamilyMembers(familyId);

    return List<FamilyMemberEntity>.unmodifiable(members);
  }
}

class GetFamilyMembersParams {
  const GetFamilyMembersParams({required this.familyId});

  final String familyId;
}

class GetFamilyMembersException implements Exception {
  const GetFamilyMembersException(this.message);

  final String message;

  @override
  String toString() => message;
}
