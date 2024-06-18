import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/providers/ChatProvider.dart';
import 'package:mimichat/services/ImageService.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListItem extends StatefulWidget {
  final Chat chat;
  ChatListItem({required this.chat});

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  User currentUser = AppStateManager.currentUser!;
  @override
  Widget build(BuildContext context) {
    User sender = widget.chat.sender;
    User receiver = widget.chat.receiver;
    bool isSender = currentUser.isSamePersonAs(sender);
    Message lastMsg = widget.chat.messages.last;
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);

    return Material(
      type: MaterialType.transparency,
      child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.transparent),
          ),
          onTap: () {
            chatProvider.selectChat(widget.chat);
          },
          hoverColor: Colors.grey[300],
          title: Row(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                      '${isSender ? receiver.fullName : sender.fullName}',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500))),
              Spacer(),
              Text('${timeago.format(lastMsg.date)}',
                  style: TextStyle(fontSize: 12)),
            ],
          ),
          subtitle: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                  '${currentUser.id == lastMsg.idSender ? 'You: ' : ''}${lastMsg.content}')),
          // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          leading: Container(
            child: Transform.scale(
              scale: 1.1,
              child: FutureBuilder<Uint8List?>(
                future: ImageService.getImage(isSender
                    ? receiver.profilePicture!
                    : sender.profilePicture!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return CircleAvatar(
                      child: Icon(Icons.error),
                    );
                  } else if (snapshot.hasData) {
                    return CircleAvatar(
                      backgroundImage: MemoryImage(snapshot.data!),
                    );
                  } else {
                    return CircleAvatar(
                      child: Icon(Icons.person),
                    );
                  }
                },
              ),
            ),
          )),
    );
  }
}
