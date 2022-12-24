import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Map> anonymSignIn() async {
    Map returnCode = {};
    try {
      var user = await _auth.signInAnonymously();

      await _firestore.collection("Users").doc(user.user!.uid).set(
          {"registerType": "Anonym", "id": user.user!.uid, "userAuth": "Prod"});
    } on FirebaseAuthException catch (e) {
      returnCode['status'] = false;
      returnCode['value'] = e.code;
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return returnCode;
  }

  signOut() async {
    return await _auth.signOut();
  }
}
