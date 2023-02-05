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

  Future appleLoginFromMainPage(var anonymData) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
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

        final newUser = await _auth.signInWithCredential(credential);
        final firebaseUser = newUser.user!;
        print("AAAAAAAAAAAAA11");
        // print(newUser.user!.uid);
        print(newUser.user);

        await _firestore.collection("Users").doc(newUser.user!.uid).set({
          "userName": newUser.user!.displayName != null
              ? newUser.user!.displayName
              : "KiWi User",
          "email": newUser.user!.email != null ? newUser.user!.email : "",
          "photoUrl": newUser.user!.photoURL != null
              ? newUser.user!.photoURL
              : "https://firebasestorage.googleapis.com/v0/b/kiwihabitapp-5f514.appspot.com/o/kiwiLogo.png?alt=media&token=90320926-0ff1-4fc8-a3eb-62c9d85e0ef0",
          "registerType": "Apple",
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

  appleLoginFromIntroPage() async {
    bool _userVarMi = true;
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
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

        final newUser = await _auth.signInWithCredential(credential);
        final firebaseUser = newUser.user!;
        print("AAAAAAAAAAAAA11");
        print(newUser.user!.uid);

        var _userVarYok = await doesGoogleUserExist(newUser.user!.uid);
        _userVarMi = _userVarYok;

        print(_userVarYok);
      // print(newUser.user);

    }
    print("BBBBBBBB");
    print(_userVarMi);
    return _userVarMi;

    //
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
