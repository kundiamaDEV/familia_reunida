import 'family_member_entity.dart';

enum FamilyInviteStatus { pending, accepted, expired, cancelled, rejected }

enum FamilyInviteChannel { code, link, sms, email, qrCode }

class FamilyInviteEntity {
  const FamilyInviteEntity({
    required this.id,
    required this.familyId,
    required this.code,
    required this.createdBy,
    required this.createdAt,
    required this.expiresAt,
    required this.status,
    required this.channel,
    required this.roleToAssign,
    this.recipientName,
    this.recipientPhone,
    this.recipientEmail,
    this.recipientUserId,
    this.acceptedBy,
    this.acceptedAt,
    this.cancelledAt,
    this.rejectedAt,
    this.message,
    this.maxUses = 1,
    this.usedCount = 0,
    this.requiresApproval = true,
  });

  /// Identificador interno do convite.
  final String id;

  /// Identificador da família associada.
  final String familyId;

  /// Código legível usado para aceitar o convite.
  ///
  /// Exemplo: SIMAO-8K4P2.
  final String code;

  /// Nome do destinatário, quando conhecido.
  final String? recipientName;

  /// Telefone do destinatário.
  final String? recipientPhone;

  /// Email do destinatário.
  final String? recipientEmail;

  /// Conta já existente do destinatário, quando aplicável.
  final String? recipientUserId;

  /// Utilizador que criou o convite.
  final String createdBy;

  /// Utilizador que aceitou o convite.
  final String? acceptedBy;

  /// Papel atribuído ao utilizador após a entrada.
  final FamilyMemberRole roleToAssign;

  /// Canal utilizado para partilhar o convite.
  final FamilyInviteChannel channel;

  /// Estado atual do convite.
  final FamilyInviteStatus status;

  /// Mensagem personalizada enviada com o convite.
  final String? message;

  /// Quantidade máxima de utilizações permitidas.
  final int maxUses;

  /// Quantidade de utilizações já realizadas.
  final int usedCount;

  /// Define se a entrada depende de aprovação administrativa.
  final bool requiresApproval;

  /// Data de criação.
  final DateTime createdAt;

  /// Data de expiração.
  final DateTime expiresAt;

  /// Data em que o convite foi aceite.
  final DateTime? acceptedAt;

  /// Data de cancelamento.
  final DateTime? cancelledAt;

  /// Data de rejeição.
  final DateTime? rejectedAt;

  bool get isPending => status == FamilyInviteStatus.pending;

  bool get isAccepted => status == FamilyInviteStatus.accepted;

  bool get isCancelled => status == FamilyInviteStatus.cancelled;

  bool get isRejected => status == FamilyInviteStatus.rejected;

  bool get isExpired {
    return status == FamilyInviteStatus.expired ||
        DateTime.now().isAfter(expiresAt);
  }

  bool get hasAvailableUses => usedCount < maxUses;

  bool get canBeUsed {
    return isPending && !isExpired && hasAvailableUses;
  }

  bool get hasRecipient {
    return (recipientPhone != null && recipientPhone!.trim().isNotEmpty) ||
        (recipientEmail != null && recipientEmail!.trim().isNotEmpty) ||
        (recipientUserId != null && recipientUserId!.trim().isNotEmpty);
  }

  int get remainingUses {
    final remaining = maxUses - usedCount;

    return remaining < 0 ? 0 : remaining;
  }

  Duration get remainingValidity {
    final remaining = expiresAt.difference(DateTime.now());

    return remaining.isNegative ? Duration.zero : remaining;
  }

  FamilyInviteEntity copyWith({
    String? id,
    String? familyId,
    String? code,
    String? recipientName,
    bool clearRecipientName = false,
    String? recipientPhone,
    bool clearRecipientPhone = false,
    String? recipientEmail,
    bool clearRecipientEmail = false,
    String? recipientUserId,
    bool clearRecipientUserId = false,
    String? createdBy,
    String? acceptedBy,
    bool clearAcceptedBy = false,
    FamilyMemberRole? roleToAssign,
    FamilyInviteChannel? channel,
    FamilyInviteStatus? status,
    String? message,
    bool clearMessage = false,
    int? maxUses,
    int? usedCount,
    bool? requiresApproval,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    bool clearAcceptedAt = false,
    DateTime? cancelledAt,
    bool clearCancelledAt = false,
    DateTime? rejectedAt,
    bool clearRejectedAt = false,
  }) {
    return FamilyInviteEntity(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      code: code ?? this.code,
      recipientName: clearRecipientName
          ? null
          : recipientName ?? this.recipientName,
      recipientPhone: clearRecipientPhone
          ? null
          : recipientPhone ?? this.recipientPhone,
      recipientEmail: clearRecipientEmail
          ? null
          : recipientEmail ?? this.recipientEmail,
      recipientUserId: clearRecipientUserId
          ? null
          : recipientUserId ?? this.recipientUserId,
      createdBy: createdBy ?? this.createdBy,
      acceptedBy: clearAcceptedBy ? null : acceptedBy ?? this.acceptedBy,
      roleToAssign: roleToAssign ?? this.roleToAssign,
      channel: channel ?? this.channel,
      status: status ?? this.status,
      message: clearMessage ? null : message ?? this.message,
      maxUses: maxUses ?? this.maxUses,
      usedCount: usedCount ?? this.usedCount,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: clearAcceptedAt ? null : acceptedAt ?? this.acceptedAt,
      cancelledAt: clearCancelledAt ? null : cancelledAt ?? this.cancelledAt,
      rejectedAt: clearRejectedAt ? null : rejectedAt ?? this.rejectedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is FamilyInviteEntity &&
        other.id == id &&
        other.familyId == familyId &&
        other.code == code &&
        other.recipientName == recipientName &&
        other.recipientPhone == recipientPhone &&
        other.recipientEmail == recipientEmail &&
        other.recipientUserId == recipientUserId &&
        other.createdBy == createdBy &&
        other.acceptedBy == acceptedBy &&
        other.roleToAssign == roleToAssign &&
        other.channel == channel &&
        other.status == status &&
        other.message == message &&
        other.maxUses == maxUses &&
        other.usedCount == usedCount &&
        other.requiresApproval == requiresApproval &&
        other.createdAt == createdAt &&
        other.expiresAt == expiresAt &&
        other.acceptedAt == acceptedAt &&
        other.cancelledAt == cancelledAt &&
        other.rejectedAt == rejectedAt;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      familyId,
      code,
      recipientName,
      recipientPhone,
      recipientEmail,
      recipientUserId,
      createdBy,
      acceptedBy,
      roleToAssign,
      channel,
      status,
      message,
      maxUses,
      usedCount,
      requiresApproval,
      createdAt,
      expiresAt,
      acceptedAt,
      cancelledAt,
      rejectedAt,
    ]);
  }

  @override
  String toString() {
    return 'FamilyInviteEntity('
        'id: $id, '
        'familyId: $familyId, '
        'code: $code, '
        'status: $status, '
        'channel: $channel, '
        'remainingUses: $remainingUses'
        ')';
  }
}
