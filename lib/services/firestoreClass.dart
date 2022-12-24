import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDB {
  getDataFromFireStore() async {
    var _finalData;
    var data = await FirebaseFirestore.instance
        .collection("Configs")
        .doc("TestConfig")
        .get()
        .then((gelenVeri) {
      _finalData = gelenVeri.data();
      print(_finalData['Social']);
    });

    // print(_allResults);
    return _finalData;
  }
}
