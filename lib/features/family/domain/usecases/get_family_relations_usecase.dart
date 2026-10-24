import '../entities/family_relation_entity.dart';
import '../repositories/family_repository.dart';

class GetFamilyRelationsUseCase {
  const GetFamilyRelationsUseCase(this._repository);

  final FamilyRepository _repository;

  Future<List<FamilyRelationEntity>> call(
    GetFamilyRelationsParams params,
  ) async {
    final familyId = params.familyId.trim();

    if (familyId.isEmpty) {
      throw const GetFamilyRelationsException(
        'O identificador da família é obrigatório.',
      );
    }

    final relations = await _repository.getFamilyRelations(familyId);

    if (params.includeRemoved) {
      return relations;
    }

    return relations
        .where(
          (relation) =>
              relation.status != FamilyRelationStatus.removed,
        )
        .toList(growable: false);
  }
}

class GetFamilyRelationsParams {
  const GetFamilyRelationsParams({
    required this.familyId,
    this.includeRemoved = false,
  });

  final String familyId;

  /// Define se relações removidas também devem ser devolvidas.
  final bool includeRemoved;
}

class GetFamilyRelationsException implements Exception {
  const GetFamilyRelationsException(this.message);

  final String message;

  @override
  String toString() => message;
}