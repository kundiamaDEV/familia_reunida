import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/family_member_entity.dart';

class FamilyMemberModel extends FamilyMemberEntity {
  const FamilyMemberModel({
    required super.id,
    required super.familyId,
    required super.firstName,
    required super.lastName,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
    required super.role,
    required super.status,
    super.userId,
    super.middleNames,
    super.preferredName,
    super.gender,
    super.birthDate,
    super.birthPlace,
    super.deathDate,
    super.deathPlace,
    super.biography,
    super.occupation,
    super.phoneNumber,
    super.email,
    super.photoUrl,
    super.coverPhotoUrl,
    super.isFamilyRoot,
    super.isProfilePrivate,
    super.isVerified,
  });

  factory FamilyMemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return FamilyMemberModel(
      id: document.id,
      familyId: data['familyId'] as String? ?? '',
      userId: data['userId'] as String?,
      firstName: data['firstName'] as String? ?? '',
      middleNames: data['middleNames'] as String?,
      lastName: data['lastName'] as String? ?? '',
      preferredName: data['preferredName'] as String?,
      gender: _genderFromString(data['gender']),
      birthDate: _dateFromFirestore(data['birthDate']),
      birthPlace: data['birthPlace'] as String?,
      deathDate: _dateFromFirestore(data['deathDate']),
      deathPlace: data['deathPlace'] as String?,
      biography: data['biography'] as String?,
      occupation: data['occupation'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      email: data['email'] as String?,
      photoUrl: data['photoUrl'] as String?,
      coverPhotoUrl: data['coverPhotoUrl'] as String?,
      role: _roleFromString(data['role']),
      status: _statusFromString(data['status']),
      isFamilyRoot: data['isFamilyRoot'] as bool? ?? false,
      isProfilePrivate: data['isProfilePrivate'] as bool? ?? true,
      isVerified: data['isVerified'] as bool? ?? false,
      createdAt: _dateFromFirestore(data['createdAt']) ?? DateTime.now(),
      updatedAt: _dateFromFirestore(data['updatedAt']) ?? DateTime.now(),
      createdBy: data['createdBy'] as String? ?? '',
    );
  }

