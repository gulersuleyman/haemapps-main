import 'package:epi_firebase_auth/src/error_codes.dart';
import 'package:epi_http/epi_http.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Functions {
  static Functions instance = Functions._();
  Functions._();

  // Private instance of FirebaseAuth
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Get error message from FirebaseAuthException
  String getErrorMessage(FirebaseAuthException e) => errorMessages[e.code] ?? e.message ?? 'An unknown error occurred.';

  /// This will return a Future<EpiResponse> object
  ///
  /// Use [EpiResponse.data] to get UserCredential from Firebase
  Future<EpiResponse<UserCredential?>> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final UserCredential user = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return EpiResponse.success(
        user,
        message: 'Signed in successfully with $email',
      );
    } on FirebaseAuthException catch (e) {
      return EpiResponse.error(
        null,
        message: getErrorMessage(e),
      );
    } catch (e) {
      return EpiResponse.unknown(
        null,
        message: 'An unknown error occurred.',
      );
    }
  }

  /// This will return a Future<EpiResponse> object
  ///
  /// Use [EpiResponse.data] to get UserCredential from Firebase
  Future<EpiResponse<UserCredential?>> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      final UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return EpiResponse.success(
        user,
        message: 'Signed up successfully with $email',
      );
    } on FirebaseAuthException catch (e) {
      return EpiResponse.error(
        null,
        message: getErrorMessage(e),
      );
    } catch (e) {
      return EpiResponse.unknown(
        null,
        message: 'An unknown error occurred.',
      );
    }
  }

  /// This will return a Future<EpiResponse> object
  ///
  /// Use [EpiResponse.data] to get UserCredential from Firebase
  Future<EpiResponse<UserCredential?>> signInAnonymously() async {
    try {
      final UserCredential user = await firebaseAuth.signInAnonymously();
      return EpiResponse.success(
        user,
        message: 'Signed in anonymously',
      );
    } on FirebaseAuthException catch (e) {
      return EpiResponse.error(
        null,
        message: getErrorMessage(e),
      );
    } catch (e) {
      return EpiResponse.unknown(
        null,
        message: 'An unknown error occurred.',
      );
    }
  }

  /// Sign out the current user from Firebase
  Future<EpiResponse<void>> signOut() async {
    try {
      await firebaseAuth.signOut();
      return EpiResponse.success(
        null,
        message: 'Signed out successfully',
      );
    } on FirebaseAuthException catch (e) {
      return EpiResponse.error(
        null,
        message: getErrorMessage(e),
      );
    } catch (e) {
      return EpiResponse.error(
        null,
        message: 'An unknown error occurred.',
      );
    }
  }

  /// Update displayName of the current user
  Future<EpiResponse<void>> updateDisplayName({required String displayName}) async {
    try {
      await firebaseAuth.currentUser!.updateDisplayName(displayName);
      return EpiResponse.success(
        null,
        message: 'Display name updated successfully',
      );
    } on FirebaseAuthException catch (e) {
      return EpiResponse.error(
        null,
        message: getErrorMessage(e),
      );
    } catch (e) {
      return EpiResponse.unknown(
        null,
        message: 'An unknown error occurred.',
      );
    }
  }

  /// Update photoURL of the current user
  Future<EpiResponse<void>> updatePhotoURL({required String photoURL}) async {
    try {
      await firebaseAuth.currentUser!.updatePhotoURL(photoURL);
      return EpiResponse.success(
        null,
        message: 'Photo URL updated successfully',
      );
    } on FirebaseAuthException catch (e) {
      return EpiResponse.error(
        null,
        message: getErrorMessage(e),
      );
    } catch (e) {
      return EpiResponse.error(
        null,
        message: 'An unknown error occurred.',
      );
    }
  }

  /// Update email of the current user
  Future<EpiResponse<void>> updateEmail({required String email}) async {
    try {
      await firebaseAuth.currentUser!.verifyBeforeUpdateEmail(email);

      return EpiResponse.success(
        null,
        message: 'Email update request sent to $email. User must verify the new email address.',
      );
    } on FirebaseAuthException catch (e) {
      return EpiResponse.error(
        null,
        message: getErrorMessage(e),
      );
    } catch (e) {
      return EpiResponse.unknown(
        null,
        message: 'An unknown error occurred.',
      );
    }
  }

  // Send password reset email to specified email
  Future<EpiResponse<void>> sendPasswordResetEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return EpiResponse.success(
        null,
        message: 'Password reset email sent to $email',
      );
    } on FirebaseAuthException catch (e) {
      return EpiResponse.error(
        null,
        message: getErrorMessage(e),
      );
    } catch (e) {
      return EpiResponse.unknown(
        null,
        message: 'An unknown error occurred.',
      );
    }
  }
}
