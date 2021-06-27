import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseServices{

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getUserId(){
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productsRef =
  FirebaseFirestore.instance.collection("Products");

  final CollectionReference usersRef =
  FirebaseFirestore.instance.collection("Users");

}