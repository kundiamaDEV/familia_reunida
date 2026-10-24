import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/family_invite_entity.dart';
import '../../domain/entities/family_member_entity.dart';
import '../../domain/entities/family_relation_entity.dart';
import '../models/family_member_model.dart';
import '../models/family_model.dart';
import 'family_remote_datasource.dart';
import '../models/family_relation_model.dart';
import '../models/family_invite_model.dart';

class FamilyRemoteDataSourceImpl implements FamilyRemoteDataSource {
  FamilyRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _familiesCollection = 'families';
  static const String _membersCollection = 'members';
  static const String _invitesCollection = 'family_invites';

  CollectionReference<Map<String, dynamic>> get _families =>
      _firestore.collection(_familiesCollection);

  CollectionReference<Map<String, dynamic>> get _invites =>
    _firestore.collection(_invitesCollection);

  CollectionReference<Map<String, dynamic>> _members(String familyId) {
    return _families.doc(familyId).collection(_membersCollection);
  }

  

  // ============================================================
  // FAMILY
  // ============================================================

  @override
  Future<FamilyModel?> getFamilyById(String familyId) async {
    final normalizedId = familyId.trim();

    if (normalizedId.isEmpty) {
      return null;
    }

    final snapshot = await _families.doc(normalizedId).get();

    if (!snapshot.exists) {
      return null;
    }

    final data = snapshot.data();

    if (data == null) {
      return null;
    }

    return FamilyModel.fromMap({...data, 'id': snapshot.id});
  }

  @override
  Future<FamilyModel?> getFamilyByCode(String familyCode) async {
    final normalizedCode = familyCode.trim().toUpperCase();

    if (normalizedCode.isEmpty) {
      return null;
    }

    final snapshot = await _families
        .where('familyCode', isEqualTo: normalizedCode)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final document = snapshot.docs.first;

    return FamilyModel.fromMap({...document.data(), 'id': document.id});
  }

