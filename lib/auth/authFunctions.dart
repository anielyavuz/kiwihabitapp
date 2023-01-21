import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        print("Kkkkkkkkkk");
        final fullName = appleIdCredential.fullName;

        print('${fullName?.givenName} ${fullName?.familyName}');
        return credential;
        final userCredential = await _auth.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
      //   return firebaseUser;
      // case AuthorizationStatus.error:
      //   throw PlatformException(
      //     code: 'ERROR_AUTHORIZATION_DENIED',
      //     message: result.error.toString(),
      //   );

      // case AuthorizationStatus.cancelled:
      //   throw PlatformException(
      //     code: 'ERROR_ABORTED_BY_USER',
      //     message: 'Sign in aborted by user',
      //   );
      // default:
      //   throw UnimplementedError();
    }
  }

  Future<Map> anonymSignIn() async {
    Map returnCode = {};
    try {
      var user = await _auth.signInAnonymously();

      await _firestore.collection("Users").doc(user.user!.uid).set({
        "userName": "Guest",
        "email": "",
        "photoUrl": "",
        "registerType": "Anonym",
        "id": user.user!.uid,
        "userAuth": "Prod",
        "userSubscription": "Free",
        "createTime":
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString(),
        "yourHabits": [],
        "habitDetails": [],
        "habitDays": [],
        "completedHabits": {},
        "finalCompleted": {},
      });
    } on FirebaseAuthException catch (e) {
      returnCode['status'] = false;
      returnCode['value'] = e.code;
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return returnCode;
  }

  googleLoginFromMainPage(var anonymData) async {
    await _auth.signOut();
    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var newUser = await FirebaseAuth.instance.signInWithCredential(credential);

    await _firestore.collection("Users").doc(newUser.user!.uid).set({
      "userName": googleUser.displayName,
      "email": googleUser.email,
      "photoUrl": googleUser.photoUrl,
      "registerType": "Google",
      "id": newUser.user!.uid,
      "userAuth": anonymData['userAuth'],
      "userSubscription": "Free",
      "createTime": anonymData['createTime'],
      "yourHabits": anonymData['yourHabits'],
      "habitDetails": anonymData['habitDetails'],
      "habitDays": anonymData['habitDays'],
      "completedHabits": anonymData['completedHabits'],
      "finalCompleted": anonymData['finalCompleted'],
    }).then((value) async {
      //silemedik çünkü user log out oldu ve yetkisi gitti...
      // var k = await FirebaseFirestore.instance
      //     .collection("Users")
      //     .doc(anonymData['id'])
      //     .delete();
    });
    // if (!doesGoogleUserExist(newUser.user!.uid)) {
    //   await _firestore.collection("Users").doc(newUser.user!.uid).set(anonymData);
    // }
  }

  Future<bool> doesGoogleUserExist(String uid) async {
// if the size of value is greater then 0 then that doc exist.

    print("PPPPPPPPPP  ");
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('Users');

      var doc = await collectionRef.doc(uid).get();

      print("_accountAlreadyExistttttttt = " + doc.exists.toString());
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  googleLoginFromIntroPage() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var newUser = await FirebaseAuth.instance.signInWithCredential(credential);
    print("OOOOOOOOOOO  ");
    print(newUser.user!.uid);

    //
  }

  signOut() async {
    return await _auth.signOut();
  }

  signOutAndDeleteUser(String uid, String registerType) async {
    if (registerType == "Anonym") {
      print("AAAAAAAAAAA $uid");
      var k = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .delete()
          .then((value) async {
        return await _auth.signOut();
      }).onError((error, stackTrace) async {
        return await _auth.signOut();
      });
    } else {
      return await _auth.signOut();
    }
  }
}
