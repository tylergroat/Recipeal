import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'registration_page.dart';

void main() {
  //function used to run function
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login_page',
      routes: {
        'registration_page': (context) => RegistrationPage(),
        'login_page': (context) => LoginPage(),
        'home_page': (context) => HomePage()
      },
    );
  }
}
