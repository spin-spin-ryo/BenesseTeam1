import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class AddData{
  final String Date;
  final int SmartPhoneTime;
  final int Study;

  AddData(this.Date, this.SmartPhoneTime, this.Study);

  Future<void> addData() {
    debugPrint("Run AddDate");
    CollectionReference  Db = FirebaseFirestore.instance.collection("StudyTime");
    // Call the user's CollectionReference to add a new user
    return Db
        .add({
      'Date': Date, // John Doe
      'SmartPhoneTime': SmartPhoneTime, // Stokes and Sons
      'Study': Study // 42
    })
        .then((value) => debugPrint("User Data"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }
}