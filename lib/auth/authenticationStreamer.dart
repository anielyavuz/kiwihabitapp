import 'package:cloud_firestore/cloud_firestore.dart';

class UserStream {
  final String uid;
  UserStream({required this.uid});

  Stream<DocumentSnapshot> get stream {
    return FirebaseFirestore.instance.collection("Users").doc(uid).snapshots();
  }
}

class ConfigStream {
  Stream<QuerySnapshot> get stream {
    return FirebaseFirestore.instance.collection("Configs").snapshots();
  }
}
