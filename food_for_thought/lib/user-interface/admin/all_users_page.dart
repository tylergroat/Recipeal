import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_for_thought/classes/user_class.dart';
import 'package:food_for_thought/user-interface/user-functions/user_card.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../back-end/database.dart';

//class to allow admin to apprive user created recipes -- Implemented by : Gavin Fromm

class AllUsersPage extends StatefulWidget {
  @override
  AllUsersPageState createState() => AllUsersPageState();
}

class AllUsersPageState extends State<AllUsersPage> {
  late List<UserInformation> users = [];
  bool loaded = true;

  Future<void> getUsers() async {
    users = await DatabaseService.getAllUsers();
    setState(() {
      users;
      loaded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('All Users'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => getUsers(),
        child: loaded
            ? Center(
                child: SizedBox(
                height: 70,
                width: 70,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  strokeWidth: 2,
                  colors: [Color.fromARGB(255, 244, 4, 4)],
                ),
              ))
            : Scrollbar(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: UserCard(
                        email: users[index].email,
                        firstName: users[index].firstName,
                        lastName: users[index].lastName,
                        username: users[index].userName,
                        uid: users[index].uid,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
