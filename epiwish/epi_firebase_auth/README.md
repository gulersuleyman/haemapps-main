# Epi Firebase Auth

Customized Firebase Auth package for easier use.

`epi_firebase_auth` uses `epi_http` package for creating responses.
For more info visit: [epi_http]

---

## Supported Features

| Feature               | Status  |
|-----------------------|---------|
| Email Sign in               |✔|
| Anonymous Sign in           |✔|
| Google Sign In              |⌛|
| Apple Sign In               |⌛|

## Usage

Create an instance

```dart
import 'package:epi_firebase_auth/epi_firebase_auth.dart';

final epiAuth = EpiFirebaseAuth.instance;
```

All methods returns a `EpiResponse`. You can use it simply like this:

```dart
void main() async {
  final EpiResponse response = await epiAuth.signInAnonymously();

  if (response.status == Status.success) {
    final user = response.data;
    // Do something with the user
    // ...
  } else if (response.status == Status.error) {
    final message = response.message;
    // Handle the error with message
    // ...
  } else {
    // Handle the unknown status
  }
}
```

## Sign-in with email

```dart
final EpiResponse response = await epiAuth.signInWithEmailAndPassword(email: 'email', password: 'password');
```

## Sign-up with email

```dart
final EpiResponse response = await epiAuth.signUpWithEmailAndPassword(email: 'email', password: 'password');
```

## Send password reset email
```dart
final EpiResponse response = await epiAuth.sendPasswordResetEmail(email: 'email');
```

## Sign-out

```dart
final EpiResponse response = await epiAuth.signOut();
```

## Listen auth state changes

You can get `authStateChanges` and use it with a StreamBuilder.

`EpiUser` is just a placeholder for User class in `firebase_auth`

```dart
final Stream<EpiUser?> authStateChanges = epiAuth.authStateChanges;
```

## Get current logged-in user

`EpiUser` is just a placeholder for User class in `firebase_auth`

```dart
final EpiUser? currentUser = epiAuth.currentUser;
```

## Update current user's displayName

```dart
final EpiResponse response = await epiAuth.updateDisplayName('newDisplayName');
```

## Update current user's photoURL

```dart
final EpiResponse response = await epiAuth.updatePhotoURL('img.com/epiwish.png');
```

## Update current user's email

```dart
final EpiResponse response = await epiAuth.updateEmail('emre@epiwish.com');
```

[epi_http]: /
