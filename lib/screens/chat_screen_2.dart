import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newflashchtapp/models/chat_room_model.dart';
import 'package:newflashchtapp/models/message_model.dart';
import 'package:newflashchtapp/models/user_model.dart';
import 'package:newflashchtapp/repository/chat_repositoy.dart';
import 'package:newflashchtapp/repository/user_repository.dart';

class ChatScreen2 extends StatefulWidget {
  // static const String routeName = '/chat_screen';

  const ChatScreen2({
    Key? key,
    required this.chatRoomId,
    required this.user,
  }) : super(key: key);

  final String chatRoomId;
  final UserModel user;

  @override
  State<ChatScreen2> createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  bool loadingChatRoom = false;
  late ChatRoomModel? _chatRoom;
  late UserModel? user;
  late TextEditingController _messageController;
  late ChatRepository _repository;

  @override
  void initState() {
    _messageController = TextEditingController();
    _repository = ChatRepository();
    setUpChatScreen(context);
    super.initState();
  }

  setUpChatScreen(BuildContext context) async {
    setState(() => loadingChatRoom = true);
    _chatRoom = await _repository.fetchChatRoomById(widget.chatRoomId);
    user = await UserRepository().fetchUserFromChatRoom(_chatRoom!);
    setState(() => loadingChatRoom = false);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leadingWidth: 65,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.arrow_back_ios_new_rounded),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.imageUrl),
              ),
            ],
          ),
        ),
        title: Text(widget.user.name),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            StreamBuilder<List<MessageModel>?>(
              stream: _repository.fetchMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                debugPrint("Stream Builder");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  debugPrint("Stream builder :: waiting");
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  debugPrint("Stream builder :: ${snapshot.data}");
                  return const Center(
                    child: Text("No Messages Fount!"),
                  );
                }

                final _messages = snapshot.data!;
                debugPrint("Stream builder :: messages :: $_messages");
                return ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 75),
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Row(
                        mainAxisAlignment: message.isMe!
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(10),
                            // alignment: message.isMe!
                            //     ? Alignment.centerRight
                            //     : Alignment.centerLeft,
                            color: message.isMe!
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            child: Text(
                              message.message,
                              style: TextStyle(
                                color:
                                    message.isMe! ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type message...',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _repository.sendMessage(
                          chatRoomId: widget.chatRoomId,
                          message:
                              MessageModel(message: _messageController.text));
                      setState(() => _messageController.clear());
                    },
                    child: CircleAvatar(
                      child: Transform.rotate(
                        angle: 7 * pi / 4,
                        child: const Icon(Icons.send),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
