import 'package:flutter/material.dart';
import 'package:newflashchtapp/component/circular_image.dart';

import '../models/chat_room_model.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart';
import '../screens/chat_screen_2.dart';

class ChatRoomChatTile extends StatelessWidget {
  const ChatRoomChatTile({
    Key? key,
    required this.chatRoom,
  }) : super(key: key);

  final ChatRoomModel chatRoom;

  @override
  Widget build(BuildContext context) {
    final UserRepository _repository = UserRepository();
    return FutureBuilder<UserModel?>(
        future: _repository.fetchUserFromChatRoom(chatRoom),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              leading: const CircularImage(imageUrl: ""),
              title: Container(
                color: Colors.grey,
                height: 10,
                width: 100,
              ),
              subtitle: Container(
                color: Colors.grey,
                height: 10,
                width: 150,
              ),
            );
          }
          if (snapshot.data == null || snapshot.hasError) {
            return const ListTile(
              title: Center(
                child: Text("Something went wrong!!"),
              ),
            );
          }
          final user = snapshot.data!;
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen2(
                    chatRoomId: chatRoom.id,
                    user: user,
                  ),
                ),
              );
            },
            leading: CircularImage(imageUrl: user.imageUrl),
            title: Text(user.name),
            subtitle: Text(chatRoom.lastMessage!.message),
          );
        });
  }
}
