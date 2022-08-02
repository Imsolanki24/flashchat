import 'package:flutter/material.dart';

import '../component/chat_room_chat_tile.dart';
import '../models/chat_room_model.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../repository/chat_repositoy.dart';
import 'chat_screen_2.dart';
import 'welcome_screen.dart';

class ChatRoomsScreen extends StatelessWidget {
  // static const String routeName = '/chat_rooms';

  const ChatRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatRepository _chatRepository = ChatRepository();

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                AuthRepository().logOut().then(
                      (value) => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                        (route) => false,
                      ),
                    );
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<List<ChatRoomModel>>(
                stream: _chatRepository.fetchChatRooms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text("No Chat Fount!"),
                      ),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final chatRoom = snapshot.data![index];

                        return ChatRoomChatTile(chatRoom: chatRoom);
                      });
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Text(
                "Suggestions:",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            StreamBuilder<List<UserModel>>(
                stream: _chatRepository.fetchChatRoomSuggestion(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text("No Suggestion Fount!"),
                      ),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data![index];
                        return ListTile(
                          onTap: () async {
                            await _chatRepository
                                .createChatRoom(user.id)
                                .then((chatRoomId) {
                              debugPrint("Chat room created :: $chatRoomId");
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen2(
                                      chatRoomId: chatRoomId!, user: user),
                                ),
                              );
                            }).catchError((_) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text("Something went wrong!!"),
                                backgroundColor: Theme.of(context)
                                    .errorColor
                                    .withOpacity(0.5),
                              ));
                            });
                          },
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(user.imageUrl)),
                          title: Text(user.name),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
