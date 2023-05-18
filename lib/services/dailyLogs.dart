import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DailyLogs {
  writeLog(String uid, String userName, String info) async {
    var _date = DateFormat('dd MMMM yyyy').format(DateTime.now());
    var _suan = DateFormat('dd MMMM yyyy HH:mm:ss').format(DateTime.now());
    var _epoch = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore.instance
        .collection('DailyLogs')
        .doc(_date)
        .update({
          uid + "." + _epoch: {
            "Info": info,
            "UserName": userName,
            "Time": _suan
          }
        })
        .whenComplete(() => print("B"))
        .onError((error, stackTrace) {
          print("A");
          FirebaseFirestore.instance.collection("DailyLogs").doc(_date).set({
            uid: {
              _epoch: {"Info": info, "UserName": userName, "Time": _suan}
            }
          });
        });
  }
}
