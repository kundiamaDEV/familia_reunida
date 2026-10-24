import '../entities/family_invite_entity.dart';
import '../entities/family_member_entity.dart';
import '../repositories/family_repository.dart';

class AcceptFamilyInviteUseCase {
  const AcceptFamilyInviteUseCase(this._repository);

  final FamilyRepository _repository;

  Future<AcceptFamilyInviteResult> call(AcceptFamilyInviteParams params) async {
    _validateParams(params);

    final normalizedCode = _normalizeCode(params.code);

    final invite = await _repository.getInviteByCode(normalizedCode);

    if (invite == null) {
      throw const AcceptFamilyInviteException(
        'O convite informado não foi encontrado.',
      );
    }

    _validateInvite(invite: invite, params: params);

    final existingMember = await _repository.getMemberByUserId(
      invite.familyId,
      params.userId.trim(),
    );

    if (existingMember != null &&
        existingMember.status != FamilyMemberStatus.removed) {
      throw const AcceptFamilyInviteException(
        'Este utilizador já pertence à família.',
      );
    }

    final acceptedInvite = await _repository.acceptInvite(
      code: normalizedCode,
      userId: params.userId.trim(),
    );

    return AcceptFamilyInviteResult(
      invite: acceptedInvite,
      familyId: acceptedInvite.familyId,
      roleToAssign: acceptedInvite.roleToAssign,
      requiresApproval: acceptedInvite.requiresApproval,
    );
  }

  void _validateParams(AcceptFamilyInviteParams params) {
    if (params.code.trim().isEmpty) {
      throw const AcceptFamilyInviteException('Informe o código do convite.');
    }

    if (params.userId.trim().isEmpty) {
      throw const AcceptFamilyInviteException(
        'O identificador do utilizador é obrigatório.',
      );
    }

    final normalizedCode = _normalizeCode(params.code);

    if (!_isValidCode(normalizedCode)) {
      throw const AcceptFamilyInviteException(
        'O código do convite possui um formato inválido.',
      );
    }

    final phone = _nullableTrim(params.userPhone);

    if (phone != null && !_isValidPhone(phone)) {
      throw const AcceptFamilyInviteException(
        'O número de telefone possui um formato inválido.',
      );
    }

    final email = _nullableTrim(params.userEmail);

    if (email != null && !_isValidEmail(email)) {
      throw const AcceptFamilyInviteException(
        'O endereço de email possui um formato inválido.',
      );
    }
  }

  void _validateInvite({
    required FamilyInviteEntity invite,
    required AcceptFamilyInviteParams params,
  }) {
    if (invite.status == FamilyInviteStatus.accepted) {
      throw const AcceptFamilyInviteException('Este convite já foi aceite.');
    }

    if (invite.status == FamilyInviteStatus.cancelled) {
      throw const AcceptFamilyInviteException('Este convite foi cancelado.');
    }

    if (invite.status == FamilyInviteStatus.rejected) {
      throw const AcceptFamilyInviteException('Este convite foi rejeitado.');
    }

    if (invite.isExpired) {
      throw const AcceptFamilyInviteException('Este convite expirou.');
    }

    if (!invite.hasAvailableUses) {
      throw const AcceptFamilyInviteException(
        'Este convite já atingiu o limite de utilizações.',
      );
    }

    if (!invite.canBeUsed) {
      throw const AcceptFamilyInviteException(
        'Este convite não pode ser utilizado.',
      );
    }

    _validateRecipient(invite: invite, params: params);
  }

  void _validateRecipient({
    required FamilyInviteEntity invite,
    required AcceptFamilyInviteParams params,
  }) {
    final expectedUserId = _nullableTrim(invite.recipientUserId);

    if (expectedUserId != null && expectedUserId != params.userId.trim()) {
      throw const AcceptFamilyInviteException(
        'Este convite foi emitido para outro utilizador.',
      );
    }

    final expectedPhone = _normalizePhone(invite.recipientPhone);

    final informedPhone = _normalizePhone(params.userPhone);

    if (expectedPhone != null) {
      if (informedPhone == null) {
        throw const AcceptFamilyInviteException(
          'Confirme o número de telefone associado ao convite.',
        );
      }

      if (expectedPhone != informedPhone) {
        throw const AcceptFamilyInviteException(
          'O número de telefone não corresponde ao destinatário do convite.',
        );
      }
    }

    final expectedEmail = _normalizeEmail(invite.recipientEmail);

    final informedEmail = _normalizeEmail(params.userEmail);

    if (expectedEmail != null) {
      if (informedEmail == null) {
        throw const AcceptFamilyInviteException(
          'Confirme o email associado ao convite.',
        );
      }

      if (expectedEmail != informedEmail) {
        throw const AcceptFamilyInviteException(
          'O email não corresponde ao destinatário do convite.',
        );
      }
    }
  }

  String _normalizeCode(String value) {
    return value.trim().toUpperCase();
  }

  String? _normalizePhone(String? value) {
    final phone = _nullableTrim(value);

    if (phone == null) {
      return null;
    }

    return phone
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');
  }

  String? _normalizeEmail(String? value) {
    final email = _nullableTrim(value);

    return email?.toLowerCase();
  }

  String? _nullableTrim(String? value) {
    final normalized = value?.trim() ?? '';

    return normalized.isEmpty ? null : normalized;
  }

  bool _isValidCode(String value) {
    return RegExp(r'^[A-Z0-9]+(?:-[A-Z0-9]+)*$').hasMatch(value);
  }

  bool _isValidPhone(String value) {
    final normalized = _normalizePhone(value) ?? '';

    return RegExp(r'^\+?[0-9]{8,15}$').hasMatch(normalized);
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
  }
}

class AcceptFamilyInviteParams {
  const AcceptFamilyInviteParams({
    required this.code,
    required this.userId,
    this.userPhone,
    this.userEmail,
  });

  final String code;
  final String userId;
  final String? userPhone;
  final String? userEmail;
}

class AcceptFamilyInviteResult {
  const AcceptFamilyInviteResult({
    required this.invite,
    required this.familyId,
    required this.roleToAssign,
    required this.requiresApproval,
  });

  final FamilyInviteEntity invite;
  final String familyId;
  final FamilyMemberRole roleToAssign;
  final bool requiresApproval;

  bool get canEnterImmediately => !requiresApproval;
}

class AcceptFamilyInviteException implements Exception {
  const AcceptFamilyInviteException(this.message);

  final String message;

  @override
  String toString() => message;
}
