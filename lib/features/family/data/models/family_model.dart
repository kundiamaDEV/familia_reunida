import '../../domain/entities/family_entity.dart';

class FamilyModel extends FamilyEntity {
  const FamilyModel({
    required super.id,
    required super.officialName,
    required super.shortName,
    required super.country,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
    required super.familyCode,
    required super.inviteCode,
    required super.status,
    super.nickname,
    super.province,
    super.description,
    super.photoUrl,
    super.coverPhotoUrl,
    super.membersCount = 0,
    super.treeVersion = 1,
    super.settings = const FamilySettings(),
  });

  factory FamilyModel.fromEntity(FamilyEntity entity) {
    return FamilyModel(
      id: entity.id,
      officialName: entity.officialName,
      shortName: entity.shortName,
      nickname: entity.nickname,
      country: entity.country,
      province: entity.province,
      description: entity.description,
      photoUrl: entity.photoUrl,
      coverPhotoUrl: entity.coverPhotoUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
      familyCode: entity.familyCode,
      inviteCode: entity.inviteCode,
      membersCount: entity.membersCount,
      treeVersion: entity.treeVersion,
      settings: entity.settings,
      status: entity.status,
    );
  }

  factory FamilyModel.fromMap(Map<String, dynamic> map) {
    return FamilyModel(
      id: _readString(map['id']),
      officialName: _readString(map['officialName']),
      shortName: _readString(map['shortName']),
      nickname: _readNullableString(map['nickname']),
      country: _readString(map['country']),
      province: _readNullableString(map['province']),
      description: _readNullableString(map['description']),
      photoUrl: _readNullableString(map['photoUrl']),
      coverPhotoUrl: _readNullableString(map['coverPhotoUrl']),
      createdAt: _readDateTime(map['createdAt']),
      updatedAt: _readDateTime(map['updatedAt']),
      createdBy: _readString(map['createdBy']),
      familyCode: _readString(map['familyCode']),
      inviteCode: _readString(map['inviteCode']),
      membersCount: _readInt(map['membersCount']),
      treeVersion: _readInt(map['treeVersion'], defaultValue: 1),
      settings: _readSettings(map['settings']),
      status: _readFamilyStatus(map['status']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'officialName': officialName,
      'shortName': shortName,
      'nickname': nickname,
      'country': country,
      'province': province,
      'description': description,
      'photoUrl': photoUrl,
      'coverPhotoUrl': coverPhotoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'familyCode': familyCode,
      'inviteCode': inviteCode,
      'membersCount': membersCount,
      'treeVersion': treeVersion,
      'settings': _settingsToMap(settings),
      'status': status.name,
    };
  }

  FamilyModel copyWithModel({
    String? id,
    String? officialName,
    String? shortName,
    String? nickname,
    String? country,
    String? province,
    String? description,
    String? photoUrl,
    String? coverPhotoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? familyCode,
    String? inviteCode,
    int? membersCount,
    int? treeVersion,
    FamilySettings? settings,
    FamilyStatus? status,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      officialName: officialName ?? this.officialName,
      shortName: shortName ?? this.shortName,
      nickname: nickname ?? this.nickname,
      country: country ?? this.country,
      province: province ?? this.province,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      familyCode: familyCode ?? this.familyCode,
      inviteCode: inviteCode ?? this.inviteCode,
      membersCount: membersCount ?? this.membersCount,
      treeVersion: treeVersion ?? this.treeVersion,
      settings: settings ?? this.settings,
      status: status ?? this.status,
    );
  }

  static String _readString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static String? _readNullableString(dynamic value) {
    final result = value?.toString().trim() ?? '';

    return result.isEmpty ? null : result;
  }

  static int _readInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }

  static DateTime _readDateTime(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      final parsed = DateTime.tryParse(value);

      if (parsed != null) {
        return parsed;
      }
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static FamilyStatus _readFamilyStatus(dynamic value) {
    if (value is FamilyStatus) {
      return value;
    }

    final valueString = value?.toString();

    for (final status in FamilyStatus.values) {
      if (status.name == valueString) {
        return status;
      }
    }

    return FamilyStatus.active;
  }

  static FamilySettings _readSettings(dynamic value) {
    if (value is! Map) {
      return const FamilySettings();
    }

    final map = Map<String, dynamic>.from(value);

    return FamilySettings(
      isPrivate: map['isPrivate'] as bool? ?? true,
      requiresApprovalToJoin: map['requiresApprovalToJoin'] as bool? ?? true,
      allowMembersToInvite: map['allowMembersToInvite'] as bool? ?? false,
      allowMembersToAddPeople: map['allowMembersToAddPeople'] as bool? ?? false,
      allowMembersToEditPeople:
          map['allowMembersToEditPeople'] as bool? ?? false,
      showLivingMembersBirthDates:
          map['showLivingMembersBirthDates'] as bool? ?? false,
      showContactInformation: map['showContactInformation'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> _settingsToMap(FamilySettings settings) {
    return {
      'isPrivate': settings.isPrivate,
      'requiresApprovalToJoin': settings.requiresApprovalToJoin,
      'allowMembersToInvite': settings.allowMembersToInvite,
      'allowMembersToAddPeople': settings.allowMembersToAddPeople,
      'allowMembersToEditPeople': settings.allowMembersToEditPeople,
      'showLivingMembersBirthDates': settings.showLivingMembersBirthDates,
      'showContactInformation': settings.showContactInformation,
    };
  }
}
