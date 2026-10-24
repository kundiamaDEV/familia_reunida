enum FamilyStatus { active, suspended, archived }

class FamilyEntity {
  const FamilyEntity({
    required this.id,
    required this.officialName,
    required this.shortName,
    required this.country,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.familyCode,
    required this.inviteCode,
    required this.settings,
    this.nickname,
    this.province,
    this.description,
    this.photoUrl,
    this.coverPhotoUrl,
    this.membersCount = 1,
    this.treeVersion = 1,
    this.status = FamilyStatus.active,
  });

  /// Identificador único interno da família.
  final String id;

  /// Nome completo apresentado nos documentos e no perfil.
  ///
  /// Exemplo: Família Manuel Simão.
  final String officialName;

  /// Nome curto utilizado em espaços menores da interface.
  ///
  /// Exemplo: Simão.
  final String shortName;

  /// Nome informal pelo qual a família também é conhecida.
  final String? nickname;

  /// País principal de origem ou referência da família.
  final String country;

  /// Província principal de origem ou referência.
  final String? province;

  /// Pequena apresentação da história e identidade familiar.
  final String? description;

  /// Data em que o espaço familiar foi criado.
  final DateTime createdAt;

  /// Data da última alteração.
  final DateTime updatedAt;

  /// Identificador do utilizador que criou a família.
  final String createdBy;

  /// Fotografia ou logótipo principal da família.
  final String? photoUrl;

  /// Imagem de capa do perfil familiar.
  final String? coverPhotoUrl;

  /// Código público e legível da família.
  ///
  /// Exemplo: FR-SIMAO-2026.
  final String familyCode;

  /// Código utilizado para convidar novos membros.
  final String inviteCode;

  /// Quantidade atual de membros associados.
  final int membersCount;

  /// Versão atual da árvore genealógica.
  final int treeVersion;

  /// Configurações de privacidade e funcionamento.
  final FamilySettings settings;

  /// Estado operacional da família.
  final FamilyStatus status;

  bool get isActive => status == FamilyStatus.active;

  bool get isSuspended => status == FamilyStatus.suspended;

  bool get isArchived => status == FamilyStatus.archived;

  bool get hasDescription =>
      description != null && description!.trim().isNotEmpty;

  bool get hasPhoto => photoUrl != null && photoUrl!.trim().isNotEmpty;

  bool get hasCoverPhoto =>
      coverPhotoUrl != null && coverPhotoUrl!.trim().isNotEmpty;

  String get displayName {
    final trimmedNickname = nickname?.trim() ?? '';

    if (trimmedNickname.isNotEmpty) {
      return trimmedNickname;
    }

    return officialName;
  }

  FamilyEntity copyWith({
    String? id,
    String? officialName,
    String? shortName,
    String? nickname,
    bool clearNickname = false,
    String? country,
    String? province,
    bool clearProvince = false,
    String? description,
    bool clearDescription = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? photoUrl,
    bool clearPhotoUrl = false,
    String? coverPhotoUrl,
    bool clearCoverPhotoUrl = false,
    String? familyCode,
    String? inviteCode,
    int? membersCount,
    int? treeVersion,
    FamilySettings? settings,
    FamilyStatus? status,
  }) {
    return FamilyEntity(
      id: id ?? this.id,
      officialName: officialName ?? this.officialName,
      shortName: shortName ?? this.shortName,
      nickname: clearNickname ? null : nickname ?? this.nickname,
      country: country ?? this.country,
      province: clearProvince ? null : province ?? this.province,
      description: clearDescription ? null : description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      photoUrl: clearPhotoUrl ? null : photoUrl ?? this.photoUrl,
      coverPhotoUrl: clearCoverPhotoUrl
          ? null
          : coverPhotoUrl ?? this.coverPhotoUrl,
      familyCode: familyCode ?? this.familyCode,
      inviteCode: inviteCode ?? this.inviteCode,
      membersCount: membersCount ?? this.membersCount,
      treeVersion: treeVersion ?? this.treeVersion,
      settings: settings ?? this.settings,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FamilyEntity &&
        other.id == id &&
        other.officialName == officialName &&
        other.shortName == shortName &&
        other.nickname == nickname &&
        other.country == country &&
        other.province == province &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.createdBy == createdBy &&
        other.photoUrl == photoUrl &&
        other.coverPhotoUrl == coverPhotoUrl &&
        other.familyCode == familyCode &&
        other.inviteCode == inviteCode &&
        other.membersCount == membersCount &&
        other.treeVersion == treeVersion &&
        other.settings == settings &&
        other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      officialName,
      shortName,
      nickname,
      country,
      province,
      description,
      createdAt,
      updatedAt,
      createdBy,
      photoUrl,
      coverPhotoUrl,
      familyCode,
      inviteCode,
      membersCount,
      treeVersion,
      settings,
      status,
    );
  }

