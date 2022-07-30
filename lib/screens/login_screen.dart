import 'package:flutter/material.dart';
import 'package:newflashchtapp/component/rounded_button.dart';
import 'package:newflashchtapp/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newflashchtapp/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'logo',
                child: Container(
                  child: Image.asset('images/logo.png'),
                  height: 200,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kInputDecoration.copyWith(hintText: 'Enter Your Email')),
              const SizedBox(
                height: 8,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (vale) {
                  password = vale;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter Your Password'),
              ),
              const SizedBox(
                height: 24,
              ),
              RoundedButton(
                  text: 'Log In',
                  onPressed: () async {
                    try {
                      setState(() {
                        showSpinner = true;
                      });
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  color: Colors.blueAccent)
            ],
          ),
        ),
      ),
    );
  }
}
