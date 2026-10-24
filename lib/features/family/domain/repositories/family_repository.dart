import '../entities/family_entity.dart';
import '../entities/family_invite_entity.dart';
import '../entities/family_member_entity.dart';
import '../entities/family_relation_entity.dart';

abstract interface class FamilyRepository {
  // ============================================================
  // FAMILY
  // ============================================================

  Future<FamilyEntity?> getFamilyById(String familyId);

  Future<FamilyEntity?> getFamilyByCode(String familyCode);

  Future<FamilyEntity> createFamily(FamilyEntity family);

  Future<bool> familyCodeExists(String familyCode);

  Future<bool> inviteCodeExists(String inviteCode);

  Future<FamilyEntity> updateFamily(FamilyEntity family);

  Future<void> deleteFamily(String familyId);

  // ============================================================
  // MEMBERS
  // ============================================================

  Future<FamilyMemberEntity?> getMemberById(String familyId, String memberId);

  Future<FamilyMemberEntity?> getMemberByUserId(String familyId, String userId);

  Future<List<FamilyMemberEntity>> getFamilyMembers(String familyId);

  Future<FamilyMemberEntity> addFamilyMember(FamilyMemberEntity member);

  Future<FamilyMemberEntity> addMember(FamilyMemberEntity member);

  Future<FamilyMemberEntity> updateFamilyMember(FamilyMemberEntity member);

  Future<void> removeFamilyMember(String familyId, String memberId);

  // ============================================================
  // RELATIONS
  // ============================================================

  Future<FamilyRelationEntity> createFamilyRelation(
    FamilyRelationEntity relation,
  );

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
