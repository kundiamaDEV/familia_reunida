import '../entities/family_relation_entity.dart';
import '../repositories/family_repository.dart';
import '../entities/family_member_entity.dart';


class UpdateFamilyRelationUseCase {
  const UpdateFamilyRelationUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyRelationEntity> call(
    UpdateFamilyRelationParams params,
  ) async {
    _validateParams(params);

    final relation = params.relation;

    final familyId = relation.familyId.trim();
    final relationId = relation.id.trim();

    final existingRelations = await _repository.getFamilyRelations(
      familyId,
    );

    FamilyRelationEntity? existingRelation;

    for (final item in existingRelations) {
      if (item.id == relationId) {
        existingRelation = item;
        break;
      }
    }

    if (existingRelation == null) {
      throw const UpdateFamilyRelationException(
        'A relação familiar não foi encontrada.',
      );
    }

    if (existingRelation.status == FamilyRelationStatus.removed) {
      throw const UpdateFamilyRelationException(
        'Uma relação removida não pode ser actualizada.',
      );
    }

    if (existingRelation.familyId != familyId) {
      throw const UpdateFamilyRelationException(
        'A relação não pertence à família indicada.',
      );
    }

    final personAId = relation.personAId.trim();
    final personBId = relation.personBId.trim();

    if (personAId == personBId) {
      throw const UpdateFamilyRelationException(
        'Uma pessoa não pode possuir uma relação consigo mesma.',
      );
    }

    final personA = await _repository.getMemberById(
      familyId,
      personAId,
    );

    if (personA == null) {
      throw const UpdateFamilyRelationException(
        'O primeiro membro da relação não foi encontrado.',
      );
    }

    final personB = await _repository.getMemberById(
      familyId,
      personBId,
    );

    if (personB == null) {
      throw const UpdateFamilyRelationException(
        'O segundo membro da relação não foi encontrado.',
      );
    }

    _validateMembers(personA.status, personB.status);

    _validateDates(relation);

    _validateRelationType(relation);

    _validateDuplicateRelation(
      relation: relation,
      existingRelations: existingRelations,
      currentRelationId: relationId,
    );

    final updatedRelation = relation.copyWith(
      id: existingRelation.id,
      familyId: existingRelation.familyId,
      createdAt: existingRelation.createdAt,
      createdBy: existingRelation.createdBy,
      updatedAt: DateTime.now(),
    );

    return _repository.updateFamilyRelation(updatedRelation);
  }

  void _validateParams(UpdateFamilyRelationParams params) {
    final relation = params.relation;

    if (relation.id.trim().isEmpty) {
      throw const UpdateFamilyRelationException(
        'O identificador da relação é obrigatório.',
      );
    }

    if (relation.familyId.trim().isEmpty) {
      throw const UpdateFamilyRelationException(
        'O identificador da família é obrigatório.',
      );
    }

    if (relation.personAId.trim().isEmpty) {
      throw const UpdateFamilyRelationException(
        'O identificador do primeiro membro é obrigatório.',
      );
    }

    if (relation.personBId.trim().isEmpty) {
      throw const UpdateFamilyRelationException(
        'O identificador do segundo membro é obrigatório.',
      );
    }

    if (relation.notes != null &&
        relation.notes!.trim().length > 1000) {
      throw const UpdateFamilyRelationException(
        'As observações da relação devem possuir no máximo 1000 caracteres.',
      );
    }
  }

  void _validateMembers(
    FamilyMemberStatus personAStatus,
    FamilyMemberStatus personBStatus,
  ) {
    if (personAStatus == FamilyMemberStatus.removed) {
      throw const UpdateFamilyRelationException(
        'O primeiro membro foi removido da família.',
      );
    }

    if (personBStatus == FamilyMemberStatus.removed) {
      throw const UpdateFamilyRelationException(
        'O segundo membro foi removido da família.',
      );
    }
  }

  void _validateDates(FamilyRelationEntity relation) {
    if (relation.startDate != null &&
        relation.endDate != null &&
        relation.endDate!.isBefore(relation.startDate!)) {
      throw const UpdateFamilyRelationException(
        'A data de fim não pode ser anterior à data de início.',
      );
    }
  }

  void _validateRelationType(FamilyRelationEntity relation) {
    if (relation.isBiological &&
        relation.type != FamilyRelationType.parentChild) {
      throw const UpdateFamilyRelationException(
        'A relação biológica só pode ser utilizada numa relação pai-filho.',
      );
    }

    if (relation.type == FamilyRelationType.spouse &&
        relation.isBiological) {
      throw const UpdateFamilyRelationException(
        'Uma relação conjugal não pode ser marcada como biológica.',
      );
    }
  }

  void _validateDuplicateRelation({
    required FamilyRelationEntity relation,
    required List<FamilyRelationEntity> existingRelations,
    required String currentRelationId,
  }) {
    final personAId = relation.personAId.trim();
    final personBId = relation.personBId.trim();

    for (final existing in existingRelations) {
      if (existing.id == currentRelationId) {
        continue;
      }

      if (existing.status == FamilyRelationStatus.removed) {
        continue;
      }

      final sameMembers =
          (existing.personAId == personAId &&
                  existing.personBId == personBId) ||
              (existing.personAId == personBId &&
                  existing.personBId == personAId);

      if (!sameMembers) {
        continue;
      }

      if (existing.type == relation.type) {
        throw const UpdateFamilyRelationException(
          'Esta relação já existe para os membros seleccionados.',
        );
      }
    }
  }
}

class UpdateFamilyRelationParams {
  const UpdateFamilyRelationParams({
    required this.relation,
  });

  final FamilyRelationEntity relation;
}

class UpdateFamilyRelationException implements Exception {
  const UpdateFamilyRelationException(this.message);

  final String message;

  @override
  String toString() => message;
}