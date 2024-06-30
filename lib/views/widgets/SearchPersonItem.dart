import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/providers/ChatsProvider.dart';
import 'package:mimichat/providers/SelectedChatProvider.dart';
import 'package:mimichat/services/ChatService.dart';
import 'package:mimichat/services/ImageService.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:provider/provider.dart';

class SearchPersonItem extends StatefulWidget {
  final User user;
  SearchPersonItem({super.key, required this.user});

  @override
  State<SearchPersonItem> createState() => _SearchPersonItemState();
}

class _SearchPersonItemState extends State<SearchPersonItem> {
  // Future<Uint8List?>? _imageFuture;
  ChatsProvider? _chatsProvider;
  @override
  void initState() {
    super.initState();

    // _imageFuture = ImageService.getImage(widget.user.profilePicture!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatsProvider = Provider.of<ChatsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.transparent),
          ),
          onTap: () async {
            var chat = _chatsProvider!.getChatByUserId(widget.user.id);
            if (chat != null) {
              Provider.of<SelectedChatProvider>(context, listen: false)
                  .selectChat(chat.id!);
            } else {
              Chat chat = Chat(
                  sender: AppStateManager.currentUser!,
                  receiver: widget.user,
                  messages: []);
              Chat? chatResp = await ChatService.createChat(chat);

              Provider.of<ChatsProvider>(context, listen: false)
                  .addChat(chatResp!);

              Provider.of<SelectedChatProvider>(context, listen: false)
                  .selectChat(chatResp.id!);
            }
          },
          hoverColor: Colors.grey[300],
          title: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text(widget.user.fullName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          subtitle: Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              widget.user.bio!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          leading: Container(
            child: Transform.scale(
              scale: 1.1,
              child: CircleAvatar(
                  radius: 50,
                  child: ExtendedImage.network(
                    widget.user.profilePicture!,
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
