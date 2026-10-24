import '../models/family_model.dart';
import '../../domain/entities/family_invite_entity.dart';
import '../../domain/entities/family_member_entity.dart';
import '../../domain/entities/family_relation_entity.dart';

abstract interface class FamilyRemoteDataSource {
  // ============================================================
  // FAMILY
  // ============================================================

  Future<FamilyModel?> getFamilyById(String familyId);

  Future<FamilyModel?> getFamilyByCode(String familyCode);

  Future<FamilyModel> createFamily(FamilyModel family);

  Future<bool> familyCodeExists(String familyCode);

  Future<bool> inviteCodeExists(String inviteCode);

  Future<FamilyModel> updateFamily(FamilyModel family);

  Future<void> deleteFamily(String familyId);

  // ============================================================
  // MEMBERS
  // ============================================================

  Future<FamilyMemberEntity?> getMemberById(String familyId, String memberId);

  Future<FamilyMemberEntity?> getMemberByUserId(String familyId, String userId);

  Future<List<FamilyMemberEntity>> getFamilyMembers(String familyId);

  Future<FamilyMemberEntity> addMember(FamilyMemberEntity member);

  Future<FamilyMemberEntity> updateFamilyMember(FamilyMemberEntity member);

  Future<void> removeFamilyMember(String familyId, String memberId);

  // ============================================================
  // RELATIONS
  // ============================================================

  Future<FamilyRelationEntity> createRelation(FamilyRelationEntity relation);

  Future<FamilyRelationEntity> updateFamilyRelation(
    FamilyRelationEntity relation,
  );

  Future<void> deleteFamilyRelation(String familyId, String relationId);

  Future<List<FamilyRelationEntity>> getFamilyRelations(String familyId);

  // ============================================================
  // INVITES
  // ============================================================

  Future<FamilyInviteEntity?> getInviteByCode(String code);

  Future<List<FamilyInviteEntity>> getFamilyInvites(String familyId);

  Future<FamilyInviteEntity> createFamilyInvite(FamilyInviteEntity invite);

  Future<FamilyInviteEntity> updateFamilyInvite(FamilyInviteEntity invite);

  Future<FamilyInviteEntity> acceptInvite({
    required String code,
    required String userId,
  });

  Future<void> cancelInvite(String code);
}
