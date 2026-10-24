import '../entities/family_member_entity.dart';
import '../repositories/family_repository.dart';

class AddFamilyMemberUseCase {
  const AddFamilyMemberUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyMemberEntity> call(AddFamilyMemberParams params) async {
    _validateParams(params);

    final existingMember = params.userId == null
        ? null
        : await _repository.getMemberByUserId(
            params.familyId.trim(),
            params.userId!.trim(),
          );

    if (existingMember != null) {
      throw const AddFamilyMemberException(
        'Este utilizador já está ligado a um membro desta família.',
      );
    }

    final now = DateTime.now();

    final member = FamilyMemberEntity(
      id: params.id.trim(),
      familyId: params.familyId.trim(),
      userId: _nullableTrim(params.userId),
      firstName: params.firstName.trim(),
      middleNames: _nullableTrim(params.middleNames),
      lastName: params.lastName.trim(),
      preferredName: _nullableTrim(params.preferredName),
      gender: params.gender,
      birthDate: params.birthDate,
      birthPlace: _nullableTrim(params.birthPlace),
      deathDate: params.deathDate,
      deathPlace: _nullableTrim(params.deathPlace),
      biography: _nullableTrim(params.biography),
      occupation: _nullableTrim(params.occupation),
      phoneNumber: _nullableTrim(params.phoneNumber),
      email: _nullableTrim(params.email)?.toLowerCase(),
      photoUrl: _nullableTrim(params.photoUrl),
      coverPhotoUrl: _nullableTrim(params.coverPhotoUrl),
      role: params.role,
      status: params.status,
      isFamilyRoot: params.isFamilyRoot,
      isProfilePrivate: params.isProfilePrivate,
      isVerified: params.isVerified,
      createdAt: now,
      updatedAt: now,
      createdBy: params.createdBy.trim(),
    );

    return _repository.addMember(member);
  }

  void _validateParams(AddFamilyMemberParams params) {
    if (params.id.trim().isEmpty) {
      throw const AddFamilyMemberException(
        'O identificador do membro é obrigatório.',
      );
    }

    if (params.familyId.trim().isEmpty) {
      throw const AddFamilyMemberException(
        'O identificador da família é obrigatório.',
      );
    }

    if (params.createdBy.trim().isEmpty) {
      throw const AddFamilyMemberException(
        'O utilizador responsável é obrigatório.',
      );
    }

    final firstName = params.firstName.trim();

    if (firstName.isEmpty) {
      throw const AddFamilyMemberException('O primeiro nome é obrigatório.');
    }

    if (firstName.length < 2) {
      throw const AddFamilyMemberException(
        'O primeiro nome deve possuir pelo menos 2 caracteres.',
      );
    }

    if (firstName.length > 50) {
      throw const AddFamilyMemberException(
        'O primeiro nome deve possuir no máximo 50 caracteres.',
      );
    }

    final lastName = params.lastName.trim();

    if (lastName.isEmpty) {
      throw const AddFamilyMemberException('O último nome é obrigatório.');
    }

    if (lastName.length < 2) {
      throw const AddFamilyMemberException(
        'O último nome deve possuir pelo menos 2 caracteres.',
      );
    }

    if (lastName.length > 80) {
      throw const AddFamilyMemberException(
        'O último nome deve possuir no máximo 80 caracteres.',
      );
    }

    final middleNames = _nullableTrim(params.middleNames);

    if (middleNames != null && middleNames.length > 100) {
      throw const AddFamilyMemberException(
        'Os nomes intermédios devem possuir no máximo 100 caracteres.',
      );
    }

    final preferredName = _nullableTrim(params.preferredName);

    if (preferredName != null && preferredName.length > 60) {
      throw const AddFamilyMemberException(
        'O nome preferido deve possuir no máximo 60 caracteres.',
      );
    }

    _validateDates(params);

    final biography = _nullableTrim(params.biography);

    if (biography != null && biography.length > 2000) {
      throw const AddFamilyMemberException(
        'A biografia deve possuir no máximo 2000 caracteres.',
      );
    }

    final occupation = _nullableTrim(params.occupation);

    if (occupation != null && occupation.length > 100) {
      throw const AddFamilyMemberException(
        'A profissão deve possuir no máximo 100 caracteres.',
      );
    }

    final email = _nullableTrim(params.email);

    if (email != null && !_isValidEmail(email)) {
      throw const AddFamilyMemberException('O endereço de email é inválido.');
    }

    final phone = _nullableTrim(params.phoneNumber);

    if (phone != null && !_isValidPhone(phone)) {
      throw const AddFamilyMemberException(
        'O número de telefone possui um formato inválido.',
      );
    }

    _validateRoleAndAccount(params);
    _validateMemberStatus(params);
  }

