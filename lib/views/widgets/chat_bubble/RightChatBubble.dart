import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:mimichat/utils/CustomColors.dart';

class RightChatBubble extends StatefulWidget {
  final String img;
  final String message;
  final String time;
  final bool isExpanded;
  RightChatBubble({
    required this.img,
    required this.message,
    required this.time,
    required this.isExpanded,
  });

  @override
  State<RightChatBubble> createState() => _RightChatBubbleState();
}

class _RightChatBubbleState extends State<RightChatBubble> {
  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    Color? timeColor = Colors.grey[300];

    double _countWidth(String msg) {
      int length = msg.split(" ").length;
      var coff = length <= 3
          ? .15
          : length <= 10
              ? .2
              : .3;
      return widget.isExpanded ? coff * .5 : coff;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width:
                MediaQuery.of(context).size.width * _countWidth(widget.message),
            child: ChatBubble(
              backGroundColor: CustomColors.purpple,
              clipper:
                  ChatBubbleClipper6(type: BubbleType.sendBubble, sizeRatio: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text.rich(
                      textAlign: TextAlign.justify,
                      TextSpan(
                        text: widget.message,
                        style: TextStyle(color: textColor),
                      ),
                      softWrap: true,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.watch_later_outlined,
                            size: 12, color: timeColor),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "${widget.time}",
                          style: TextStyle(
                            color: timeColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 50),
            child: CircleAvatar(
              maxRadius: 18,
              minRadius: 10,
              backgroundImage: AssetImage('${widget.img}'),
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