  factory FamilyMemberModel.fromMap(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return FamilyMemberModel(
      id: id,
      familyId: data['familyId'] as String? ?? '',
      userId: data['userId'] as String?,
      firstName: data['firstName'] as String? ?? '',
      middleNames: data['middleNames'] as String?,
      lastName: data['lastName'] as String? ?? '',
      preferredName: data['preferredName'] as String?,
      gender: _genderFromString(data['gender']),
      birthDate: _dateFromFirestore(data['birthDate']),
      birthPlace: data['birthPlace'] as String?,
      deathDate: _dateFromFirestore(data['deathDate']),
      deathPlace: data['deathPlace'] as String?,
      biography: data['biography'] as String?,
      occupation: data['occupation'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      email: data['email'] as String?,
      photoUrl: data['photoUrl'] as String?,
      coverPhotoUrl: data['coverPhotoUrl'] as String?,
      role: _roleFromString(data['role']),
      status: _statusFromString(data['status']),
      isFamilyRoot: data['isFamilyRoot'] as bool? ?? false,
      isProfilePrivate: data['isProfilePrivate'] as bool? ?? true,
      isVerified: data['isVerified'] as bool? ?? false,
      createdAt: _dateFromFirestore(data['createdAt']) ?? DateTime.now(),
      updatedAt: _dateFromFirestore(data['updatedAt']) ?? DateTime.now(),
      createdBy: data['createdBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'userId': userId,
      'firstName': firstName,
      'middleNames': middleNames,
      'lastName': lastName,
      'preferredName': preferredName,
      'gender': gender.name,
      'birthDate': _dateToFirestore(birthDate),
      'birthPlace': birthPlace,
      'deathDate': _dateToFirestore(deathDate),
      'deathPlace': deathPlace,
      'biography': biography,
      'occupation': occupation,
      'phoneNumber': phoneNumber,
      'email': email,
      'photoUrl': photoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'role': role.name,
      'status': status.name,
      'isFamilyRoot': isFamilyRoot,
      'isProfilePrivate': isProfilePrivate,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
    };
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  FamilyMemberModel copyWithModel({
    String? id,
    String? familyId,
    String? userId,
    bool clearUserId = false,
    String? firstName,
    String? middleNames,
    bool clearMiddleNames = false,
    String? lastName,
    String? preferredName,
    bool clearPreferredName = false,
    Gender? gender,
    DateTime? birthDate,
    bool clearBirthDate = false,
    String? birthPlace,
    bool clearBirthPlace = false,
    DateTime? deathDate,
    bool clearDeathDate = false,
    String? deathPlace,
    bool clearDeathPlace = false,
    String? biography,
    bool clearBiography = false,
    String? occupation,
    bool clearOccupation = false,
    String? phoneNumber,
    bool clearPhoneNumber = false,
    String? email,
    bool clearEmail = false,
    String? photoUrl,
    bool clearPhotoUrl = false,
    String? coverPhotoUrl,
    bool clearCoverPhotoUrl = false,
    FamilyMemberRole? role,
    FamilyMemberStatus? status,
    bool? isFamilyRoot,
    bool? isProfilePrivate,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    final entity = copyWith(
      id: id,
      familyId: familyId,
      userId: userId,
      clearUserId: clearUserId,
      firstName: firstName,
      middleNames: middleNames,
      clearMiddleNames: clearMiddleNames,
      lastName: lastName,
      preferredName: preferredName,
      clearPreferredName: clearPreferredName,
      gender: gender,
      birthDate: birthDate,
      clearBirthDate: clearBirthDate,
      birthPlace: birthPlace,
      clearBirthPlace: clearBirthPlace,
      deathDate: deathDate,
      clearDeathDate: clearDeathDate,
      deathPlace: deathPlace,
      clearDeathPlace: clearDeathPlace,
      biography: biography,
      clearBiography: clearBiography,
      occupation: occupation,
      clearOccupation: clearOccupation,
      phoneNumber: phoneNumber,
      clearPhoneNumber: clearPhoneNumber,
      email: email,
      clearEmail: clearEmail,
      photoUrl: photoUrl,
      clearPhotoUrl: clearPhotoUrl,
      coverPhotoUrl: coverPhotoUrl,
      clearCoverPhotoUrl: clearCoverPhotoUrl,
      role: role,
      status: status,
      isFamilyRoot: isFamilyRoot,
      isProfilePrivate: isProfilePrivate,
      isVerified: isVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
    );

    return FamilyMemberModel(
      id: entity.id,
      familyId: entity.familyId,
      userId: entity.userId,
      firstName: entity.firstName,
      middleNames: entity.middleNames,
      lastName: entity.lastName,
      preferredName: entity.preferredName,
      gender: entity.gender,
      birthDate: entity.birthDate,
      birthPlace: entity.birthPlace,
      deathDate: entity.deathDate,
      deathPlace: entity.deathPlace,
      biography: entity.biography,
      occupation: entity.occupation,
      phoneNumber: entity.phoneNumber,
      email: entity.email,
      photoUrl: entity.photoUrl,
      coverPhotoUrl: entity.coverPhotoUrl,
      role: entity.role,
      status: entity.status,
      isFamilyRoot: entity.isFamilyRoot,
      isProfilePrivate: entity.isProfilePrivate,
      isVerified: entity.isVerified,
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

  static Gender _genderFromString(dynamic value) {
    if (value is! String) {
      return Gender.notInformed;
    }

    return Gender.values.firstWhere(
      (gender) => gender.name == value,
      orElse: () => Gender.notInformed,
    );
  }

  static FamilyMemberRole _roleFromString(dynamic value) {
    if (value is! String) {
      return FamilyMemberRole.member;
    }

    return FamilyMemberRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => FamilyMemberRole.member,
    );
  }

  static FamilyMemberStatus _statusFromString(dynamic value) {
    if (value is! String) {
      return FamilyMemberStatus.active;
    }

    return FamilyMemberStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => FamilyMemberStatus.active,
    );
  }
}
