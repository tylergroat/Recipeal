import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  final String documentID;

  GetUserName({required this.documentID});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          String username = '${data['user name']}';
          String fullName = '${data['first name']} ${data['last name']}';

          return Text(
            '${data['first name']} ${data['last name']} \n@${data['user name']}  ',
            style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 75, 72, 72),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        }
        return Text('Loading...');
      }),
    );
  }
}
