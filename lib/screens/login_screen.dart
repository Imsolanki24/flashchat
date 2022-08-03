import 'package:flutter/material.dart';
import 'package:newflashchtapp/screens/chat_rooms_screen.dart';

import '../component/loading_indicator.dart';
import '../component/rounded_button.dart';
import '../repository/auth_repository.dart';
import '../utilities/constant.dart';

class LoginScreen extends StatefulWidget {
  // static const String routeName = '/login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLoader = false;
  late String email;
  late String password;

  final AuthRepository _repository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LoadingIndicator(
        showLoader: showLoader,
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'logo',
                  child: SizedBox(
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
                    decoration: kInputDecoration.copyWith(
                        hintText: 'Enter Your Email')),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (vale) {
                    password = vale;
                  },
                  decoration: kInputDecoration.copyWith(
                      hintText: 'Enter Your Password'),
                ),
                const SizedBox(
                  height: 24,
                ),
                RoundedButton(
                  text: 'Log In',
                  onPressed: () async {
                    setState(() => showLoader = true);
                    final result = await _repository.login(
                        email: email, password: password);
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("Welcome back to Flash chat!!"),
                        backgroundColor: Colors.green.withOpacity(0.5),
                      ));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ChatRoomsScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text("Something went wrong!!"),
                        backgroundColor:
                            Theme.of(context).errorColor.withOpacity(0.5),
                      ));
                    }
                    setState(() => showLoader = false);
                  },
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
