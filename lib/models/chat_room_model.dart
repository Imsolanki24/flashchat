import 'package:cloud_firestore/cloud_firestore.dart';

import '../utilities/constant.dart';

class ChatRoomModel {
  final String id;
  final List<dynamic> participants;
  final String imageUrl;
  final LastMessageModel? lastMessage;

  const ChatRoomModel({
    required this.id,
    required this.participants,
    this.imageUrl = defaultImage,
    this.lastMessage,
  });

  @override
  String toString() => 'ChatRoomModel{ id: $id, participants: $participants, '
      'imageUrl: $imageUrl, lastMessage: ${lastMessage.toString()}}';

  ChatRoomModel copyWith({
    String? id,
    List<String>? participants,
    String? imageUrl,
    LastMessageModel? lastMessage,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      imageUrl: imageUrl ?? this.imageUrl,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participants': participants,
      'imageUrl': imageUrl,
      'lastMessage': lastMessage == null ? {} : lastMessage!.toMap(),
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'] as String,
      participants: map['participants'] as List<dynamic>,
      imageUrl: map['imageUrl'] as String,
      lastMessage: LastMessageModel.fromMap(map['lastMessage']),
    );
  }
}

class LastMessageModel {
  final String senderId;
  final String message;
  final Timestamp? created;

  const LastMessageModel({
    required this.senderId,
    required this.message,
    this.created,
  });

  @override
  String toString() =>
      'LastMessageModel{ senderId: $senderId, message: $message, created: $created,}';

  LastMessageModel copyWith({
    String? senderId,
    String? message,
    Timestamp? created,
  }) {
    return LastMessageModel(
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'created': Timestamp.now(),
    };
  }

  factory LastMessageModel.fromMap(Map<String, dynamic> map) {
    return LastMessageModel(
      senderId: map['senderId'] ??"",
      message: map['message'] ??"",
      created: map['created'] ?? Timestamp.now(),
    );
  }
}