  void _validateDates(AddFamilyMemberParams params) {
    final now = DateTime.now();

    if (params.birthDate != null && params.birthDate!.isAfter(now)) {
      throw const AddFamilyMemberException(
        'A data de nascimento não pode estar no futuro.',
      );
    }

    if (params.deathDate != null && params.deathDate!.isAfter(now)) {
      throw const AddFamilyMemberException(
        'A data de falecimento não pode estar no futuro.',
      );
    }

    if (params.birthDate != null &&
        params.deathDate != null &&
        params.deathDate!.isBefore(params.birthDate!)) {
      throw const AddFamilyMemberException(
        'A data de falecimento não pode ser anterior à data de nascimento.',
      );
    }
  }

  void _validateRoleAndAccount(AddFamilyMemberParams params) {
    final userId = _nullableTrim(params.userId);

    final isAdministrativeRole =
        params.role == FamilyMemberRole.owner ||
        params.role == FamilyMemberRole.administrator ||
        params.role == FamilyMemberRole.editor;

    if (isAdministrativeRole && userId == null) {
      throw const AddFamilyMemberException(
        'Membros com funções administrativas devem estar ligados a uma conta.',
      );
    }

    if (params.role == FamilyMemberRole.owner && !params.isVerified) {
      throw const AddFamilyMemberException(
        'O proprietário da família deve possuir identidade verificada.',
      );
    }

    if (params.isFamilyRoot && params.role != FamilyMemberRole.owner) {
      throw const AddFamilyMemberException(
        'O primeiro membro da família deve possuir o papel de proprietário.',
      );
    }
  }

  void _validateMemberStatus(AddFamilyMemberParams params) {
    final hasDeathDate = params.deathDate != null;
    final isDeceasedStatus = params.status == FamilyMemberStatus.deceased;

    if (hasDeathDate && !isDeceasedStatus) {
      throw const AddFamilyMemberException(
        'Um membro com data de falecimento deve possuir o estado falecido.',
      );
    }

    if (isDeceasedStatus && !hasDeathDate) {
      throw const AddFamilyMemberException(
        'Informe a data de falecimento para membros falecidos.',
      );
    }

    if (isDeceasedStatus && _nullableTrim(params.userId) != null) {
      throw const AddFamilyMemberException(
        'Um membro falecido não pode permanecer ligado a uma conta ativa.',
      );
    }
  }

  String? _nullableTrim(String? value) {
    final normalized = value?.trim() ?? '';

    return normalized.isEmpty ? null : normalized;
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

class AddFamilyMemberParams {
  const AddFamilyMemberParams({
    required this.id,
    required this.familyId,
    required this.firstName,
    required this.lastName,
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

  final String id;
  final String familyId;
  final String? userId;

  final String firstName;
  final String? middleNames;
  final String lastName;
  final String? preferredName;

  final Gender gender;

  final DateTime? birthDate;
  final String? birthPlace;

  final DateTime? deathDate;
  final String? deathPlace;

  final String? biography;
  final String? occupation;

  final String? phoneNumber;
  final String? email;

  final String? photoUrl;
  final String? coverPhotoUrl;

  final FamilyMemberRole role;
  final FamilyMemberStatus status;

  final bool isFamilyRoot;
  final bool isProfilePrivate;
  final bool isVerified;

  final String createdBy;
}

class AddFamilyMemberException implements Exception {
  const AddFamilyMemberException(this.message);

  final String message;

  @override
  String toString() => message;
}
