import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/family_invite_entity.dart';
import '../../domain/entities/family_member_entity.dart';

class FamilyInviteModel extends FamilyInviteEntity {
  const FamilyInviteModel({
    required super.id,
    required super.familyId,
    required super.code,
    required super.createdBy,
    required super.createdAt,
    required super.expiresAt,
    required super.status,
    required super.channel,
    required super.roleToAssign,
    super.recipientName,
    super.recipientPhone,
    super.recipientEmail,
    super.recipientUserId,
    super.acceptedBy,
    super.acceptedAt,
    super.cancelledAt,
    super.rejectedAt,
    super.message,
    super.maxUses,
    super.usedCount,
    super.requiresApproval,
  });

  factory FamilyInviteModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return FamilyInviteModel(
      id: document.id,
      familyId: data['familyId'] as String? ?? '',
      code: data['code'] as String? ?? '',
      recipientName: data['recipientName'] as String?,
      recipientPhone: data['recipientPhone'] as String?,
      recipientEmail: data['recipientEmail'] as String?,
      recipientUserId: data['recipientUserId'] as String?,
      createdBy: data['createdBy'] as String? ?? '',
      acceptedBy: data['acceptedBy'] as String?,
      roleToAssign: _roleFromString(data['roleToAssign']),
      channel: _channelFromString(data['channel']),
      status: _statusFromString(data['status']),
      message: data['message'] as String?,
      maxUses: (data['maxUses'] as num?)?.toInt() ?? 1,
      usedCount: (data['usedCount'] as num?)?.toInt() ?? 0,
      requiresApproval: data['requiresApproval'] as bool? ?? true,
      createdAt:
          _dateFromFirestore(data['createdAt']) ?? DateTime.now(),
      expiresAt:
          _dateFromFirestore(data['expiresAt']) ?? DateTime.now(),
      acceptedAt: _dateFromFirestore(data['acceptedAt']),
      cancelledAt: _dateFromFirestore(data['cancelledAt']),
      rejectedAt: _dateFromFirestore(data['rejectedAt']),
    );
  }

  factory FamilyInviteModel.fromMap(
    Map<String, dynamic> data, {
    required String id,
  }) {
    return FamilyInviteModel(
      id: id,
      familyId: data['familyId'] as String? ?? '',
      code: data['code'] as String? ?? '',
      recipientName: data['recipientName'] as String?,
      recipientPhone: data['recipientPhone'] as String?,
      recipientEmail: data['recipientEmail'] as String?,
      recipientUserId: data['recipientUserId'] as String?,
      createdBy: data['createdBy'] as String? ?? '',
      acceptedBy: data['acceptedBy'] as String?,
      roleToAssign: _roleFromString(data['roleToAssign']),
      channel: _channelFromString(data['channel']),
      status: _statusFromString(data['status']),
      message: data['message'] as String?,
      maxUses: (data['maxUses'] as num?)?.toInt() ?? 1,
      usedCount: (data['usedCount'] as num?)?.toInt() ?? 0,
      requiresApproval: data['requiresApproval'] as bool? ?? true,
      createdAt:
          _dateFromFirestore(data['createdAt']) ?? DateTime.now(),
      expiresAt:
          _dateFromFirestore(data['expiresAt']) ?? DateTime.now(),
      acceptedAt: _dateFromFirestore(data['acceptedAt']),
      cancelledAt: _dateFromFirestore(data['cancelledAt']),
      rejectedAt: _dateFromFirestore(data['rejectedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'code': code,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'recipientEmail': recipientEmail,
      'recipientUserId': recipientUserId,
      'createdBy': createdBy,
      'acceptedBy': acceptedBy,
      'roleToAssign': roleToAssign.name,
      'channel': channel.name,
      'status': status.name,
      'message': message,
      'maxUses': maxUses,
      'usedCount': usedCount,
      'requiresApproval': requiresApproval,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'acceptedAt': _dateToFirestore(acceptedAt),
      'cancelledAt': _dateToFirestore(cancelledAt),
      'rejectedAt': _dateToFirestore(rejectedAt),
    };
  }

  Map<String, dynamic> toFirestore() {
    return toMap();
  }

  FamilyInviteModel copyWithModel({
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
    final entity = copyWith(
      id: id,
      familyId: familyId,
      code: code,
      recipientName: recipientName,
      clearRecipientName: clearRecipientName,
      recipientPhone: recipientPhone,
      clearRecipientPhone: clearRecipientPhone,
      recipientEmail: recipientEmail,
      clearRecipientEmail: clearRecipientEmail,
      recipientUserId: recipientUserId,
      clearRecipientUserId: clearRecipientUserId,
      createdBy: createdBy,
      acceptedBy: acceptedBy,
      clearAcceptedBy: clearAcceptedBy,
      roleToAssign: roleToAssign,
      channel: channel,
      status: status,
      message: message,
      clearMessage: clearMessage,
      maxUses: maxUses,
      usedCount: usedCount,
      requiresApproval: requiresApproval,
      createdAt: createdAt,
      expiresAt: expiresAt,
      acceptedAt: acceptedAt,
      clearAcceptedAt: clearAcceptedAt,
      cancelledAt: cancelledAt,
      clearCancelledAt: clearCancelledAt,
      rejectedAt: rejectedAt,
      clearRejectedAt: clearRejectedAt,
    );

    return FamilyInviteModel(
      id: entity.id,
      familyId: entity.familyId,
      code: entity.code,
      recipientName: entity.recipientName,
      recipientPhone: entity.recipientPhone,
      recipientEmail: entity.recipientEmail,
      recipientUserId: entity.recipientUserId,
      createdBy: entity.createdBy,
      acceptedBy: entity.acceptedBy,
      roleToAssign: entity.roleToAssign,
      channel: entity.channel,
      status: entity.status,
      message: entity.message,
      maxUses: entity.maxUses,
      usedCount: entity.usedCount,
      requiresApproval: entity.requiresApproval,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
      acceptedAt: entity.acceptedAt,
      cancelledAt: entity.cancelledAt,
      rejectedAt: entity.rejectedAt,
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

  static FamilyMemberRole _roleFromString(dynamic value) {
    if (value is! String) {
      return FamilyMemberRole.member;
    }

    return FamilyMemberRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => FamilyMemberRole.member,
    );
  }

  static FamilyInviteChannel _channelFromString(dynamic value) {
    if (value is! String) {
      return FamilyInviteChannel.code;
    }

    return FamilyInviteChannel.values.firstWhere(
      (channel) => channel.name == value,
      orElse: () => FamilyInviteChannel.code,
    );
  }

  static FamilyInviteStatus _statusFromString(dynamic value) {
    if (value is! String) {
      return FamilyInviteStatus.pending;
    }

    return FamilyInviteStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => FamilyInviteStatus.pending,
    );
  }
}