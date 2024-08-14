import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive/hive.dart';

class FirebaseSync {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  final Box<Map<String, dynamic>> _hiveBox;

  FirebaseSync(this._hiveBox);

  void syncData() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection');
      return;
    }

    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        Map<String, dynamic> firebaseData =
            (event.snapshot.value as Map<String, dynamic>);
        Map<String, dynamic> hiveData =
            _hiveBox.toMap().cast<String, dynamic>();

        // Upload new data from Hive to Firebase
        hiveData.forEach((key, value) {
          if (!firebaseData.containsKey(key)) {
            _databaseRef.child(key).set(value);
          }
        });

        // Download data from Firebase to Hive
        firebaseData.forEach((key, value) {
          if (!hiveData.containsKey(key)) {
            _hiveBox.put(key, value);
          }
        });
      }
    });
  }
}
