import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String uid;

  UserCard(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.username,
      required this.uid});

  @override
  State<UserCard> createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          width: 20,
          decoration: BoxDecoration(
            color: Colors.grey,
            //fromARGB(255, 244, 4, 4),
            borderRadius: BorderRadius.circular(30),
          ),
          height: 130,
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.person,
                color: Colors.white,
                size: 70,
              ),
              SizedBox(
                width: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.firstName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.lastName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '@${widget.username}',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
