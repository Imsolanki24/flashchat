import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newflashchtapp/models/chat_room_model.dart';
import 'package:newflashchtapp/models/message_model.dart';
import 'package:newflashchtapp/models/user_model.dart';
import 'package:newflashchtapp/utilities/database_key.dart';

class ChatRepository {
  // to fetch chat rooms
  Stream<List<ChatRoomModel>>? fetchChatRooms() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ref =
            FirebaseFirestore.instance.collection(DatabaseKey.chatRooms);

        final result =
            ref.where("participants", arrayContains: user.uid).snapshots();

        final data = result.map((event) => event.docs.map((e) {
              final map = e.data();

              return ChatRoomModel.fromMap(map);
            }).toList());
        return data;
      } else {
        debugPrint("User is unauthenticated");
        return null;
      }
    } catch (error) {
      debugPrint("Something went wrong, unable to fetch chat rooms\n$error");
      return null;
    }
  }

  // to fetch chat suggestions
  Stream<List<UserModel>>? fetchChatRoomSuggestion() {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final ref = FirebaseFirestore.instance.collection(DatabaseKey.users);
        final result = ref.where("id", isNotEqualTo: user.uid).snapshots();
        final data = result.map((event) =>
            event.docs.map((e) => UserModel.fromMap(e.data())).toList());
        return data;
      } else {
        debugPrint("User is unauthenticated");
        return null;
      }
    } catch (error) {
      debugPrint(
          "Something went wrong, unable to fetch chat rooms suggestion\n$error");
      return null;
    }
  }

  // to create chat room
  Future<String?> createChatRoom(String participantId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      final ref =
          FirebaseFirestore.instance.collection(DatabaseKey.chatRooms).doc();

      if (user != null) {
        final chatRoom =
            ChatRoomModel(id: ref.id, participants: [participantId, user.uid]);
        await ref.set(chatRoom.toMap());
        return ref.id;
      } else {
        debugPrint("User is unauthenticated");
        return null;
      }
    } catch (error) {
      debugPrint("Something went wrong, unable to create chat rooms\n$error");
      return null;
    }
  }

  // fetch chat room using chatroom id
  Future<ChatRoomModel?> fetchChatRoomById(String chatRoomId) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection(DatabaseKey.chatRooms)
          .doc(chatRoomId);
      final result = await ref.get();
      return ChatRoomModel.fromMap(result.data()!);
    } catch (error) {
      debugPrint("Something went wrong, unable to fetch chat room - $error");
      return null;
    }
  }

  // to messages
  Stream<List<MessageModel>>? fetchMessages(String chatRoomId) {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final ref = FirebaseFirestore.instance
            .collection(DatabaseKey.chatRooms)
            .doc(chatRoomId)
            .collection(DatabaseKey.messages);

        final result = ref.orderBy("created", descending: true).snapshots();

        final data = result.map((event) => event.docs.map((e) {
              final map = e.data();
              return MessageModel.fromMap(map)
                  .copyWith(isMe: map["senderId"] == user.uid);
            }).toList());

        return data;
      } else {
        debugPrint("User is unauthenticated");
        return null;
      }
    } catch (error) {
      debugPrint("Something went wrong, unable to fetch messages\n$error");
      return null;
    }
  }

  // to send message
  Future<void> sendMessage({
    required String chatRoomId,
    required MessageModel message,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseFirestore.instance
          .collection(DatabaseKey.chatRooms)
          .doc(chatRoomId)
          .collection(DatabaseKey.messages)
          .doc();

      final _message = message.copyWith(id: ref.id, senderId: user.uid);

      await ref.set(_message.toMap());

      await updateChatRoom(
          senderId: user.uid, chatRoomId: chatRoomId, message: message);
    }
  }

  // to update last sent message
  Future<void> updateChatRoom({
    required String senderId,
    required String chatRoomId,
    required MessageModel message,
  }) async {
    final ref = FirebaseFirestore.instance
        .collection(DatabaseKey.chatRooms)
        .doc(chatRoomId);

    final lastMessage =
        LastMessageModel(senderId: senderId, message: message.message);

    await ref.set(
      {'lastMessage': lastMessage.toMap()},
      SetOptions(merge: true),
    );
  }
}
