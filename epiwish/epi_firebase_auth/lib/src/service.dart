import 'package:epi_firebase_auth/epi_firebase_auth.dart';
import 'package:epi_firebase_auth/src/functions.dart';
import 'package:epi_http/epi_http.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// This wrapper class is used to access the FirebaseAuth services
///
/// Use it by calling [EpiFirebaseAuth.instance]
/// For more information about the methods, check the [Functions] class
class EpiFirebaseAuth {
  // Singleton instance
  static EpiFirebaseAuth instance = EpiFirebaseAuth._();
  EpiFirebaseAuth._();

  // Private instance of FirebaseAuth
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// This will return a Stream<User?> object
  ///
  /// Use [authStateChanges] to listen to the auth state changes
  Stream<User?> get firebaseAuthStateChanges => firebaseAuth.authStateChanges();
  Stream<EpiUser?> get authStateChanges => firebaseAuthStateChanges.map((user) {
        return user != null ? EpiUser.fromFirebaseUser(user) : null;
      });

  /// Get the current logged in user from Firebase with [currentUser]
  User? get firebaseCurrentUser => firebaseAuth.currentUser;
  EpiUser? get currentUser => EpiUser.fromFirebaseUser(firebaseCurrentUser);

  Future<EpiResponse<UserCredential?>> signInWithEmailAndPassword({required String email, required String password}) =>
      Functions.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<EpiResponse<UserCredential?>> signUpWithEmailAndPassword({required String email, required String password}) =>
      Functions.instance.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

  Future<EpiResponse<void>> sendPasswordResetEmail({required String email}) => Functions.instance.sendPasswordResetEmail(email: email);

  Future<EpiResponse<UserCredential?>> signInAnonymously() => Functions.instance.signInAnonymously();

  Future<EpiResponse<void>> signOut() => Functions.instance.signOut();

  /// User Profile methods
  Future<EpiResponse<void>> updateDisplayName({required String displayName}) => Functions.instance.updateDisplayName(displayName: displayName);
  Future<EpiResponse<void>> updatePhotoURL({required String photoURL}) => Functions.instance.updatePhotoURL(photoURL: photoURL);
  Future<EpiResponse<void>> updateEmail({required String email}) => Functions.instance.updateEmail(email: email);
}
