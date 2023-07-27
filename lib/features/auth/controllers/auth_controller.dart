import 'package:delight/core/utils.dart';
import 'package:delight/features/auth/repository/auth_repository.dart';
import 'package:delight/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a provider for the User - userProvider
final userProvider = StateProvider<UserModel?>((ref) => null);

// Because we don't want to use the same instance of the auth_controller in the
// entire app whenever we want to access signInWithGoogle(), we use the factory constructor to create a new instance of the
// auth_controller every time we need it.

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

// This StateNotifier is similar to ChangeNotifier
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // represents the loading part

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  // Create a sign in with google function
  // And call the signInWithGoogle() function from the auth repository
  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    state = true;
    final user = await _authRepository.signInWithGoogle(isFromLogin);
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    // After we get the value, we set the state to false
    state = false;

    // In below line l=> failuer and r=> success
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() async {
    _authRepository.logOut();
  }

  void logOutAsGuest() async {
    _authRepository.logOutAsGuest();
  }
}
