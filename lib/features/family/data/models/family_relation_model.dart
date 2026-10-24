import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/family_relation_entity.dart';

class FamilyRelationModel extends FamilyRelationEntity {
  const FamilyRelationModel({
    required super.id,
    required super.familyId,
    required super.personAId,
    required super.personBId,
    required super.type,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
    super.startDate,
    super.endDate,
    super.notes,
    super.isBiological,
    super.isPrimary,
  });

  factory FamilyRelationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return FamilyRelationModel(
      id: document.id,
      familyId: data['familyId'] as String? ?? '',
      personAId: data['personAId'] as String? ?? '',
      personBId: data['personBId'] as String? ?? '',
      type: _relationTypeFromString(data['type']),
      status: _relationStatusFromString(data['status']),
      startDate: _dateFromFirestore(data['startDate']),
      endDate: _dateFromFirestore(data['endDate']),
      notes: data['notes'] as String?,
      isBiological: data['isBiological'] as bool? ?? false,
      isPrimary: data['isPrimary'] as bool? ?? false,
      createdAt:
          _dateFromFirestore(data['createdAt']) ?? DateTime.now(),
      updatedAt:
          _dateFromFirestore(data['updatedAt']) ?? DateTime.now(),
      createdBy: data['createdBy'] as String? ?? '',
    );
  }

  factory FamilyRelationModel.fromMap(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return FamilyRelationModel(
      id: id,
      familyId: data['familyId'] as String? ?? '',
      personAId: data['personAId'] as String? ?? '',
      personBId: data['personBId'] as String? ?? '',
      type: _relationTypeFromString(data['type']),
      status: _relationStatusFromString(data['status']),
      startDate: _dateFromFirestore(data['startDate']),
      endDate: _dateFromFirestore(data['endDate']),
      notes: data['notes'] as String?,
      isBiological: data['isBiological'] as bool? ?? false,
      isPrimary: data['isPrimary'] as bool? ?? false,
      createdAt:
          _dateFromFirestore(data['createdAt']) ?? DateTime.now(),
      updatedAt:
          _dateFromFirestore(data['updatedAt']) ?? DateTime.now(),
      createdBy: data['createdBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'personAId': personAId,
      'personBId': personBId,
      'type': type.name,
      'status': status.name,
      'startDate': _dateToFirestore(startDate),
      'endDate': _dateToFirestore(endDate),
      'notes': notes,
      'isBiological': isBiological,
      'isPrimary': isPrimary,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
    };
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  FamilyRelationModel copyWithModel({
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
    final entity = copyWith(
      id: id,
      familyId: familyId,
      personAId: personAId,
      personBId: personBId,
      type: type,
      status: status,
      startDate: startDate,
      clearStartDate: clearStartDate,
      endDate: endDate,
      clearEndDate: clearEndDate,
      notes: notes,
      clearNotes: clearNotes,
      isBiological: isBiological,
      isPrimary: isPrimary,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
    );

    return FamilyRelationModel(
      id: entity.id,
      familyId: entity.familyId,
      personAId: entity.personAId,
      personBId: entity.personBId,
      type: entity.type,
      status: entity.status,
      startDate: entity.startDate,
      endDate: entity.endDate,
      notes: entity.notes,
      isBiological: entity.isBiological,
      isPrimary: entity.isPrimary,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
    );
  }

  static DateTime? _dateFromFirestore(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  static dynamic _dateToFirestore(DateTime? value) {
    if (value == null) {
      return null;
    }

    return Timestamp.fromDate(value);
  }

  static FamilyRelationType _relationTypeFromString(dynamic value) {
    if (value is! String) {
      return FamilyRelationType.other;
    }

    return FamilyRelationType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => FamilyRelationType.other,
    );
  }

  static FamilyRelationStatus _relationStatusFromString(dynamic value) {
    if (value is! String) {
      return FamilyRelationStatus.confirmed;
    }

    return FamilyRelationStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => FamilyRelationStatus.confirmed,
    );
  }
}