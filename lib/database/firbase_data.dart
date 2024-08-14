import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addData(String collectionPath, Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).add(data);
  }

  Future<void> updateData(
      String collectionPath, String documentId, Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).doc(documentId).update(data);
  }

  Future<void> deleteData(String collectionPath, String documentId) {
    return _firestore.collection(collectionPath).doc(documentId).delete();
  }

  Future<DocumentSnapshot> getData(String documentId) {
    return _firestore.collection('element').doc(documentId).get();
  }

  Stream<QuerySnapshot> getDataStream(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }
}

























// // ignore_for_file: unused_element

// import 'dart:io';

// import 'package:flutter/material.dart';

// // Import the firebase_core and cloud_firestore plugin
// //import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // ignore: depend_on_referenced_packages
// import 'package:firebase_storage/firebase_storage.dart';

// class AddProduct extends StatelessWidget {
//   final String? image;
//   final String? title;
//   final String? discripthion;
//   final storageRef = FirebaseStorage.instance.ref();
//   AddProduct({super.key, this.image, this.title, this.discripthion});

//   @override
//   Widget build(BuildContext context) {
//     // Create a CollectionReference called users that references the firestore collection
//     CollectionReference users =
//         FirebaseFirestore.instance.collection('product');
//     String imageurl;
//     final pid = users.id;
//     final ref =
//         FirebaseStorage.instance.ref().child('images').child(pid + '.png');
//     ref.putFile(image! as File);
//     imageurl = ref.getDownloadURL() as String;

//     Future<void> addUser() {
//       // Call the user's CollectionReference to add a new user
//       return users
//           .add({
//             'image': imageurl, // John Doe
//             'title': title, // Stokes and Sons
//             'discripthion': discripthion // 42
//           })
//           // ignore: avoid_print
//           .then((value) => print("User Added"))
//           // ignore: avoid_print
//           .catchError((error) => print("Failed to add user: $error"));
//     }

//     Future<void> updateUser() {
//       return users
//           .doc('ABC123')
//           .update({'company': 'Stokes and Sons'})
//           .then((value) => print("User Updated"))
//           .catchError((error) => print("Failed to update user: $error"));
//     }

//     Future<void> deleteUser() {
//       return users
//           .doc('ABC123')
//           .delete()
//           .then((value) => print("User Deleted"))
//           .catchError((error) => print("Failed to delete user: $error"));
//     }

//     return Container();
//   }
// }

// class UserInformation extends StatefulWidget {
//   @override
//   _UserInformationState createState() => _UserInformationState();
// }

// class _UserInformationState extends State<UserInformation> {
//   final Stream<QuerySnapshot> _usersStream =
//       FirebaseFirestore.instance.collection('users').snapshots();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _usersStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text("Loading");
//         }

//         return ListView(
//           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//             Map<String, dynamic> data =
//                 document.data()! as Map<String, dynamic>;
//             return ListTile(
//               title: Text(data['full_name']),
//               subtitle: Text(data['company']),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
