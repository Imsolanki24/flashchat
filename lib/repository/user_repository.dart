import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newflashchtapp/models/chat_room_model.dart';

import '../models/user_model.dart';
import '../utilities/database_key.dart';

class UserRepository {
// create new user when he register
  Future<void> createUser({
    required UserModel user,
  }) async {
    try {
      final ref =
          FirebaseFirestore.instance.collection(DatabaseKey.users).doc(user.id);
      await ref.set(user.toMap());
      debugPrint("User created successfully!!");
    } catch (error) {
      debugPrint("Failed to create user!! - $error");
    }
  }

  // fetch user by user id
  Future<UserModel?> fetchUserById(String id) async {
    try {
      final ref =
          FirebaseFirestore.instance.collection(DatabaseKey.users).doc(id);
      final data = await ref.get();
      return UserModel.fromMap(data.data()!);
    } catch (error) {
      debugPrint("Failed to fetch user!! - $error");
      return null;
    }
  }

  // fetch user by user id
  Future<UserModel?> fetchUserFromChatRoom(ChatRoomModel chatRoom) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      chatRoom.participants.remove(user.uid);
      final id = chatRoom.participants.first;
      return fetchUserById(id);
    } else {
      debugPrint("User is unauthenticated");
      return null;
    }
  }
}
