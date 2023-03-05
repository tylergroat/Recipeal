import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String uid;

  User({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.uid,
  });

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return User(
      firstName: data?['first name'],
      lastName: data?['last name'],
      email: data?['email'],
      uid: data?['uid'],
      userName: data?['user name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (email != null) "emai;": email,
      if (firstName != null) "first name": firstName,
      if (lastName != null) "last name": lastName,
      if (uid != null) "uid": uid,
      if (userName != null) "user name": userName,
    };
  }
}
