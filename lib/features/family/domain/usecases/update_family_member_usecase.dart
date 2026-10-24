import '../entities/family_member_entity.dart';
import '../repositories/family_repository.dart';

class UpdateFamilyMemberUseCase {
  const UpdateFamilyMemberUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyMemberEntity> call(UpdateFamilyMemberParams params) async {
    _validateParams(params);

    final familyId = params.member.familyId.trim();
    final memberId = params.member.id.trim();

    final existingMember = await _repository.getMemberById(familyId, memberId);

    if (existingMember == null) {
      throw const UpdateFamilyMemberException(
        'O membro da família não foi encontrado.',
      );
    }

    if (existingMember.familyId != familyId) {
      throw const UpdateFamilyMemberException(
        'O membro não pertence à família indicada.',
      );
    }

    final member = params.member.copyWith(
      id: existingMember.id,
      familyId: existingMember.familyId,
      createdAt: existingMember.createdAt,
      createdBy: existingMember.createdBy,
      updatedAt: DateTime.now(),
    );

    _validateMember(member);

    if (member.userId != null &&
        member.userId!.trim().isNotEmpty &&
        member.userId != existingMember.userId) {
      final linkedMember = await _repository.getMemberByUserId(
        familyId,
        member.userId!.trim(),
      );

      if (linkedMember != null && linkedMember.id != memberId) {
        throw const UpdateFamilyMemberException(
          'Este utilizador já está ligado a outro membro desta família.',
        );
      }
    }

    return _repository.updateFamilyMember(member);
  }

  void _validateParams(UpdateFamilyMemberParams params) {
    final member = params.member;

    if (member.id.trim().isEmpty) {
      throw const UpdateFamilyMemberException(
        'O identificador do membro é obrigatório.',
      );
    }

    if (member.familyId.trim().isEmpty) {
      throw const UpdateFamilyMemberException(
        'O identificador da família é obrigatório.',
      );
    }
  }

  void _validateMember(FamilyMemberEntity member) {
    final firstName = member.firstName.trim();

    if (firstName.isEmpty) {
      throw const UpdateFamilyMemberException('O primeiro nome é obrigatório.');
    }

    if (firstName.length < 2) {
      throw const UpdateFamilyMemberException(
        'O primeiro nome deve possuir pelo menos 2 caracteres.',
      );
    }

    if (firstName.length > 50) {
      throw const UpdateFamilyMemberException(
        'O primeiro nome deve possuir no máximo 50 caracteres.',
      );
    }

    final lastName = member.lastName.trim();

    if (lastName.isEmpty) {
      throw const UpdateFamilyMemberException('O último nome é obrigatório.');
    }

    if (lastName.length < 2) {
      throw const UpdateFamilyMemberException(
        'O último nome deve possuir pelo menos 2 caracteres.',
      );
    }

    if (lastName.length > 80) {
      throw const UpdateFamilyMemberException(
        'O último nome deve possuir no máximo 80 caracteres.',
      );
    }

    if (member.middleNames != null && member.middleNames!.trim().length > 100) {
      throw const UpdateFamilyMemberException(
        'Os nomes intermédios devem possuir no máximo 100 caracteres.',
      );
    }

    if (member.preferredName != null &&
        member.preferredName!.trim().length > 60) {
      throw const UpdateFamilyMemberException(
        'O nome preferido deve possuir no máximo 60 caracteres.',
      );
    }

    final now = DateTime.now();

    if (member.birthDate != null && member.birthDate!.isAfter(now)) {
      throw const UpdateFamilyMemberException(
        'A data de nascimento não pode estar no futuro.',
      );
    }

    if (member.deathDate != null && member.deathDate!.isAfter(now)) {
      throw const UpdateFamilyMemberException(
        'A data de falecimento não pode estar no futuro.',
      );
    }

    if (member.birthDate != null &&
        member.deathDate != null &&
        member.deathDate!.isBefore(member.birthDate!)) {
      throw const UpdateFamilyMemberException(
        'A data de falecimento não pode ser anterior à data de nascimento.',
      );
    }

    if (member.biography != null && member.biography!.trim().length > 2000) {
      throw const UpdateFamilyMemberException(
        'A biografia deve possuir no máximo 2000 caracteres.',
      );
    }

    if (member.occupation != null && member.occupation!.trim().length > 100) {
      throw const UpdateFamilyMemberException(
        'A profissão deve possuir no máximo 100 caracteres.',
      );
    }

    if (member.email != null) {
      final email = member.email!.trim();

      if (email.isNotEmpty && !_isValidEmail(email)) {
        throw const UpdateFamilyMemberException(
          'O endereço de email é inválido.',
        );
      }
    }

    if (member.phoneNumber != null) {
      final phone = member.phoneNumber!.trim();

      if (phone.isNotEmpty && !_isValidPhone(phone)) {
        throw const UpdateFamilyMemberException(
          'O número de telefone possui um formato inválido.',
        );
      }
    }

    _validateRoleAndAccount(member);
    _validateStatus(member);
  }

  void _validateRoleAndAccount(FamilyMemberEntity member) {
    final userId = member.userId?.trim();

    final isAdministrativeRole =
        member.role == FamilyMemberRole.owner ||
        member.role == FamilyMemberRole.administrator ||
        member.role == FamilyMemberRole.editor;

    if (isAdministrativeRole && (userId == null || userId.isEmpty)) {
      throw const UpdateFamilyMemberException(
        'Membros com funções administrativas devem estar ligados a uma conta.',
      );
    }

    if (member.role == FamilyMemberRole.owner && !member.isVerified) {
      throw const UpdateFamilyMemberException(
        'O proprietário da família deve possuir identidade verificada.',
      );
    }

    if (member.isFamilyRoot && member.role != FamilyMemberRole.owner) {
      throw const UpdateFamilyMemberException(
        'O membro definido como pessoa-base deve possuir o papel de proprietário.',
      );
    }
  }

  void _validateStatus(FamilyMemberEntity member) {
    final hasDeathDate = member.deathDate != null;
    final isDeceased = member.status == FamilyMemberStatus.deceased;

    if (hasDeathDate && !isDeceased) {
      throw const UpdateFamilyMemberException(
        'Um membro com data de falecimento deve possuir o estado falecido.',
      );
    }

    if (isDeceased && !hasDeathDate) {
      throw const UpdateFamilyMemberException(
        'Informe a data de falecimento para membros falecidos.',
      );
    }

    if (isDeceased &&
        member.userId != null &&
        member.userId!.trim().isNotEmpty) {
      throw const UpdateFamilyMemberException(
        'Um membro falecido não pode permanecer ligado a uma conta ativa.',
      );
    }
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

class UpdateFamilyMemberParams {
  const UpdateFamilyMemberParams({required this.member});

  final FamilyMemberEntity member;
}

class UpdateFamilyMemberException implements Exception {
  const UpdateFamilyMemberException(this.message);

  final String message;

  @override
  String toString() => message;
}
