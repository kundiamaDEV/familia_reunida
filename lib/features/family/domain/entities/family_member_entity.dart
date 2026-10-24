enum FamilyMemberStatus { active, inactive, deceased, removed }

enum FamilyMemberRole { owner, administrator, editor, member, viewer }

enum Gender { male, female, other, notInformed }

class FamilyMemberEntity {
  const FamilyMemberEntity({
    required this.id,
    required this.familyId,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.role,
    required this.status,
    this.userId,
    this.middleNames,
    this.preferredName,
    this.gender = Gender.notInformed,
    this.birthDate,
    this.birthPlace,
    this.deathDate,
    this.deathPlace,
    this.biography,
    this.occupation,
    this.phoneNumber,
    this.email,
    this.photoUrl,
    this.coverPhotoUrl,
    this.isFamilyRoot = false,
    this.isProfilePrivate = true,
    this.isVerified = false,
  });

  /// Identificador único do membro dentro da plataforma.
  final String id;

  /// Identificador da família à qual o membro pertence.
  final String familyId;

  /// Identificador da conta do utilizador.
  ///
  /// Pode ser nulo quando a pessoa existe apenas na árvore familiar.
  final String? userId;

  /// Primeiro nome.
  final String firstName;

  /// Outros nomes.
  final String? middleNames;

  /// Último nome ou apelido principal.
  final String lastName;

  /// Nome pelo qual a pessoa prefere ser apresentada.
  final String? preferredName;

  /// Género informado no perfil.
  final Gender gender;

  /// Data de nascimento.
  final DateTime? birthDate;

  /// Local de nascimento.
  final String? birthPlace;

  /// Data de falecimento.
  final DateTime? deathDate;

  /// Local de falecimento.
  final String? deathPlace;

  /// Pequena biografia ou resumo da história da pessoa.
  final String? biography;

  /// Profissão ou principal área de atividade.
  final String? occupation;

  /// Número de telefone.
  final String? phoneNumber;

  /// Endereço de email.
  final String? email;

  /// Fotografia principal.
  final String? photoUrl;

  /// Imagem de capa.
  final String? coverPhotoUrl;

  /// Papel administrativo dentro do espaço familiar.
  final FamilyMemberRole role;

  /// Estado atual do membro.
  final FamilyMemberStatus status;

  /// Indica se este membro é a pessoa-base inicial da árvore.
  final bool isFamilyRoot;

  /// Indica se o perfil deve ser tratado como privado.
  final bool isProfilePrivate;

  /// Indica se a identidade do membro foi confirmada.
  final bool isVerified;

  /// Data de criação do registo.
  final DateTime createdAt;

  /// Data da última atualização.
  final DateTime updatedAt;

  /// Utilizador responsável pela criação do registo.
  final String createdBy;

  bool get isLinkedToUser => userId != null && userId!.trim().isNotEmpty;

  bool get isAlive =>
      status != FamilyMemberStatus.deceased && deathDate == null;

  bool get isDeceased =>
      status == FamilyMemberStatus.deceased || deathDate != null;

  bool get isActive => status == FamilyMemberStatus.active;

  bool get canManageFamily =>
      role == FamilyMemberRole.owner || role == FamilyMemberRole.administrator;

  bool get canEditFamilyData =>
      canManageFamily || role == FamilyMemberRole.editor;

  bool get hasPhoto => photoUrl != null && photoUrl!.trim().isNotEmpty;

  bool get hasBiography => biography != null && biography!.trim().isNotEmpty;

  String get fullName {
    final parts = <String>[
      firstName.trim(),
      if (middleNames != null && middleNames!.trim().isNotEmpty)
        middleNames!.trim(),
      lastName.trim(),
    ];

    return parts.where((part) => part.isNotEmpty).join(' ');
  }

  String get displayName {
    final preferred = preferredName?.trim() ?? '';

    if (preferred.isNotEmpty) {
      return preferred;
    }

    return fullName;
  }

  int? get age {
    if (birthDate == null) {
      return null;
    }

    final endDate = deathDate ?? DateTime.now();

    var calculatedAge = endDate.year - birthDate!.year;

    final hasNotHadBirthday =
        endDate.month < birthDate!.month ||
        (endDate.month == birthDate!.month && endDate.day < birthDate!.day);

    if (hasNotHadBirthday) {
      calculatedAge--;
    }

    return calculatedAge;
  }

  FamilyMemberEntity copyWith({
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
    return FamilyMemberEntity(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      userId: clearUserId ? null : userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      middleNames: clearMiddleNames ? null : middleNames ?? this.middleNames,
      lastName: lastName ?? this.lastName,
      preferredName: clearPreferredName
          ? null
          : preferredName ?? this.preferredName,
      gender: gender ?? this.gender,
      birthDate: clearBirthDate ? null : birthDate ?? this.birthDate,
      birthPlace: clearBirthPlace ? null : birthPlace ?? this.birthPlace,
      deathDate: clearDeathDate ? null : deathDate ?? this.deathDate,
      deathPlace: clearDeathPlace ? null : deathPlace ?? this.deathPlace,
      biography: clearBiography ? null : biography ?? this.biography,
      occupation: clearOccupation ? null : occupation ?? this.occupation,
      phoneNumber: clearPhoneNumber ? null : phoneNumber ?? this.phoneNumber,
      email: clearEmail ? null : email ?? this.email,
      photoUrl: clearPhotoUrl ? null : photoUrl ?? this.photoUrl,
      coverPhotoUrl: clearCoverPhotoUrl
          ? null
          : coverPhotoUrl ?? this.coverPhotoUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      isFamilyRoot: isFamilyRoot ?? this.isFamilyRoot,
      isProfilePrivate: isProfilePrivate ?? this.isProfilePrivate,
      isVerified: isVerified ?? this.isVerified,
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

    return other is FamilyMemberEntity &&
        other.id == id &&
        other.familyId == familyId &&
        other.userId == userId &&
        other.firstName == firstName &&
        other.middleNames == middleNames &&
        other.lastName == lastName &&
        other.preferredName == preferredName &&
        other.gender == gender &&
        other.birthDate == birthDate &&
        other.birthPlace == birthPlace &&
        other.deathDate == deathDate &&
        other.deathPlace == deathPlace &&
        other.biography == biography &&
        other.occupation == occupation &&
        other.phoneNumber == phoneNumber &&
        other.email == email &&
        other.photoUrl == photoUrl &&
        other.coverPhotoUrl == coverPhotoUrl &&
        other.role == role &&
        other.status == status &&
        other.isFamilyRoot == isFamilyRoot &&
        other.isProfilePrivate == isProfilePrivate &&
        other.isVerified == isVerified &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      familyId,
      userId,
      firstName,
      middleNames,
      lastName,
      preferredName,
      gender,
      birthDate,
      birthPlace,
      deathDate,
      deathPlace,
      biography,
      occupation,
      phoneNumber,
      email,
      photoUrl,
      coverPhotoUrl,
      role,
      status,
      isFamilyRoot,
      isProfilePrivate,
      isVerified,
      createdAt,
      updatedAt,
      createdBy,
    ]);
  }

  @override
  String toString() {
    return 'FamilyMemberEntity('
        'id: $id, '
        'familyId: $familyId, '
        'displayName: $displayName, '
        'role: $role, '
        'status: $status, '
        'isLinkedToUser: $isLinkedToUser'
        ')';
  }
}
