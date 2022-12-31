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

  transportDataFromOnPremToCloud(String uid, var _yourHabits, var _habitDetails,
      var _habitDays, var _completedHabits, var _finalCompleted) async {
    FirebaseFirestore.instance.collection('Users').doc(uid).update({
      'yourHabits': _yourHabits,
      'habitDetails': _habitDetails,
      'habitDays': _habitDays,
      'completedHabits': _completedHabits,
      'finalCompleted': _finalCompleted
    });
  }
}
