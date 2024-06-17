import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mimichat/utils/CustomColors.dart';
import 'package:mimichat/views/pages/home/PersonProfile.dart';
import 'package:mimichat/views/widgets/chat_bubble/LeftChatBubble.dart';
import 'package:mimichat/views/widgets/chat_bubble/RightChatBubble.dart';

class ConversationPage extends StatefulWidget {
  final VoidCallback onExit;
  ConversationPage({
    required this.onExit,
  });

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

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Close Chat':
        widget.onExit();
        break;
      case 'Delete Chat':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('images/avatar-2.jpg'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Full Name',
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
                                print(
                                    "width: ${MediaQuery.of(context).size.width}");
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
                            onSelected: handleClick,
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
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        // int finalIndex = 10 - index;
                        var rand = Random().nextBool();
                        return rand
                            ? LeftChatBubble(
                                img: "images/avatar-2.jpg",
                                message: Random().nextBool()
                                    ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tincidunt facilisis tristique. Donec rutrum bibendum eros nec volutpat. Ut vitae rhoncus nulla. Suspendisse potenti. Cras eget mollis leo, nec fringilla diam. Nulla in ex ut sapien semper molestie. Nunc dictum arcu sit amet faucibus imperdiet. Donec venenatis tortor ac leo euismod, ac venenatis arcu malesuada. Etiam at lectus convallis, faucibus ante vitae, dignissim tortor."
                                    : "Hello World!",
                                time: "12:00",
                                isExpanded: _isExpanded,
                              )
                            : RightChatBubble(
                                img: "images/avatar-1.jpg",
                                message: Random().nextBool()
                                    ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tincidunt facilisis tristique. Donec rutrum bibendum eros nec volutpat. Ut vitae rhoncus nulla. Suspendisse potenti. Cras eget mollis leo, nec fringilla diam. Nulla in ex ut sapien semper molestie. Nunc dictum arcu sit amet faucibus imperdiet. Donec venenatis tortor ac leo euismod, ac venenatis arcu malesuada. Etiam at lectus convallis, faucibus ante vitae, dignissim tortor."
                                    : "Hello World!",
                                time: "12:00",
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
                              print("_messageController onSubmitted(), $val");
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
                              onPressed: () {},
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
