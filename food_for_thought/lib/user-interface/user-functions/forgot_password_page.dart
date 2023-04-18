import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  static String id = 'forgot-password';
  final _emailController = TextEditingController();

  void dispose() {
    _emailController.dispose();
  }

  Future<bool> passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  final RoundedLoadingButtonController forgotPasswordButton =
      RoundedLoadingButtonController();
  final enterEmailMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Empty Input',
      message: 'Please enter an email!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );
  final emailDNEMessage = MaterialBanner(
    backgroundColor: Colors.transparent,
    elevation: 0,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      color: Colors.red,
      title: 'Email not found',
      message: 'Please register first!',

      contentType: ContentType.failure,
      // to configure for material banner
    ),
    actions: const [SizedBox.shrink()],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: body(context),
    );
  }

  Form body(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(
                  Icons.mail,
                  color: Colors.grey,
                ),
                errorStyle: TextStyle(color: Colors.black),
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10, bottom: 0),
              child: RoundedLoadingButton(
                width: 250,
                borderRadius: 8,
                animateOnTap: true,
                resetDuration: Duration(seconds: 3),
                color: Color.fromARGB(255, 244, 4, 4),
                controller: forgotPasswordButton,
                onPressed: () async {
                  if (await passwordReset()) {
                    forgotPasswordButton.success();
                    passwordReset();
                    Timer(
                        Duration(seconds: 2),
                        () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginPage())));
                  } else if (_emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(enterEmailMessage);
                    forgotPasswordButton.error();
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());

                    Timer(Duration(seconds: 2),
                        () => forgotPasswordButton.reset());
                    return;
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showMaterialBanner(emailDNEMessage);
                    forgotPasswordButton.error();
                    Timer(
                        Duration(seconds: 2),
                        () => ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner());
                    Timer(Duration(seconds: 2),
                        () => forgotPasswordButton.reset());
                    return;
                  }
                },
                child: Text(
                  'Send Email',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Reset Password',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      backgroundColor: Colors.grey,
      centerTitle: true,
    );
  }
}
