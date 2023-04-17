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

          return RichText(
            text: TextSpan(
                text: '${data['first name']} ${data['last name']}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
