import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/family_remote_datasource.dart';
import '../data/datasources/family_remote_datasource_impl.dart';
import '../data/repositories/family_repository_impl.dart';

import '../domain/repositories/family_repository.dart';

import '../domain/usecases/cancel_family_invite_usecase.dart';
import '../domain/usecases/create_family_invite_usecase.dart';
import '../domain/usecases/create_family_relation_usecase.dart';
import '../domain/usecases/create_family_usecase.dart';
import '../domain/usecases/delete_family_relation_usecase.dart';
import '../domain/usecases/delete_family_usecase.dart';
import '../domain/usecases/get_family_by_code_usecase.dart';
import '../domain/usecases/get_family_by_id_usecase.dart';
import '../domain/usecases/get_family_invites_usecase.dart';
import '../domain/usecases/get_family_member_usecase.dart';
import '../domain/usecases/get_family_members_usecase.dart';
import '../domain/usecases/get_family_relations_usecase.dart';
import '../domain/usecases/get_invite_by_code_usecase.dart';
import '../domain/usecases/get_member_by_user_id_usecase.dart';
import '../domain/usecases/remove_family_member_usecase.dart';
import '../domain/usecases/update_family_invite_usecase.dart';
import '../domain/usecases/update_family_member_usecase.dart';
import '../domain/usecases/update_family_relation_usecase.dart';
import '../domain/usecases/update_family_usecase.dart';
import '../domain/usecases/add_family_member_usecase.dart';

import '../presentation/controllers/family_setup_controller.dart';
import '../presentation/controllers/family_setup_state.dart';
// ============================================================
// FIREBASE
// ============================================================

final familyFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});


// ============================================================
// DATA SOURCE
// ============================================================

final familyRemoteDataSourceProvider =
    Provider<FamilyRemoteDataSource>((ref) {
  final firestore = ref.watch(familyFirestoreProvider);

  return FamilyRemoteDataSourceImpl(
    firestore: firestore,
  );
});


// ============================================================
// REPOSITORY
// ============================================================

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  final remoteDataSource = ref.watch(
    familyRemoteDataSourceProvider,
  );

  return FamilyRepositoryImpl(remoteDataSource);
});


// ============================================================
// FAMILY — USE CASES
// ============================================================

final createFamilyUseCaseProvider =
    Provider<CreateFamilyUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return CreateFamilyUseCase(repository);
});


final getFamilyByIdUseCaseProvider =
    Provider<GetFamilyByIdUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return GetFamilyByIdUseCase(repository);
});


final getFamilyByCodeUseCaseProvider =
    Provider<GetFamilyByCodeUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return GetFamilyByCodeUseCase(repository);
});


final updateFamilyUseCaseProvider =
    Provider<UpdateFamilyUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return UpdateFamilyUseCase(repository);
});


final deleteFamilyUseCaseProvider =
    Provider<DeleteFamilyUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return DeleteFamilyUseCase(repository);
});


// ============================================================
// MEMBERS — USE CASES
// ============================================================

final addFamilyMemberUseCaseProvider =
    Provider<AddFamilyMemberUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return AddFamilyMemberUseCase(repository);
});


final getFamilyMemberUseCaseProvider =
    Provider<GetFamilyMemberUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return GetFamilyMemberUseCase(repository);
});


final getFamilyMembersUseCaseProvider =
    Provider<GetFamilyMembersUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return GetFamilyMembersUseCase(repository);
});


final getMemberByUserIdUseCaseProvider =
    Provider<GetMemberByUserIdUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return GetMemberByUserIdUseCase(repository);
});


final updateFamilyMemberUseCaseProvider =
    Provider<UpdateFamilyMemberUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return UpdateFamilyMemberUseCase(repository);
});


final removeFamilyMemberUseCaseProvider =
    Provider<RemoveFamilyMemberUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return RemoveFamilyMemberUseCase(repository);
});


// ============================================================
// RELATIONS — USE CASES
// ============================================================

final createFamilyRelationUseCaseProvider =
    Provider<CreateFamilyRelationUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return CreateFamilyRelationUseCase(repository);
});


final getFamilyRelationsUseCaseProvider =
    Provider<GetFamilyRelationsUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return GetFamilyRelationsUseCase(repository);
});


final updateFamilyRelationUseCaseProvider =
    Provider<UpdateFamilyRelationUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return UpdateFamilyRelationUseCase(repository);
});


final deleteFamilyRelationUseCaseProvider =
    Provider<DeleteFamilyRelationUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return DeleteFamilyRelationUseCase(repository);
});


// ============================================================
// INVITES — USE CASES
// ============================================================

final createFamilyInviteUseCaseProvider =
    Provider<CreateFamilyInviteUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return CreateFamilyInviteUseCase(repository);
});


final getFamilyInvitesUseCaseProvider =
    Provider<GetFamilyInvitesUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return GetFamilyInvitesUseCase(repository);
});


final getInviteByCodeUseCaseProvider =
    Provider<GetInviteByCodeUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return GetInviteByCodeUseCase(repository);
});


final updateFamilyInviteUseCaseProvider =
    Provider<UpdateFamilyInviteUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return UpdateFamilyInviteUseCase(repository);
});


final cancelFamilyInviteUseCaseProvider =
    Provider<CancelFamilyInviteUseCase>((ref) {
  final repository = ref.watch(familyRepositoryProvider);

  return CancelFamilyInviteUseCase(repository);
});

// ============================================================
// FAMILY SETUP — CONTROLLER
// ============================================================

final familySetupControllerProvider = StateNotifierProvider<
    FamilySetupController,
    FamilySetupState>((ref) {
  final createFamilyUseCase = ref.watch(
    createFamilyUseCaseProvider,
  );

  return FamilySetupController(
    createFamilyUseCase,
  );
});