  @override
  String toString() {
    return 'FamilyEntity('
        'id: $id, '
        'officialName: $officialName, '
        'shortName: $shortName, '
        'country: $country, '
        'province: $province, '
        'membersCount: $membersCount, '
        'status: $status'
        ')';
  }
}

class FamilySettings {
  const FamilySettings({
    this.isPrivate = true,
    this.requiresApprovalToJoin = true,
    this.allowMembersToInvite = false,
    this.allowMembersToAddPeople = false,
    this.allowMembersToEditPeople = false,
    this.showLivingMembersBirthDates = false,
    this.showContactInformation = false,
  });

  /// Define se o espaço familiar é privado.
  final bool isPrivate;

  /// Determina se novos membros precisam de aprovação.
  final bool requiresApprovalToJoin;

  /// Permite que membros comuns enviem convites.
  final bool allowMembersToInvite;

  /// Permite que membros comuns adicionem pessoas à árvore.
  final bool allowMembersToAddPeople;

  /// Permite que membros comuns alterem dados de outras pessoas.
  final bool allowMembersToEditPeople;

  /// Permite mostrar publicamente as datas de nascimento
  /// dos membros vivos dentro da família.
  final bool showLivingMembersBirthDates;

  /// Permite mostrar telefone e email aos membros autorizados.
  final bool showContactInformation;

  FamilySettings copyWith({
    bool? isPrivate,
    bool? requiresApprovalToJoin,
    bool? allowMembersToInvite,
    bool? allowMembersToAddPeople,
    bool? allowMembersToEditPeople,
    bool? showLivingMembersBirthDates,
    bool? showContactInformation,
  }) {
    return FamilySettings(
      isPrivate: isPrivate ?? this.isPrivate,
      requiresApprovalToJoin:
          requiresApprovalToJoin ?? this.requiresApprovalToJoin,
      allowMembersToInvite: allowMembersToInvite ?? this.allowMembersToInvite,
      allowMembersToAddPeople:
          allowMembersToAddPeople ?? this.allowMembersToAddPeople,
      allowMembersToEditPeople:
          allowMembersToEditPeople ?? this.allowMembersToEditPeople,
      showLivingMembersBirthDates:
          showLivingMembersBirthDates ?? this.showLivingMembersBirthDates,
      showContactInformation:
          showContactInformation ?? this.showContactInformation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FamilySettings &&
        other.isPrivate == isPrivate &&
        other.requiresApprovalToJoin == requiresApprovalToJoin &&
        other.allowMembersToInvite == allowMembersToInvite &&
        other.allowMembersToAddPeople == allowMembersToAddPeople &&
        other.allowMembersToEditPeople == allowMembersToEditPeople &&
        other.showLivingMembersBirthDates == showLivingMembersBirthDates &&
        other.showContactInformation == showContactInformation;
  }

  @override
  int get hashCode {
    return Object.hash(
      isPrivate,
      requiresApprovalToJoin,
      allowMembersToInvite,
      allowMembersToAddPeople,
      allowMembersToEditPeople,
      showLivingMembersBirthDates,
      showContactInformation,
    );
  }
}