  @override
  Future<FamilyModel> createFamily(FamilyModel family) async {
    final familyId = family.id.trim();

    if (familyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    final familyCode = family.familyCode.trim().toUpperCase();
    final inviteCode = family.inviteCode.trim().toUpperCase();

    if (familyCode.isEmpty) {
      throw ArgumentError('O código da família é obrigatório.');
    }

    if (inviteCode.isEmpty) {
      throw ArgumentError('O código de convite é obrigatório.');
    }

    if (await familyCodeExists(familyCode)) {
      throw StateError('O código da família já está em utilização.');
    }

    if (await inviteCodeExists(inviteCode)) {
      throw StateError('O código de convite já está em utilização.');
    }

    final data = family.toMap();

    data['familyCode'] = familyCode;
    data['inviteCode'] = inviteCode;

    await _families.doc(familyId).set(data);

    return FamilyModel.fromMap({...data, 'id': familyId});
  }

  @override
  Future<bool> familyCodeExists(String familyCode) async {
    final normalizedCode = familyCode.trim().toUpperCase();

    if (normalizedCode.isEmpty) {
      return false;
    }

    final snapshot = await _families
        .where('familyCode', isEqualTo: normalizedCode)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<bool> inviteCodeExists(String inviteCode) async {
    final normalizedCode = inviteCode.trim().toUpperCase();

    if (normalizedCode.isEmpty) {
      return false;
    }

    final snapshot = await _families
        .where('inviteCode', isEqualTo: normalizedCode)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<FamilyModel> updateFamily(FamilyModel family) async {
    final familyId = family.id.trim();

    if (familyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    final existing = await _families.doc(familyId).get();

    if (!existing.exists) {
      throw StateError('A família não foi encontrada.');
    }

    final data = family.toMap();

    data['familyCode'] = family.familyCode.trim().toUpperCase();

    data['inviteCode'] = family.inviteCode.trim().toUpperCase();

    await _families.doc(familyId).update(data);

    return FamilyModel.fromMap({...data, 'id': familyId});
  }

  @override
  Future<void> deleteFamily(String familyId) async {
    final normalizedId = familyId.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    await _families.doc(normalizedId).delete();
  }

  // ============================================================
  // MEMBERS
  // ============================================================

  @override
  Future<List<FamilyMemberEntity>> getFamilyMembers(String familyId) async {
    final normalizedFamilyId = familyId.trim();

    if (normalizedFamilyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    final snapshot = await _members(
      normalizedFamilyId,
    ).orderBy('createdAt').get();

    return snapshot.docs
        .map<FamilyMemberEntity>(FamilyMemberModel.fromFirestore)
        .toList(growable: false);
  }

  @override
  Future<FamilyMemberEntity?> getMemberById(
    String familyId,
    String memberId,
  ) async {
    final normalizedFamilyId = familyId.trim();
    final normalizedMemberId = memberId.trim();

    if (normalizedFamilyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    if (normalizedMemberId.isEmpty) {
      throw ArgumentError('O ID do membro é obrigatório.');
    }

    final snapshot = await _members(
      normalizedFamilyId,
    ).doc(normalizedMemberId).get();

    if (!snapshot.exists) {
      return null;
    }

    return FamilyMemberModel.fromFirestore(snapshot);
  }

  @override
  Future<FamilyMemberEntity?> getMemberByUserId(
    String familyId,
    String userId,
  ) async {
    final normalizedFamilyId = familyId.trim();
    final normalizedUserId = userId.trim();

    if (normalizedFamilyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    if (normalizedUserId.isEmpty) {
      throw ArgumentError('O ID do utilizador é obrigatório.');
    }

    final snapshot = await _members(
      normalizedFamilyId,
    ).where('userId', isEqualTo: normalizedUserId).limit(1).get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return FamilyMemberModel.fromFirestore(snapshot.docs.first);
  }

  @override
  Future<FamilyMemberEntity> addMember(FamilyMemberEntity member) async {
    final familyId = member.familyId.trim();
    final memberId = member.id.trim();

    if (familyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    if (memberId.isEmpty) {
      throw ArgumentError('O ID do membro é obrigatório.');
    }

    final memberReference = _members(familyId).doc(memberId);

    final existing = await memberReference.get();

    if (existing.exists) {
      throw StateError('Já existe um membro com este identificador.');
    }

    final model = FamilyMemberModel(
      id: memberId,
      familyId: familyId,
      userId: member.userId,
      firstName: member.firstName,
      middleNames: member.middleNames,
      lastName: member.lastName,
      preferredName: member.preferredName,
      gender: member.gender,
      birthDate: member.birthDate,
      birthPlace: member.birthPlace,
      deathDate: member.deathDate,
      deathPlace: member.deathPlace,
      biography: member.biography,
      occupation: member.occupation,
      phoneNumber: member.phoneNumber,
      email: member.email,
      photoUrl: member.photoUrl,
      coverPhotoUrl: member.coverPhotoUrl,
      role: member.role,
      status: member.status,
      isFamilyRoot: member.isFamilyRoot,
      isProfilePrivate: member.isProfilePrivate,
      isVerified: member.isVerified,
      createdAt: member.createdAt,
      updatedAt: member.updatedAt,
      createdBy: member.createdBy,
    );

    await memberReference.set(model.toFirestore());

    return model;
  }

  @override
  Future<FamilyMemberEntity> updateFamilyMember(
    FamilyMemberEntity member,
  ) async {
    final familyId = member.familyId.trim();
    final memberId = member.id.trim();

    if (familyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    if (memberId.isEmpty) {
      throw ArgumentError('O ID do membro é obrigatório.');
    }

    final memberReference = _members(familyId).doc(memberId);

    final existing = await memberReference.get();

    if (!existing.exists) {
      throw StateError('O membro da família não foi encontrado.');
    }

    final model = FamilyMemberModel(
      id: memberId,
      familyId: familyId,
      userId: member.userId,
      firstName: member.firstName,
      middleNames: member.middleNames,
      lastName: member.lastName,
      preferredName: member.preferredName,
      gender: member.gender,
      birthDate: member.birthDate,
      birthPlace: member.birthPlace,
      deathDate: member.deathDate,
      deathPlace: member.deathPlace,
      biography: member.biography,
      occupation: member.occupation,
      phoneNumber: member.phoneNumber,
      email: member.email,
      photoUrl: member.photoUrl,
      coverPhotoUrl: member.coverPhotoUrl,
      role: member.role,
      status: member.status,
      isFamilyRoot: member.isFamilyRoot,
      isProfilePrivate: member.isProfilePrivate,
      isVerified: member.isVerified,
      createdAt: member.createdAt,
      updatedAt: member.updatedAt,
      createdBy: member.createdBy,
    );

    await memberReference.update(model.toFirestore());

    return model;
  }

  @override
  Future<void> removeFamilyMember(String familyId, String memberId) async {
    final normalizedFamilyId = familyId.trim();
    final normalizedMemberId = memberId.trim();

    if (normalizedFamilyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    if (normalizedMemberId.isEmpty) {
      throw ArgumentError('O ID do membro é obrigatório.');
    }

    final memberReference = _members(
      normalizedFamilyId,
    ).doc(normalizedMemberId);

    final existing = await memberReference.get();

    if (!existing.exists) {
      throw StateError('O membro da família não foi encontrado.');
    }

    await memberReference.delete();
  }

    // ============================================================
  // RELATIONS
  // ============================================================

  CollectionReference<Map<String, dynamic>> _relations(
    String familyId,
  ) {
    return _families.doc(familyId).collection('relations');
  }

  @override
  Future<FamilyRelationEntity> createRelation(
    FamilyRelationEntity relation,
  ) async {
    final familyId = relation.familyId.trim();
    final relationId = relation.id.trim();
    final personAId = relation.personAId.trim();
    final personBId = relation.personBId.trim();

    if (familyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    if (relationId.isEmpty) {
      throw ArgumentError('O ID da relação é obrigatório.');
    }

    if (personAId.isEmpty || personBId.isEmpty) {
      throw ArgumentError(
        'Os dois membros da relação são obrigatórios.',
      );
    }

    if (personAId == personBId) {
      throw ArgumentError(
        'Uma pessoa não pode possuir uma relação consigo mesma.',
      );
    }

    final membersCollection = _families.doc(familyId).collection('members');

    final personA = await membersCollection.doc(personAId).get();
    final personB = await membersCollection.doc(personBId).get();

    if (!personA.exists || !personB.exists) {
      throw StateError(
        'Os membros da relação devem pertencer à família.',
      );
    }

    final relationReference = _relations(familyId).doc(relationId);

    final existing = await relationReference.get();

    if (existing.exists) {
      throw StateError(
        'Já existe uma relação com este identificador.',
      );
    }

    final model = relation is FamilyRelationModel
        ? relation
        : FamilyRelationModel(
            id: relation.id,
            familyId: relation.familyId,
            personAId: relation.personAId,
            personBId: relation.personBId,
            type: relation.type,
            status: relation.status,
            startDate: relation.startDate,
            endDate: relation.endDate,
            notes: relation.notes,
            isBiological: relation.isBiological,
            isPrimary: relation.isPrimary,
            createdAt: relation.createdAt,
            updatedAt: relation.updatedAt,
            createdBy: relation.createdBy,
          );

    await relationReference.set(model.toFirestore());

    return model;
  }

  @override
  Future<FamilyRelationEntity> updateFamilyRelation(
    FamilyRelationEntity relation,
  ) async {
    final familyId = relation.familyId.trim();
    final relationId = relation.id.trim();

    if (familyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    if (relationId.isEmpty) {
      throw ArgumentError('O ID da relação é obrigatório.');
    }

    final relationReference = _relations(familyId).doc(relationId);

    final existing = await relationReference.get();

    if (!existing.exists) {
      throw StateError('A relação não foi encontrada.');
    }

    final model = relation is FamilyRelationModel
        ? relation
        : FamilyRelationModel(
            id: relation.id,
            familyId: relation.familyId,
            personAId: relation.personAId,
            personBId: relation.personBId,
            type: relation.type,
            status: relation.status,
            startDate: relation.startDate,
            endDate: relation.endDate,
            notes: relation.notes,
            isBiological: relation.isBiological,
            isPrimary: relation.isPrimary,
            createdAt: relation.createdAt,
            updatedAt: relation.updatedAt,
            createdBy: relation.createdBy,
          );

    await relationReference.update(model.toFirestore());

    return model;
  }

  @override
  Future<void> deleteFamilyRelation(
    String familyId,
    String relationId,
  ) async {
    final normalizedFamilyId = familyId.trim();
    final normalizedRelationId = relationId.trim();

    if (normalizedFamilyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    if (normalizedRelationId.isEmpty) {
      throw ArgumentError('O ID da relação é obrigatório.');
    }

    final relationReference = _relations(
      normalizedFamilyId,
    ).doc(normalizedRelationId);

    final existing = await relationReference.get();

    if (!existing.exists) {
      throw StateError('A relação não foi encontrada.');
    }

    await relationReference.delete();
  }

  @override
  Future<List<FamilyRelationEntity>> getFamilyRelations(
    String familyId,
  ) async {
    final normalizedFamilyId = familyId.trim();

    if (normalizedFamilyId.isEmpty) {
      return <FamilyRelationEntity>[];
    }

    final snapshot = await _relations(
      normalizedFamilyId,
    ).get();

    return snapshot.docs
        .map(FamilyRelationModel.fromFirestore)
        .toList(growable: false);
  }

    // ============================================================
  // INVITES
  // ============================================================

  @override
  Future<FamilyInviteEntity?> getInviteByCode(String code) async {
    final normalizedCode = code.trim().toUpperCase();

    if (normalizedCode.isEmpty) {
      return null;
    }

    final snapshot = await _invites
        .where('code', isEqualTo: normalizedCode)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return FamilyInviteModel.fromFirestore(snapshot.docs.first);
  }

  @override
  Future<List<FamilyInviteEntity>> getFamilyInvites(
    String familyId,
  ) async {
    final normalizedFamilyId = familyId.trim();

    if (normalizedFamilyId.isEmpty) {
      return const [];
    }

    final snapshot = await _invites
        .where('familyId', isEqualTo: normalizedFamilyId)
        .get();

    return snapshot.docs
        .map(FamilyInviteModel.fromFirestore)
        .toList();
  }

  @override
  Future<FamilyInviteEntity> createFamilyInvite(
    FamilyInviteEntity invite,
  ) async {
    final inviteId = invite.id.trim();
    final familyId = invite.familyId.trim();
    final code = invite.code.trim().toUpperCase();

    if (inviteId.isEmpty) {
      throw ArgumentError('O ID do convite é obrigatório.');
    }

    if (familyId.isEmpty) {
      throw ArgumentError('O ID da família é obrigatório.');
    }

    if (code.isEmpty) {
      throw ArgumentError('O código do convite é obrigatório.');
    }

    final existingInvite = await getInviteByCode(code);

    if (existingInvite != null &&
        existingInvite.status != FamilyInviteStatus.cancelled &&
        existingInvite.status != FamilyInviteStatus.expired) {
      throw StateError('O código do convite já está em utilização.');
    }

    final model = FamilyInviteModel(
      id: inviteId,
      familyId: familyId,
      code: code,
      recipientName: invite.recipientName,
      recipientPhone: invite.recipientPhone,
      recipientEmail: invite.recipientEmail,
      recipientUserId: invite.recipientUserId,
      createdBy: invite.createdBy,
      acceptedBy: invite.acceptedBy,
      roleToAssign: invite.roleToAssign,
      channel: invite.channel,
      status: invite.status,
      message: invite.message,
      maxUses: invite.maxUses,
      usedCount: invite.usedCount,
      requiresApproval: invite.requiresApproval,
      createdAt: invite.createdAt,
      expiresAt: invite.expiresAt,
      acceptedAt: invite.acceptedAt,
      cancelledAt: invite.cancelledAt,
      rejectedAt: invite.rejectedAt,
    );

    await _invites.doc(inviteId).set(model.toFirestore());

    return model;
  }

  @override
  Future<FamilyInviteEntity> updateFamilyInvite(
    FamilyInviteEntity invite,
  ) async {
    final inviteId = invite.id.trim();

    if (inviteId.isEmpty) {
      throw ArgumentError('O ID do convite é obrigatório.');
    }

    final document = _invites.doc(inviteId);
    final existing = await document.get();

    if (!existing.exists) {
      throw StateError('O convite não foi encontrado.');
    }

    final model = FamilyInviteModel(
      id: inviteId,
      familyId: invite.familyId.trim(),
      code: invite.code.trim().toUpperCase(),
      recipientName: invite.recipientName,
      recipientPhone: invite.recipientPhone,
      recipientEmail: invite.recipientEmail,
      recipientUserId: invite.recipientUserId,
      createdBy: invite.createdBy,
      acceptedBy: invite.acceptedBy,
      roleToAssign: invite.roleToAssign,
      channel: invite.channel,
      status: invite.status,
      message: invite.message,
      maxUses: invite.maxUses,
      usedCount: invite.usedCount,
      requiresApproval: invite.requiresApproval,
      createdAt: invite.createdAt,
      expiresAt: invite.expiresAt,
      acceptedAt: invite.acceptedAt,
      cancelledAt: invite.cancelledAt,
      rejectedAt: invite.rejectedAt,
    );

    await document.update(model.toFirestore());

    return model;
  }

  @override
  Future<FamilyInviteEntity> acceptInvite({
    required String code,
    required String userId,
  }) async {
    final normalizedCode = code.trim().toUpperCase();
    final normalizedUserId = userId.trim();

    if (normalizedCode.isEmpty) {
      throw ArgumentError('O código do convite é obrigatório.');
    }

    if (normalizedUserId.isEmpty) {
      throw ArgumentError('O ID do utilizador é obrigatório.');
    }

    final snapshot = await _invites
        .where('code', isEqualTo: normalizedCode)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw StateError('Convite não encontrado.');
    }

    final document = snapshot.docs.first;
    final invite = FamilyInviteModel.fromFirestore(document);

    if (!invite.canBeUsed) {
      throw StateError(
        'Este convite não está disponível para utilização.',
      );
    }

    final now = DateTime.now();

    final updatedInvite = invite.copyWith(
      status: FamilyInviteStatus.accepted,
      acceptedBy: normalizedUserId,
      acceptedAt: now,
      usedCount: invite.usedCount + 1,
    );

    final model = FamilyInviteModel(
      id: updatedInvite.id,
      familyId: updatedInvite.familyId,
      code: updatedInvite.code,
      recipientName: updatedInvite.recipientName,
      recipientPhone: updatedInvite.recipientPhone,
      recipientEmail: updatedInvite.recipientEmail,
      recipientUserId: updatedInvite.recipientUserId,
      createdBy: updatedInvite.createdBy,
      acceptedBy: updatedInvite.acceptedBy,
      roleToAssign: updatedInvite.roleToAssign,
      channel: updatedInvite.channel,
      status: updatedInvite.status,
      message: updatedInvite.message,
      maxUses: updatedInvite.maxUses,
      usedCount: updatedInvite.usedCount,
      requiresApproval: updatedInvite.requiresApproval,
      createdAt: updatedInvite.createdAt,
      expiresAt: updatedInvite.expiresAt,
      acceptedAt: updatedInvite.acceptedAt,
      cancelledAt: updatedInvite.cancelledAt,
      rejectedAt: updatedInvite.rejectedAt,
    );

    await document.reference.update({
  'status': FamilyInviteStatus.cancelled.name,
});

    return model;
  }

  @override
  Future<void> cancelInvite(String code) async {
    final normalizedCode = code.trim().toUpperCase();

    if (normalizedCode.isEmpty) {
      throw ArgumentError('O código do convite é obrigatório.');
    }

    final snapshot = await _invites
        .where('code', isEqualTo: normalizedCode)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw StateError('Convite não encontrado.');
    }

    final document = snapshot.docs.first;
    final invite = FamilyInviteModel.fromFirestore(document);

    if (invite.isAccepted) {
      throw StateError(
        'Um convite já aceite não pode ser cancelado.',
      );
    }

    if (invite.isCancelled) {
      return;
    }

    await document.reference.update({
  'status': FamilyInviteStatus.cancelled.name,
});
  }

}