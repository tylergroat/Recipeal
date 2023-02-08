import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  final String documentID;

  GetUserName({required this.documentID});

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(documentID).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          String username = '${data['user name']}';
          String fullName = '${data['first name']} ${data['last name']}';

          return Text(
            'Username: ${data['user name']}  \nName: ${data['first name']} ${data['last name']} ',
            style: TextStyle(fontSize: 20, color: Colors.red),
          );
        }
        return Text('loading..');
      }),
    );
  }
}
