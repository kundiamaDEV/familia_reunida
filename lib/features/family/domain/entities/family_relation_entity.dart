enum FamilyRelationType {
  parentChild,
  spouse,
  sibling,
  adoptiveParentChild,
  guardianDependent,
  stepParentChild,
  other,
}

enum FamilyRelationStatus { confirmed, pending, disputed, removed }

class FamilyRelationEntity {
  const FamilyRelationEntity({
    required this.id,
    required this.familyId,
    required this.personAId,
    required this.personBId,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.startDate,
    this.endDate,
    this.notes,
    this.isBiological = false,
    this.isPrimary = false,
  });

  /// Identificador único da relação.
  final String id;

  /// Família à qual esta relação pertence.
  final String familyId;

  /// Primeiro membro envolvido na relação.
  final String personAId;

  /// Segundo membro envolvido na relação.
  final String personBId;

  /// Tipo da relação.
  final FamilyRelationType type;

  /// Estado atual da relação.
  final FamilyRelationStatus status;

  /// Data de início da relação, quando aplicável.
  ///
  /// Pode representar:
  /// - data do casamento;
  /// - início da tutela;
  /// - início da convivência;
  /// - data de adoção.
  final DateTime? startDate;

  /// Data de fim da relação, quando aplicável.
  ///
  /// Pode representar:
  /// - divórcio;
  /// - fim da tutela;
  /// - fim da convivência;
  /// - remoção administrativa.
  final DateTime? endDate;

  /// Observações adicionais.
  final String? notes;

  /// Indica se a relação de parentalidade é biológica.
  ///
  /// Só deve ser considerada quando o tipo for:
  /// `parentChild`.
  final bool isBiological;

  /// Indica se esta é a relação principal usada para organizar
  /// a posição da pessoa na árvore.
  final bool isPrimary;

  /// Data de criação do registo.
  final DateTime createdAt;

  /// Data da última atualização.
  final DateTime updatedAt;

  /// Utilizador responsável pela criação da relação.
  final String createdBy;

  bool get isConfirmed => status == FamilyRelationStatus.confirmed;

  bool get isPending => status == FamilyRelationStatus.pending;

  bool get isRemoved => status == FamilyRelationStatus.removed;

  bool get isActive =>
      !isRemoved && (endDate == null || endDate!.isAfter(DateTime.now()));

  bool get isParentChild =>
      type == FamilyRelationType.parentChild ||
      type == FamilyRelationType.adoptiveParentChild ||
      type == FamilyRelationType.stepParentChild;

  bool get isSpouse => type == FamilyRelationType.spouse;

  bool get isSibling => type == FamilyRelationType.sibling;

  bool get isGuardian => type == FamilyRelationType.guardianDependent;

  bool involvesMember(String memberId) {
    return personAId == memberId || personBId == memberId;
  }

  String? otherMemberId(String memberId) {
    if (personAId == memberId) {
      return personBId;
    }

    if (personBId == memberId) {
      return personAId;
    }

    return null;
  }

  FamilyRelationEntity copyWith({
    String? id,
    String? familyId,
    String? personAId,
    String? personBId,
    FamilyRelationType? type,
    FamilyRelationStatus? status,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? notes,
    bool clearNotes = false,
    bool? isBiological,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return FamilyRelationEntity(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      personAId: personAId ?? this.personAId,
      personBId: personBId ?? this.personBId,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      notes: clearNotes ? null : notes ?? this.notes,
      isBiological: isBiological ?? this.isBiological,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FamilyRelationEntity &&
        other.id == id &&
        other.familyId == familyId &&
        other.personAId == personAId &&
        other.personBId == personBId &&
        other.type == type &&
        other.status == status &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.notes == notes &&
        other.isBiological == isBiological &&
        other.isPrimary == isPrimary &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      familyId,
      personAId,
      personBId,
      type,
      status,
      startDate,
      endDate,
      notes,
      isBiological,
      isPrimary,
      createdAt,
      updatedAt,
      createdBy,
    );
  }

  @override
  String toString() {
    return 'FamilyRelationEntity('
        'id: $id, '
        'familyId: $familyId, '
        'personAId: $personAId, '
        'personBId: $personBId, '
        'type: $type, '
        'status: $status'
        ')';
  }
}
