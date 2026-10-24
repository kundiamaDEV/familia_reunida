import '../entities/family_invite_entity.dart';
import '../entities/family_member_entity.dart';
import '../repositories/family_repository.dart';

class CreateFamilyInviteUseCase {
  const CreateFamilyInviteUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyInviteEntity> call(
    CreateFamilyInviteParams params,
  ) async {
    _validateParams(params);

    final invite = params.invite;

    final familyId = invite.familyId.trim();
    final code = invite.code.trim().toUpperCase();
    final createdBy = params.createdBy.trim();

    final family = await _repository.getFamilyById(familyId);

    if (family == null) {
      throw const CreateFamilyInviteException(
        'A família não foi encontrada.',
      );
    }

    final creator = await _repository.getMemberByUserId(
      familyId,
      createdBy,
    );

    if (creator == null) {
      throw const CreateFamilyInviteException(
        'O utilizador responsável não pertence à família.',
      );
    }

    _validateCreator(creator);

    final existingInvite = await _repository.getInviteByCode(code);

    if (existingInvite != null) {
      throw const CreateFamilyInviteException(
        'O código do convite já está em utilização.',
      );
    }

    if (invite.expiresAt.isBefore(DateTime.now())) {
      throw const CreateFamilyInviteException(
        'A data de expiração do convite deve estar no futuro.',
      );
    }

    if (invite.maxUses < 1) {
      throw const CreateFamilyInviteException(
        'O convite deve permitir pelo menos uma utilização.',
      );
    }

    if (invite.usedCount < 0) {
      throw const CreateFamilyInviteException(
        'A quantidade de utilizações não pode ser negativa.',
      );
    }

    if (invite.usedCount > invite.maxUses) {
      throw const CreateFamilyInviteException(
        'A quantidade de utilizações não pode exceder o limite definido.',
      );
    }

    if (invite.status != FamilyInviteStatus.pending) {
      throw const CreateFamilyInviteException(
        'Um novo convite deve possuir o estado pendente.',
      );
    }

    if (invite.roleToAssign == FamilyMemberRole.owner) {
      throw const CreateFamilyInviteException(
        'O papel de proprietário não pode ser atribuído através de um convite.',
      );
    }

    final now = DateTime.now();

    final normalizedInvite = invite.copyWith(
      familyId: familyId,
      code: code,
      createdBy: createdBy,
      createdAt: now,
      status: FamilyInviteStatus.pending,
      usedCount: 0,
    );

    return _repository.createFamilyInvite(normalizedInvite);
  }

  void _validateParams(CreateFamilyInviteParams params) {
    final invite = params.invite;

    if (invite.id.trim().isEmpty) {
      throw const CreateFamilyInviteException(
        'O identificador do convite é obrigatório.',
      );
    }

    if (invite.familyId.trim().isEmpty) {
      throw const CreateFamilyInviteException(
        'O identificador da família é obrigatório.',
      );
    }

    if (invite.code.trim().isEmpty) {
      throw const CreateFamilyInviteException(
        'O código do convite é obrigatório.',
      );
    }

    final normalizedCode = invite.code.trim().toUpperCase();

    if (!_isValidCode(normalizedCode)) {
      throw const CreateFamilyInviteException(
        'O código do convite possui um formato inválido.',
      );
    }

    if (params.createdBy.trim().isEmpty) {
      throw const CreateFamilyInviteException(
        'O utilizador responsável pela criação é obrigatório.',
      );
    }

    if (invite.recipientName != null &&
        invite.recipientName!.trim().length > 100) {
      throw const CreateFamilyInviteException(
        'O nome do destinatário deve possuir no máximo 100 caracteres.',
      );
    }

    if (invite.recipientPhone != null &&
        invite.recipientPhone!.trim().isNotEmpty &&
        !_isValidPhone(invite.recipientPhone!.trim())) {
      throw const CreateFamilyInviteException(
        'O número de telefone do destinatário possui um formato inválido.',
      );
    }

    if (invite.recipientEmail != null &&
        invite.recipientEmail!.trim().isNotEmpty &&
        !_isValidEmail(invite.recipientEmail!.trim())) {
      throw const CreateFamilyInviteException(
        'O email do destinatário possui um formato inválido.',
      );
    }

    if (invite.message != null &&
        invite.message!.trim().length > 500) {
      throw const CreateFamilyInviteException(
        'A mensagem do convite deve possuir no máximo 500 caracteres.',
      );
    }

    if (invite.maxUses < 1) {
      throw const CreateFamilyInviteException(
        'O convite deve permitir pelo menos uma utilização.',
      );
    }

    if (invite.maxUses > 100) {
      throw const CreateFamilyInviteException(
        'O convite pode possuir no máximo 100 utilizações.',
      );
    }

    if (invite.usedCount < 0) {
      throw const CreateFamilyInviteException(
        'A quantidade de utilizações não pode ser negativa.',
      );
    }

    if (invite.usedCount > invite.maxUses) {
      throw const CreateFamilyInviteException(
        'A quantidade de utilizações não pode exceder o limite definido.',
      );
    }

    if (invite.expiresAt.isBefore(invite.createdAt)) {
      throw const CreateFamilyInviteException(
        'A data de expiração não pode ser anterior à data de criação.',
      );
    }
  }

  void _validateCreator(FamilyMemberEntity creator) {
    if (creator.status == FamilyMemberStatus.removed) {
      throw const CreateFamilyInviteException(
        'Um membro removido não pode criar convites.',
      );
    }

    if (creator.status == FamilyMemberStatus.deceased) {
      throw const CreateFamilyInviteException(
        'Um membro falecido não pode criar convites.',
      );
    }

    final canCreateInvite =
        creator.role == FamilyMemberRole.owner ||
        creator.role == FamilyMemberRole.administrator ||
        creator.role == FamilyMemberRole.editor;

    if (!canCreateInvite) {
      throw const CreateFamilyInviteException(
        'O membro não possui permissão para criar convites.',
      );
    }
  }

  bool _isValidCode(String value) {
    return RegExp(r'^[A-Z0-9]+(?:-[A-Z0-9]+)*$').hasMatch(value);
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  bool _isValidPhone(String value) {
    final normalized = value
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    return RegExp(r'^\+?[0-9]{8,15}$').hasMatch(normalized);
  }
}

class CreateFamilyInviteParams {
  const CreateFamilyInviteParams({
    required this.invite,
    required this.createdBy,
  });

  final FamilyInviteEntity invite;
  final String createdBy;
}

class CreateFamilyInviteException implements Exception {
  const CreateFamilyInviteException(this.message);

  final String message;

  @override
  String toString() => message;
}