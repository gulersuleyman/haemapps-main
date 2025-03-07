import 'package:firebase_auth/firebase_auth.dart';

class EpiUser {
  final String? displayName;
  final String? email;
  final bool emailVerified;
  final bool isAnonymous;
  final String? phoneNumber;
  final String? photoURL;
  final String? refreshToken;
  final String uid;

  EpiUser({
    this.displayName,
    this.email,
    this.emailVerified = false,
    this.isAnonymous = false,
    this.phoneNumber,
    this.photoURL,
    this.refreshToken,
    required this.uid,
  });

  static EpiUser? fromFirebaseUser(User? user) {
    if (user == null) return null;

    return EpiUser(
      displayName: user.displayName,
      email: user.email,
      emailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL,
      refreshToken: user.refreshToken,
      uid: user.uid,
    );
  }
}
