import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserData extends StatelessWidget {
  final String documentID;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  GetUserData({required this.documentID});

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

          return RichText(
            text: TextSpan(
                text: '${data['first name']} ${data['last name']}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n@${data['user name']}',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  )
                ]),

            // textAlign: TextAlign.center,
          );
        }
        return Text('Loading...');
      }),
    );
  }
}
