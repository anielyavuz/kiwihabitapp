import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final _personCollection = FirebaseFirestore.instance.collection("Users");

  Stream<DocumentSnapshot> get people {
    return _personCollection.doc(uid).snapshots();
  }
}

class DatabaseService2 {
  final String uid;
  DatabaseService2({required this.uid});

  final CollectionReference _personCollection =
      FirebaseFirestore.instance.collection("Configs");

  Stream<QuerySnapshot> get people {
    return _personCollection.snapshots();
    //alttaki sistem birden fazla collection ile kontrol için tasarlanmıştı. üstteki sistemin kullanılmasının amacı Tek merkezden yönetmek. Eğer Document içi çok dolarsa alttaki sisteme geri dönülebilir. o zaman db'de yeni doc'lar oluşturmak lazım sesaon1 2 ....
    // return _personCollection.where("season", isEqualTo: 1).snapshots();
  }
}
