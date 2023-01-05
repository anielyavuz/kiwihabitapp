import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<Map> anonymSignIn() async {
    Map returnCode = {};
    try {
      var user = await _auth.signInAnonymously();

      await _firestore.collection("Users").doc(user.user!.uid).set({
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

  googleSignInTest() async {
    bool _result = true;
    GoogleSignInAccount? googleUsers =
        await _googleSignIn.signIn().then((value) {
      print("AAAAAAAA");
      _result = true;
    }).onError((error, stackTrace) {
      print("BBBBBBBB");
      print(error);
      _result = false;
    });
    return _result;
  }

  googleSignIn() async {
    GoogleSignInAccount? googleUsers =
        await _googleSignIn.signIn().then((value) {
      print("AAAAAAAAA");
    }).onError((error, stackTrace) {
      print("BBBBB");
    });

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUsers!.authentication;
    print("CCCCCCCCC");
    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    var user = await _auth.signInWithCredential(credential);
    print("Login olladu $user");
    // Map returnCode = {};
    // try {
    //   var user = await _auth.signInAnonymously();

    //   await _firestore.collection("Users").doc(user.user!.uid).set(
    //       {"registerType": "Anonym", "id": user.user!.uid, "userAuth": "Prod"});
    // } on FirebaseAuthException catch (e) {
    //   returnCode['status'] = false;
    //   returnCode['value'] = e.code;
    //   print('Failed with error code: ${e.code}');
    //   print(e.message);
    // }
  }

  signOut() async {
    return await _auth.signOut();
  }
}
