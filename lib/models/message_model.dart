import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? id;
  final String message;
  final String? senderId;
  final Timestamp? created;
  final bool? isMe;

  const MessageModel({
    this.id,
    required this.message,
    this.senderId,
    this.created,
    this.isMe,
  });

  @override
  String toString() => 'MessageModel{ id: $id, message: $message, '
      'senderId: $senderId, created: $created, isMe: $isMe}';

  MessageModel copyWith({
    String? id,
    String? message,
    String? senderId,
    Timestamp? created,
    bool? isMe,
  }) {
    return MessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      created: created ?? this.created,
      isMe: isMe ?? this.isMe,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'senderId': senderId,
      'created': Timestamp.now(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      message: map['message'] as String,
      senderId: map['senderId'] as String,
      created: map['created'] as Timestamp,
      isMe: map['isMe'] ?? false,
    );
  }
}
