import 'package:flutter/material.dart';
import 'package:food_for_thought/forgot_password.dart';
import 'package:food_for_thought/recipe_instructions_page.dart';
import 'home_page.dart';
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
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(242, 255, 255, 255)),
      debugShowCheckedModeBanner: false,
      initialRoute: 'login_page',
      routes: {
        'registration_page': (context) => RegistrationPage(),
        'login_page': (context) => LoginPage(),
        'home_page': (context) => HomePage(),
        'forgot_pasword_page': (context) => ForgotPasswordPage(),
        'recipe_instructions_page':(context) => RecipeInstructionsPage(),

      },
    );
  }
}
