import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mimichat/dao/MessageDAO.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/providers/ChatProvider.dart';
import 'package:mimichat/services/ImageService.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:mimichat/utils/CustomColors.dart';
import 'package:mimichat/views/pages/home/PersonProfile.dart';
import 'package:mimichat/views/widgets/chat_bubble/LeftChatBubble.dart';
import 'package:mimichat/views/widgets/chat_bubble/RightChatBubble.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ConversationPage extends StatefulWidget {
  ConversationPage();

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController _messageController = TextEditingController();
  bool _isExpanded = false;
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<Message?> sendMessage(
      String msg, User sender, User receiver, String chatId) async {
    Message? result;
    if (msg.isNotEmpty) {
      Message msg = Message(
          content: _messageController.text,
          date: DateTime.now(),
          sender: sender,
          receiver: receiver);
      await MessageDAO.saveMessage(chatId, msg).then((val) {
        result = val;
      });
    }
    return result;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    User currentUser = AppStateManager.currentUser!;
    Chat chat = chatProvider.selectedChat;
    bool isSender = currentUser.isSamePersonAs(chat.sender);

    User otherUser =
        chat.sender.id == currentUser.id ? chat.receiver : chat.sender;
    return LayoutBuilder(builder: (context, constraints) {
      double parentWidth = constraints.maxWidth;

      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                color: Colors.grey[300]!,
                width: 1.5,
              ),
            )),
        child: Row(
          children: [
            Expanded(
              flex: _isExpanded ? 3 : 4, // Adjust flex values to split space
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    )),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        FutureBuilder<Uint8List?>(
                            future: ImageService.getImage(
                                otherUser.profilePicture!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return CircleAvatar(
                                  child: Icon(Icons.error),
                                );
                              } else if (snapshot.hasData) {
                                return CircleAvatar(
                                  radius: 20,
                                  backgroundImage: MemoryImage(snapshot.data!),
                                );
                              } else {
                                return CircleAvatar(
                                  child: Icon(Icons.person),
                                );
                              }
                            }),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${otherUser.fullName}',
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: "PublicSans",
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: IconButton(
                              tooltip: "Call",
                              onPressed: () {},
                              icon: Icon(
                                Icons.phone_outlined,
                                size: 25,
                                color: Colors.grey[500],
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: IconButton(
                              tooltip: "View Profile",
                              onPressed: () {
                                _toggleExpanded();
                              },
                              icon: Icon(
                                Icons.person_outline,
                                size: 25,
                                color: Colors.grey[500],
                              ),
                            )),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: PopupMenuButton<String>(
                            iconColor: Colors.grey[500],
                            onSelected: (String choice) {
                              switch (choice) {
                                case 'Close Chat':
                                  chatProvider.closeChat();
                                  break;
                                case 'Delete Chat':
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {
                                'Close Chat',
                                'Delete Chat',
                              }.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: chatProvider.selectedChat.messages.length,
                      itemBuilder: (context, index) {
                        int reversedIndex = chat.messages.length - index - 1;
                        Message msg = chat.messages[reversedIndex];
                        bool amISender = msg.sender.isSamePersonAs(currentUser);
                        return amISender
                            ? RightChatBubble(
                                img: "${msg.sender.profilePicture}",
                                message: "${msg.content}",
                                time: "${timeago.format(msg.date)}",
                                isExpanded: _isExpanded,
                              )
                            : LeftChatBubble(
                                img: "${msg.sender.profilePicture}",
                                message: "${msg.content}",
                                time: "${timeago.format(msg.date)}",
                                isExpanded: _isExpanded,
                              );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(
                        color: CustomColors.BG_Grey,
                        width: 1.5,
                      ),
                    )),
                    // padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          width: parentWidth * (_isExpanded ? .45 : .85),
                          child: TextField(
                            controller: _messageController,
                            onSubmitted: (val) {
                              sendMessage(_messageController.text, currentUser,
                                  otherUser, chat.id);
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFE6EBF5),
                              hintText: "Enter Message...",
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintStyle: TextStyle(fontWeight: FontWeight.w400),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Color(0xffe6ebf5),
                                      style: BorderStyle.solid,
                                      width: 0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Color(0xffe6ebf5),
                                      style: BorderStyle.solid,
                                      width: 0)),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: CustomColors.purpple,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                sendMessage(_messageController.text,
                                        currentUser, otherUser, chat.id)
                                    .then((val) {
                                  if (val != null) {
                                    chatProvider.addMessage(val);
                                    setState(() {
                                      _messageController.clear();
                                    });
                                  }
                                });
                              },
                              icon: Icon(Icons.send)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _isExpanded ? MediaQuery.of(context).size.width / 3.5 : 0,
              child: _isExpanded
                  ? PersonProfile(
                      onPressed: _toggleExpanded,
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }
}
