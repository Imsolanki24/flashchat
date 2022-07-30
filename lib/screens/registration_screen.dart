import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newflashchtapp/constant.dart';
import 'package:newflashchtapp/component/rounded_button.dart';
import 'package:newflashchtapp/screens/chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  late String email;
 late String password;

 final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                text: 'Register',
                onPressed: ()async {
                  try{
              final newUser =  await   _auth.createUserWithEmailAndPassword(email: email, password: password);
              if(newUser != null){
                Navigator.pushNamed(context, ChatScreen.id);
              }
                }catch (e){
                    print(e);
                  }
                },
                color: Colors.blueAccent)
          ],
        ),
      ),
    );
  }
}
