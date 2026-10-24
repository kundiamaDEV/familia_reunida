import '../entities/family_member_entity.dart';
import '../repositories/family_repository.dart';

class GetFamilyMemberUseCase {
  const GetFamilyMemberUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyMemberEntity> call(GetFamilyMemberParams params) async {
    final familyId = params.familyId.trim();
    final memberId = params.memberId.trim();

    if (familyId.isEmpty) {
      throw const GetFamilyMemberException(
        'O identificador da família é obrigatório.',
      );
    }

    if (memberId.isEmpty) {
      throw const GetFamilyMemberException(
        'O identificador do membro é obrigatório.',
      );
    }

    final member = await _repository.getMemberById(familyId, memberId);

    if (member == null) {
      throw const GetFamilyMemberException(
        'O membro da família não foi encontrado.',
      );
    }

    return member;
  }
}

class GetFamilyMemberParams {
  const GetFamilyMemberParams({required this.familyId, required this.memberId});

  final String familyId;
  final String memberId;
}

class GetFamilyMemberException implements Exception {
  const GetFamilyMemberException(this.message);

  final String message;

  @override
  String toString() => message;
}
