import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/providers/SelectedChatProvider.dart';
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
  // Future<Uint8List?>? _imageFuture;
  String url = "";
  @override
  void initState() {
    super.initState();
    if (AppStateManager.currentUser!.id == widget.chat.sender.id) {
      url = widget.chat.receiver.profilePicture!;
      // _imageFuture =
      // ImageService.getImage(widget.chat.receiver.profilePicture!);
    } else {
      url = widget.chat.sender.profilePicture!;
      // _imageFuture = ImageService.getImage(widget.chat.sender.profilePicture!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("ChatListItem.build");
    User sender = widget.chat.sender;
    User receiver = widget.chat.receiver;
    bool isSender = currentUser.isSamePersonAs(sender);
    Message lastMsg = widget.chat.messages!.last;
    SelectedChatProvider selChaProvider =
        Provider.of<SelectedChatProvider>(context, listen: false);

    return Material(
      type: MaterialType.transparency,
      child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.transparent),
          ),
          onTap: () {
            selChaProvider.selectChat(widget.chat.id!);
          },
          hoverColor: Colors.grey[300],
          title: Row(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                      '${isSender ? receiver.fullName : sender.fullName}',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600))),
              Spacer(),
              Text('${timeago.format(lastMsg.date, locale: 'en_short')}',
                  style: TextStyle(fontSize: 12)),
            ],
          ),
          subtitle: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                  '${currentUser.isSamePersonAs(lastMsg.sender) ? 'You: ' : ''}${lastMsg.content}')),
          // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          leading: Container(
            child: Transform.scale(
              scale: 1.1,
              child: CircleAvatar(
                radius: 50,
                child: ExtendedImage.network(
                  url,
                  fit: BoxFit.cover,
                  cache: true,
                  shape: BoxShape.circle,
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return CircularProgressIndicator();
                      case LoadState.completed:
                        return ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                          fit: BoxFit.cover,
                        );
                      case LoadState.failed:
                        return Icon(Icons.person);
                    }
                  },
                ),
              ),
              // FutureBuilder<Uint8List?>(
              //   future: _imageFuture,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     } else if (snapshot.hasError) {
              //       return CircleAvatar(
              //         child: Icon(Icons.error),
              //       );
              //     } else if (snapshot.hasData) {
              //       return CircleAvatar(
              //         backgroundImage: MemoryImage(snapshot.data!),
              //       );
              //     } else {
              //       return CircleAvatar(
              //         child: Icon(Icons.person),
              //       );
              //     }
              //   },
              // ),
            ),
          )),
    );
  }
}
