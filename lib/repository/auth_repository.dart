import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'user_repository.dart';

class AuthRepository {
  // register user with email and password
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final _user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = UserModel(id: _user.user!.uid, name: name, email: email);
      await UserRepository().createUser(user: user);
      return true;
    } catch (error) {
      debugPrint("User registration failed!! - $error");
      return false;
    }
  }

  // login user with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        return true;
      }).catchError((error) {
        debugPrint("User logged in failed!! - $error");
        return false;
      });
    } catch (error) {
      debugPrint("User logged in failed!! - $error");
      return false;
    }
  }

  // check whether user is logged in or not,
  // if he is logged in return true
  Future<bool> isLoggedIn() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint("User is logged in - ${user.uid}");
        return true;
      } else {
        debugPrint("User is not logged in");
        return false;
      }
    } catch (error) {
      debugPrint("Something went wrong!! - $error");
      return false;
    }
  }

  // when user logout fro the app
  Future<bool> logOut() async {
    try {
      FirebaseAuth.instance.signOut();
      debugPrint("User is logged out!!");
      return true;
    } catch (error) {
      debugPrint("Something went wrong!! - $error");
      return false;
    }
  }
}
