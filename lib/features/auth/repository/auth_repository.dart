import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delight/core/constants/constants.dart';
import 'package:delight/core/constants/firebase_constants.dart';
import 'package:delight/core/failure.dart';
import 'package:delight/core/providers/firebase_providers.dart';
import 'package:delight/core/type_def.dart';
import 'package:delight/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Create a provider for the auth repository
// This provider will be used to create a new instance of the auth repository
// every time we need it

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  FirebaseFirestore _firestore;
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  // To save userModel in Firestore
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.userCollection);

  // Creating a getter which is stream of user
  Stream<User?> get authStateChange => _auth.authStateChanges();

  // function to sign in with google
  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential;
      if (isFromLogin) {
        userCredential = await _auth.signInWithCredential(credential);
      } else {
        userCredential =
            await _auth.currentUser!.linkWithCredential(credential);
      }
      // We have the credentials now
      // Now store it and sign in with firebase

      late UserModel userModel;

      // If the user is new, then add it to the database
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user?.displayName ?? 'No name',
          profilePic: userCredential.user?.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user?.uid ?? '',
          isAuthenticated: true,
          karma: 0,
          awards: [
            'til',
            'gold',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'platinum',
            'awesomeAns'
          ],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        // If the user is not new, then get the data from the database
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel); // return the user model
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();
      late UserModel userModel;

      // If the user is new, then add it to the database

      userModel = UserModel(
        name: 'Guest',
        profilePic: userCredential.user?.photoURL ?? Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user?.uid ?? '',
        isAuthenticated: false,
        karma: 0,
        awards: [],
      );
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel); // return the user model
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  // function to get user data
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  // Function to log out
  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  void logOutAsGuest() async {
    await _auth.signOut();
  }
}
