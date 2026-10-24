import '../entities/family_member_entity.dart';
import '../entities/family_relation_entity.dart';
import '../repositories/family_repository.dart';

class CreateFamilyRelationUseCase {
  const CreateFamilyRelationUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyRelationEntity> call(
    CreateFamilyRelationParams params,
  ) async {
    _validateParams(params);

    final familyId = params.relation.familyId.trim();
    final personAId = params.relation.personAId.trim();
    final personBId = params.relation.personBId.trim();

    if (personAId == personBId) {
      throw const CreateFamilyRelationException(
        'Uma pessoa não pode possuir uma relação consigo mesma.',
      );
    }

    final personA = await _repository.getMemberById(
      familyId,
      personAId,
    );

    if (personA == null) {
      throw const CreateFamilyRelationException(
        'O primeiro membro da relação não foi encontrado.',
      );
    }

    final personB = await _repository.getMemberById(
      familyId,
      personBId,
    );

    if (personB == null) {
      throw const CreateFamilyRelationException(
        'O segundo membro da relação não foi encontrado.',
      );
    }

    _validateMembers(personA, personB);

    final existingRelations = await _repository.getFamilyRelations(
      familyId,
    );

    _validateDuplicateRelation(
      relation: params.relation,
      existingRelations: existingRelations,
    );

    _validateRelationType(params.relation);

    final now = DateTime.now();

    final relation = params.relation.copyWith(
      familyId: familyId,
      personAId: personAId,
      personBId: personBId,
      createdAt: now,
      updatedAt: now,
      createdBy: params.createdBy.trim(),
    );

    return _repository.createFamilyRelation(relation);
  }

  void _validateParams(CreateFamilyRelationParams params) {
    final relation = params.relation;

    if (relation.id.trim().isEmpty) {
      throw const CreateFamilyRelationException(
        'O identificador da relação é obrigatório.',
      );
    }

    if (relation.familyId.trim().isEmpty) {
      throw const CreateFamilyRelationException(
        'O identificador da família é obrigatório.',
      );
    }

    if (relation.personAId.trim().isEmpty) {
      throw const CreateFamilyRelationException(
        'O identificador do primeiro membro é obrigatório.',
      );
    }

    if (relation.personBId.trim().isEmpty) {
      throw const CreateFamilyRelationException(
        'O identificador do segundo membro é obrigatório.',
      );
    }

    if (params.createdBy.trim().isEmpty) {
      throw const CreateFamilyRelationException(
        'O utilizador responsável pela criação é obrigatório.',
      );
    }

    if (relation.personAId.trim() == relation.personBId.trim()) {
      throw const CreateFamilyRelationException(
        'Uma pessoa não pode possuir uma relação consigo mesma.',
      );
    }

    if (relation.notes != null && relation.notes!.trim().length > 1000) {
      throw const CreateFamilyRelationException(
        'As observações da relação devem possuir no máximo 1000 caracteres.',
      );
    }

    if (relation.startDate != null &&
        relation.endDate != null &&
        relation.endDate!.isBefore(relation.startDate!)) {
      throw const CreateFamilyRelationException(
        'A data de fim não pode ser anterior à data de início.',
      );
    }
  }

  void _validateMembers(
    FamilyMemberEntity personA,
    FamilyMemberEntity personB,
  ) {
    if (personA.familyId.trim() != personB.familyId.trim()) {
      throw const CreateFamilyRelationException(
        'Os membros devem pertencer à mesma família.',
      );
    }

    if (personA.status == FamilyMemberStatus.removed) {
      throw const CreateFamilyRelationException(
        'O primeiro membro foi removido da família.',
      );
    }

    if (personB.status == FamilyMemberStatus.removed) {
      throw const CreateFamilyRelationException(
        'O segundo membro foi removido da família.',
      );
    }
  }

  void _validateDuplicateRelation({
    required FamilyRelationEntity relation,
    required List<FamilyRelationEntity> existingRelations,
  }) {
    final personAId = relation.personAId.trim();
    final personBId = relation.personBId.trim();

    for (final existing in existingRelations) {
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
        throw const CreateFamilyRelationException(
          'Esta relação já existe para os membros selecionados.',
        );
      }
    }
  }

  void _validateRelationType(FamilyRelationEntity relation) {
    if (relation.type == FamilyRelationType.parentChild) {
      if (relation.personAId == relation.personBId) {
        throw const CreateFamilyRelationException(
          'Uma relação parental não pode ligar uma pessoa a si mesma.',
        );
      }
    }

    if (relation.isBiological &&
        relation.type != FamilyRelationType.parentChild) {
      throw const CreateFamilyRelationException(
        'A propriedade de relação biológica só pode ser utilizada numa relação pai-filho.',
      );
    }

    if (relation.type == FamilyRelationType.spouse &&
        relation.isBiological) {
      throw const CreateFamilyRelationException(
        'Uma relação conjugal não pode ser marcada como biológica.',
      );
    }
  }
}

class CreateFamilyRelationParams {
  const CreateFamilyRelationParams({
    required this.relation,
    required this.createdBy,
  });

  final FamilyRelationEntity relation;
  final String createdBy;
}

class CreateFamilyRelationException implements Exception {
  const CreateFamilyRelationException(this.message);

  final String message;

  @override
  String toString() => message;
}