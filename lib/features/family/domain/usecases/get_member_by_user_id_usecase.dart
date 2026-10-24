import '../entities/family_member_entity.dart';
import '../repositories/family_repository.dart';

class GetMemberByUserIdUseCase {
  const GetMemberByUserIdUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyMemberEntity?> call(GetMemberByUserIdParams params) async {
    final familyId = params.familyId.trim();
    final userId = params.userId.trim();

    if (familyId.isEmpty) {
      throw const GetMemberByUserIdException(
        'O identificador da família é obrigatório.',
      );
    }

    if (userId.isEmpty) {
      throw const GetMemberByUserIdException(
        'O identificador do utilizador é obrigatório.',
      );
    }

    return _repository.getMemberByUserId(familyId, userId);
  }
}

class GetMemberByUserIdParams {
  const GetMemberByUserIdParams({required this.familyId, required this.userId});

  final String familyId;
  final String userId;
}

class GetMemberByUserIdException implements Exception {
  const GetMemberByUserIdException(this.message);

  final String message;

  @override
  String toString() => message;
}
