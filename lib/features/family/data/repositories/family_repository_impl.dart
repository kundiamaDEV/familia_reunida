import '../../domain/entities/family_entity.dart';
import '../../domain/entities/family_invite_entity.dart';
import '../../domain/entities/family_member_entity.dart';
import '../../domain/entities/family_relation_entity.dart';
import '../../domain/repositories/family_repository.dart';
import '../datasources/family_remote_datasource.dart';

import '../models/family_model.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  const FamilyRepositoryImpl(this._remoteDataSource);

  final FamilyRemoteDataSource _remoteDataSource;

  // ============================================================
  // FAMILY
  // ============================================================

  @override
  Future<FamilyEntity?> getFamilyById(String familyId) {
    return _remoteDataSource.getFamilyById(familyId);
  }

  @override
  Future<FamilyEntity?> getFamilyByCode(String familyCode) {
    return _remoteDataSource.getFamilyByCode(familyCode);
  }

  @override
  Future<FamilyEntity> createFamily(FamilyEntity family) {
    final model = family is FamilyModel
        ? family
        : FamilyModel.fromEntity(family);

    return _remoteDataSource.createFamily(model);
  }

  @override
  Future<bool> familyCodeExists(String familyCode) {
    return _remoteDataSource.familyCodeExists(familyCode);
  }

  @override
  Future<bool> inviteCodeExists(String inviteCode) {
    return _remoteDataSource.inviteCodeExists(inviteCode);
  }

  @override
  Future<FamilyEntity> updateFamily(FamilyEntity family) {
    final model = family is FamilyModel
        ? family
        : FamilyModel.fromEntity(family);

    return _remoteDataSource.updateFamily(model);
  }

  @override
  Future<void> deleteFamily(String familyId) {
    return _remoteDataSource.deleteFamily(familyId);
  }

  // ============================================================
  // MEMBERS
  // ============================================================

  @override
  Future<FamilyMemberEntity?> getMemberById(
    String familyId,
    String memberId,
  ) {
    return _remoteDataSource.getMemberById(
      familyId,
      memberId,
    );
  }

  @override
  Future<FamilyMemberEntity?> getMemberByUserId(
    String familyId,
    String userId,
  ) {
    return _remoteDataSource.getMemberByUserId(
      familyId,
      userId,
    );
  }

  @override
  Future<List<FamilyMemberEntity>> getFamilyMembers(
    String familyId,
  ) {
    return _remoteDataSource.getFamilyMembers(familyId);
  }

  @override
  Future<FamilyMemberEntity> addFamilyMember(
    FamilyMemberEntity member,
  ) {
    return _remoteDataSource.addMember(member);
  }

  @override
  Future<FamilyMemberEntity> addMember(
    FamilyMemberEntity member,
  ) {
    return _remoteDataSource.addMember(member);
  }

  @override
  Future<FamilyMemberEntity> updateFamilyMember(
    FamilyMemberEntity member,
  ) {
    return _remoteDataSource.updateFamilyMember(member);
  }

  @override
  Future<void> removeFamilyMember(
    String familyId,
    String memberId,
  ) {
    return _remoteDataSource.removeFamilyMember(
      familyId,
      memberId,
    );
  }

  // ============================================================
  // RELATIONS
  // ============================================================

  @override
  Future<FamilyRelationEntity> createFamilyRelation(
    FamilyRelationEntity relation,
  ) {
    return _remoteDataSource.createRelation(relation);
  }

  Future<FamilyRelationEntity> createRelation(
    FamilyRelationEntity relation,
  ) {
    return _remoteDataSource.createRelation(relation);
  }

  @override
  Future<FamilyRelationEntity> updateFamilyRelation(
    FamilyRelationEntity relation,
  ) {
    return _remoteDataSource.updateFamilyRelation(relation);
  }

  @override
  Future<void> deleteFamilyRelation(
    String familyId,
    String relationId,
  ) {
    return _remoteDataSource.deleteFamilyRelation(
      familyId,
      relationId,
    );
  }

  @override
  Future<List<FamilyRelationEntity>> getFamilyRelations(
    String familyId,
  ) {
    return _remoteDataSource.getFamilyRelations(familyId);
  }

  // ============================================================
  // INVITES
  // ============================================================

  @override
  Future<FamilyInviteEntity?> getInviteByCode(String code) {
    return _remoteDataSource.getInviteByCode(code);
  }

  @override
  Future<List<FamilyInviteEntity>> getFamilyInvites(
    String familyId,
  ) {
    return _remoteDataSource.getFamilyInvites(familyId);
  }

  @override
  Future<FamilyInviteEntity> createFamilyInvite(
    FamilyInviteEntity invite,
  ) {
    return _remoteDataSource.createFamilyInvite(invite);
  }

  @override
  Future<FamilyInviteEntity> updateFamilyInvite(
    FamilyInviteEntity invite,
  ) {
    return _remoteDataSource.updateFamilyInvite(invite);
  }

  @override
  Future<FamilyInviteEntity> acceptInvite({
    required String code,
    required String userId,
  }) {
    return _remoteDataSource.acceptInvite(
      code: code,
      userId: userId,
    );
  }

  @override
  Future<void> cancelInvite(String code) {
    return _remoteDataSource.cancelInvite(code);
  }
}