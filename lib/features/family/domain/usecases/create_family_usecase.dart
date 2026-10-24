import '../entities/family_entity.dart';
import '../repositories/family_repository.dart';

class CreateFamilyUseCase {
  const CreateFamilyUseCase(this._repository);

  final FamilyRepository _repository;

  Future<FamilyEntity> call(CreateFamilyParams params) async {
    _validateParams(params);

    final normalizedFamilyCode = _normalizeCode(params.familyCode);

    final normalizedInviteCode = _normalizeCode(params.inviteCode);

    final familyCodeAlreadyExists = await _repository.familyCodeExists(
      normalizedFamilyCode,
    );

    if (familyCodeAlreadyExists) {
      throw const CreateFamilyException(
        'O código da família já está em utilização.',
      );
    }

    final inviteCodeAlreadyExists = await _repository.inviteCodeExists(
      normalizedInviteCode,
    );

    if (inviteCodeAlreadyExists) {
      throw const CreateFamilyException(
        'O código de convite já está em utilização.',
      );
    }

    final now = DateTime.now();

    final family = FamilyEntity(
      id: params.id.trim(),
      officialName: params.officialName.trim(),
      shortName: params.shortName.trim(),
      nickname: _nullableTrim(params.nickname),
      country: params.country.trim(),
      province: _nullableTrim(params.province),
      description: _nullableTrim(params.description),
      createdAt: now,
      updatedAt: now,
      createdBy: params.createdBy.trim(),
      photoUrl: _nullableTrim(params.photoUrl),
      coverPhotoUrl: _nullableTrim(params.coverPhotoUrl),
      familyCode: normalizedFamilyCode,
      inviteCode: normalizedInviteCode,
      membersCount: 1,
      treeVersion: 1,
      settings: params.settings,
      status: FamilyStatus.active,
    );

    return _repository.createFamily(family);
  }

  void _validateParams(CreateFamilyParams params) {
    if (params.id.trim().isEmpty) {
      throw const CreateFamilyException(
        'O identificador da família é obrigatório.',
      );
    }

    if (params.createdBy.trim().isEmpty) {
      throw const CreateFamilyException(
        'O utilizador responsável é obrigatório.',
      );
    }

    final officialName = params.officialName.trim();

    if (officialName.isEmpty) {
      throw const CreateFamilyException(
        'O nome oficial da família é obrigatório.',
      );
    }

    if (officialName.length < 4) {
      throw const CreateFamilyException(
        'O nome oficial deve possuir pelo menos 4 caracteres.',
      );
    }

    if (officialName.length > 100) {
      throw const CreateFamilyException(
        'O nome oficial deve possuir no máximo 100 caracteres.',
      );
    }

    final shortName = params.shortName.trim();

    if (shortName.isEmpty) {
      throw const CreateFamilyException(
        'O nome curto da família é obrigatório.',
      );
    }

    if (shortName.length < 2) {
      throw const CreateFamilyException(
        'O nome curto deve possuir pelo menos 2 caracteres.',
      );
    }

    if (shortName.length > 20) {
      throw const CreateFamilyException(
        'O nome curto deve possuir no máximo 20 caracteres.',
      );
    }

    if (params.country.trim().isEmpty) {
      throw const CreateFamilyException(
        'O país de origem ou referência é obrigatório.',
      );
    }

    if (params.country.trim().toLowerCase() == 'angola' &&
        _nullableTrim(params.province) == null) {
      throw const CreateFamilyException(
        'A província de referência é obrigatória para famílias de Angola.',
      );
    }

    final nickname = _nullableTrim(params.nickname);

    if (nickname != null && nickname.length > 30) {
      throw const CreateFamilyException(
        'O apelido familiar deve possuir no máximo 30 caracteres.',
      );
    }

    final description = _nullableTrim(params.description);

    if (description != null && description.length > 300) {
      throw const CreateFamilyException(
        'A descrição deve possuir no máximo 300 caracteres.',
      );
    }

    final familyCode = _normalizeCode(params.familyCode);

    if (!_isValidCode(familyCode)) {
      throw const CreateFamilyException(
        'O código da família possui um formato inválido.',
      );
    }

    final inviteCode = _normalizeCode(params.inviteCode);

    if (!_isValidCode(inviteCode)) {
      throw const CreateFamilyException(
        'O código de convite possui um formato inválido.',
      );
    }

    if (familyCode == inviteCode) {
      throw const CreateFamilyException(
        'O código da família e o código de convite devem ser diferentes.',
      );
    }
  }

  String _normalizeCode(String value) {
    return value.trim().toUpperCase();
  }

  String? _nullableTrim(String? value) {
    final normalized = value?.trim() ?? '';

    return normalized.isEmpty ? null : normalized;
  }

  bool _isValidCode(String value) {
    return RegExp(r'^[A-Z0-9]+(?:-[A-Z0-9]+)*$').hasMatch(value);
  }
}

class CreateFamilyParams {
  const CreateFamilyParams({
    required this.id,
    required this.officialName,
    required this.shortName,
    required this.country,
    required this.createdBy,
    required this.familyCode,
    required this.inviteCode,
    this.nickname,
    this.province,
    this.description,
    this.photoUrl,
    this.coverPhotoUrl,
    this.settings = const FamilySettings(),
  });

  final String id;
  final String officialName;
  final String shortName;
  final String? nickname;
  final String country;
  final String? province;
  final String? description;
  final String createdBy;
  final String? photoUrl;
  final String? coverPhotoUrl;
  final String familyCode;
  final String inviteCode;
  final FamilySettings settings;
}

class CreateFamilyException implements Exception {
  const CreateFamilyException(this.message);

  final String message;

  @override
  String toString() => message;
}
