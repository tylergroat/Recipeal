import 'package:flutter/material.dart';
import 'mainscreen_page.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        'home_page': (context) => MainScreen()
      },
    );
  }
}
