import 'package:flutter/material.dart';
import 'package:mimichat/models/User.dart';

class ChatListItem extends StatefulWidget {
  String name;
  String message;
  String img;
  String time;
  VoidCallback onTap;
  ChatListItem(
      {required this.name,
      required this.message,
      required this.img,
      required this.time,
      required this.onTap});

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.transparent),
          ),
          onTap: widget.onTap,
          hoverColor: Colors.grey[300],
          title: Row(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text('${widget.name}',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500))),
              Spacer(),
              Text('${widget.time}', style: TextStyle(fontSize: 12)),
            ],
          ),
          subtitle: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text('${widget.message}')),
          // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          leading: Container(
            child: Transform.scale(
              scale: 1.1,
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.img),
                // child: ClipRRect(
                //   borderRadius: BorderRadius.circular(50),
                //   child: Image.asset("${widget.img}",
                //       width: 40, height: 40, fit: BoxFit.cover),
                // ),
              ),
            ),
          )),
    );
  }
}
