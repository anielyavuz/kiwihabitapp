// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:intl/intl.dart';
import 'package:kiwihabitapp/services/firestoreClass.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Create or update user document (called after any sign-in method)
  Future<void> _createOrUpdateUserDoc(
    User firebaseUser,
    String registerType, {
    String? displayName,
  }) async {
    try {
      final docRef = _firestore.collection("Users").doc(firebaseUser.uid);
      final snap = await docRef.get();
      if (!snap.exists) {
        await docRef.set({
          "userName": displayName ?? firebaseUser.displayName ?? "KiWi User",
          "email": firebaseUser.email ?? "",
          "photoUrl": firebaseUser.photoURL ?? "",
          "registerType": registerType,
          "id": firebaseUser.uid,
          "createTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          "totalPoints": 0,
          "completedChallengesCount": 0,
          "activeChallengeIds": [],
          "badges": [],
        });
      }
    } catch (_) {
      // Firestore write failed — user is still authenticated, doc will be
      // created on next sign-in. Non-fatal, so we silently continue.
    }
  }

  // Google Sign In
  Future<String?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return "cancelled";
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      await _createOrUpdateUserDoc(result.user!, "Google");
      return null; // null = success
    } catch (e) {
      return e.toString();
    }
  }

  // Apple Sign In (iOS only)
  Future<String?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      final result = await _auth.signInWithCredential(oauthCredential);
      final displayName = [
        appleCredential.givenName,
        appleCredential.familyName,
      ].where((s) => s != null && s.isNotEmpty).join(' ');
      await _createOrUpdateUserDoc(
        result.user!,
        "Apple",
        displayName: displayName.isNotEmpty ? displayName : null,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Email Sign In
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found for this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        default:
          return 'Login failed. Please try again.';
      }
    }
  }

  // Email Sign Up
  Future<String?> createUserWithEmail(
    String email,
    String password,
    String userName,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _createOrUpdateUserDoc(result.user!, "Email", displayName: userName);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'An account already exists for this email.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';
        default:
          return 'Sign up failed. Please try again.';
      }
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _googleSignIn.signOut().catchError((_) => null);
    await _auth.signOut();
  }

  // Delete Account
  // Returns null on success, error string on failure.
  // For Email users, pass the current password; for Google/Apple, pass null.
  Future<String?> deleteAccount({String? password}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'Not authenticated';

      final providerId = user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : 'password';

      if (providerId == 'password') {
        if (password == null || password.isEmpty) return 'requires-password';
        final cred = EmailAuthProvider.credential(email: user.email!, password: password);
        await user.reauthenticateWithCredential(cred);
      } else if (providerId == 'google.com') {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return 'cancelled';
        final googleAuth = await googleUser.authentication;
        final cred = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await user.reauthenticateWithCredential(cred);
      } else if (providerId == 'apple.com') {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
        final oauthCred = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );
        await user.reauthenticateWithCredential(oauthCred);
      }

      // Delete all Firestore data before deleting the Auth user
      await ChallengeService().deleteUserAllData(user.uid);

      // Delete Firebase Auth user — authStateChanges() will navigate to LoginPage
      await user.delete();

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Incorrect password.';
      }
      if (e.code == 'requires-recent-login') {
        return 'Please sign in again and retry.';
      }
      return 'Delete failed: ${e.message}';
    } catch (e) {
      return e.toString();
    }
  }
}
