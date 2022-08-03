import 'package:flutter/material.dart';
import 'package:newflashchtapp/screens/chat_rooms_screen.dart';
import 'package:newflashchtapp/screens/welcome_screen.dart';

import '../repository/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  // static const String routeName = '/';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateToNext();
    super.initState();
  }

  Future<void> navigateToNext() async {
    final result = await AuthRepository().isLoggedIn();
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (result) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ChatRoomsScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: SizedBox(
                child: Image.asset('images/logo.png'),
                height: 200,
              ),
            ),
            const Text(
              'Flash Chat',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
