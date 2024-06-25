import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mimichat/dao/MessageDAO.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/Message.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/providers/ChatsProvider.dart';
import 'package:mimichat/providers/SelectedChatProvider.dart';
import 'package:mimichat/services/ImageService.dart';
import 'package:mimichat/sockets/WsStompMessages.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:mimichat/utils/CustomColors.dart';
import 'package:mimichat/views/pages/home/PersonProfile.dart';
import 'package:mimichat/views/widgets/chat_bubble/LeftChatBubble.dart';
import 'package:mimichat/views/widgets/chat_bubble/RightChatBubble.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      Map<String, dynamic> body = {
        "chat": {"id": chatId},
        "sender": sender,
        "receiver": receiver,
        "content": _messageController.text,
        "date": "${DateTime.now().toUtc().millisecondsSinceEpoch}",
        "seen": false
      };
      WsStompMessage.send(chatId: chatId, body: body);
      _messageController.clear();
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SelectedChatProvider selcChaProvider =
        Provider.of<SelectedChatProvider>(context);
    User currentUser = AppStateManager.currentUser!;

    Chat chat = Provider.of<ChatsProvider>(context, listen: false)
        .getCurrentChat(selcChaProvider.selectedChat!);

    User otherUser =
        chat.sender.id == currentUser.id ? chat.receiver : chat.sender;

    double width = MediaQuery.of(context).size.width;
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
            _buildMainWidget(
                width,
                _isExpanded,
                _mainWidget(
                    selcChaProvider,
                    currentUser,
                    chat,
                    otherUser,
                    context,
                    parentWidth,
                    _isExpanded,
                    _messageController,
                    _toggleExpanded,
                    sendMessage,
                    width)),
            _buildProfileWidget(width, _isExpanded)
          ],
        ),
      );
    });
  }

  Widget _buildMainWidget(double width, bool _isExpnded, Widget org) {
    Widget wid = Expanded(child: org);

    var res = -1;

    if (_isExpnded) {
      if (width > 1000) {
        wid = Expanded(
          child: org,
          flex: 3,
        );

        res = 1;
      } else {
        wid = SizedBox.shrink();
        res = 2;
      }
    }

    return wid;
  }

  Widget _buildProfileWidget(
    double width,
    bool _isExpnded,
  ) {
    Widget wid = SizedBox.shrink();
    var res = -1;
    if (_isExpnded) {
      if (width > 1000) {
        wid = AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: width / 3.5,
            child: PersonProfile(
              onPressed: _toggleExpanded,
            ));
        res = 2;
      } else {
        wid = Expanded(
            child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: width,
                child: PersonProfile(
                  onPressed: _toggleExpanded,
                )));
        res = 3;
      }
    }
    return wid;
  }
}

Widget _mainWidget(
  SelectedChatProvider selChaProvider,
  User currentUser,
  Chat chat,
  User otherUser,
  BuildContext context,
  double parentWidth,
  bool _isExpanded,
  TextEditingController _messageController,
  Function _toggleExpanded,
  Function sendMessage,
  double width,
) {
  return Column(
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                      onPressed: () {
                        selChaProvider.closeChat();
                      },
                      icon: Icon(Icons.arrow_back_ios))),
              FutureBuilder<Uint8List?>(
                  future: ImageService.getImage(otherUser.profilePicture!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                width: 5,
              ),
              Text(
                '${otherUser.fullName}',
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: "PublicSans",
                    fontWeight: FontWeight.w600),
              ),
              width > 600
                  ? SizedBox(
                      width: width * 0.5,
                    )
                  : SizedBox.shrink(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    tooltip: "Voice Call",
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
                    tooltip: "Video Call",
                    onPressed: () {},
                    icon: Icon(
                      Icons.videocam_outlined,
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
                        selChaProvider.closeChat();
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
      ),
      Flexible(
        child: Consumer<ChatsProvider>(
          builder: (context, chatsProv, _) {
            return ListView.builder(
              reverse: true,
              itemCount: chatsProv
                  .getCurrentChat(selChaProvider.selectedChat!)
                  .messages
                  .length,
              itemBuilder: (context, index) {
                var chat =
                    chatsProv.getCurrentChat(selChaProvider.selectedChat!);
                int reversedIndex = chat.messages.length - index - 1;
                Message msg = chat.messages[reversedIndex];
                bool amISender = msg.sender.isSamePersonAs(currentUser);
                return amISender
                    ? RightChatBubble(
                        img: "${msg.sender.profilePicture}",
                        message: "${msg.content}",
                        time: "${timeago.format(msg.date, locale: 'en_short')}",
                        isExpanded: _isExpanded,
                      )
                    : LeftChatBubble(
                        img: "${msg.sender.profilePicture}",
                        message: "${msg.content}",
                        time: "${timeago.format(msg.date, locale: 'en_short')}",
                        isExpanded: _isExpanded,
                      );
              },
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                width: parentWidth * (_isExpanded ? .45 : .8),
                child: TextField(
                  controller: _messageController,
                  onSubmitted: (val) {
                    sendMessage(_messageController.text, currentUser, otherUser,
                        chat.id);
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFE6EBF5),
                    hintText: "Enter Message...",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintStyle: TextStyle(fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                            color: Color(0xffe6ebf5),
                            style: BorderStyle.solid,
                            width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                            color: Color(0xffe6ebf5),
                            style: BorderStyle.solid,
                            width: 0)),
                  ),
                ),
              ),
            ),
            Container(
              padding: width > 700 ? EdgeInsets.all(5) : EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: CustomColors.purpple,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    sendMessage(_messageController.text, currentUser, otherUser,
                            chat.id)
                        .then((val) {});
                  },
                  icon: Icon(Icons.send)),
            )
          ],
        ),
      )
    ],
  );
}
