import '../entities/family_relation_entity.dart';
import '../repositories/family_repository.dart';

class DeleteFamilyRelationUseCase {
  const DeleteFamilyRelationUseCase(this._repository);

  final FamilyRepository _repository;

  Future<void> call(DeleteFamilyRelationParams params) async {
    final familyId = params.familyId.trim();
    final relationId = params.relationId.trim();

    if (familyId.isEmpty) {
      throw const DeleteFamilyRelationException(
        'O identificador da família é obrigatório.',
      );
    }

    if (relationId.isEmpty) {
      throw const DeleteFamilyRelationException(
        'O identificador da relação é obrigatório.',
      );
    }

    final relations = await _repository.getFamilyRelations(familyId);

    FamilyRelationEntity? relation;

    for (final item in relations) {
      if (item.id == relationId) {
        relation = item;
        break;
      }
    }

    if (relation == null) {
      throw const DeleteFamilyRelationException(
        'A relação familiar não foi encontrada.',
      );
    }

    if (relation.familyId != familyId) {
      throw const DeleteFamilyRelationException(
        'A relação não pertence à família indicada.',
      );
    }

    if (relation.status == FamilyRelationStatus.removed) {
      throw const DeleteFamilyRelationException(
        'A relação familiar já foi removida.',
      );
    }

    await _repository.deleteFamilyRelation(
      familyId,
      relationId,
    );
  }
}

class DeleteFamilyRelationParams {
  const DeleteFamilyRelationParams({
    required this.familyId,
    required this.relationId,
  });

  final String familyId;
  final String relationId;
}

class DeleteFamilyRelationException implements Exception {
  const DeleteFamilyRelationException(this.message);

  final String message;

  @override
  String toString() => message;
}