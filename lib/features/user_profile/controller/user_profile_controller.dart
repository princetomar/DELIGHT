import 'dart:io';

import 'package:delight/core/enums/enums.dart';
import 'package:delight/features/auth/controllers/auth_controller.dart';
import 'package:delight/features/community/controller/community_controller.dart';
import 'package:delight/features/user_profile/repository/user_profile_repository.dart';
import 'package:delight/models/post_model.dart';
import 'package:delight/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final StorageRepository storageRepository =
      ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

// Provider to show all posts of a user
final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/profile', id: user.uid, file: profileFile);

      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(profilePic: r));
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/banner', id: user.uid, file: bannerFile);

      res.fold((l) => showSnackBar(context, l.message),
          (r) => user = user.copyWith(banner: r));
    }
    user = user.copyWith(name: name);
    final res = await _userProfileRepository.editProfile(user);

    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update(
            (state) => user,
          );
      showSnackBar(context, "User Profile edited successfully");
      Routemaster.of(context).pop();
    });
  }

  // To get all the posts of a user
  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);

    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold(
        (l) => null,
        (r) => _ref.read(userProvider.notifier).update(
              (state) => user,
            ));
  }
}
