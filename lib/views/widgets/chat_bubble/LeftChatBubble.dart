import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:mimichat/services/ImageService.dart';
import 'package:mimichat/utils/CustomColors.dart';

class LeftChatBubble extends StatefulWidget {
  final String img;
  final String message;
  final String time;
  final bool isExpanded;

  LeftChatBubble({
    required this.img,
    required this.message,
    required this.time,
    required this.isExpanded,
  });

  @override
  State<LeftChatBubble> createState() => _LeftChatBubbleState();
}

class _LeftChatBubbleState extends State<LeftChatBubble> {
  Color textColor = Colors.black;
  Color? timeColor = Colors.grey[800];
  // Future<Uint8List?>? _imageFuture;

  @override
  void initState() {
    super.initState();

    // _imageFuture = ImageService.getImage(widget.img);
  }

  double _countWidth(String msg) {
    int length = msg.split(" ").length;
    var coff = length <= 3
        ? .4
        : length <= 10
            ? .6
            : .9;
    return widget.isExpanded ? coff * .5 : coff;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          MediaQuery.of(context).size.width < 500
              ? SizedBox.shrink()
              : Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Transform.scale(
                    scale: 0.5,
                    child: CircleAvatar(
                      radius: 50,
                      child: ExtendedImage.network(
                        widget.img,
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
                  ),
                  // FutureBuilder<Uint8List?>(
                  //     future: _imageFuture,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return CircularProgressIndicator();
                  //       } else if (snapshot.hasError) {
                  //         return CircleAvatar(
                  //           child: Icon(Icons.error),
                  //         );
                  //       } else if (snapshot.hasData) {
                  //         return CircleAvatar(
                  //           backgroundImage: MemoryImage(snapshot.data!),
                  //         );
                  //       } else {
                  //         return CircleAvatar(
                  //           child: Icon(Icons.person),
                  //         );
                  //       }
                  //     }),
                ),
          SizedBox(
            width: 15,
          ),
          SizedBox(
            width:
                MediaQuery.of(context).size.width * _countWidth(widget.message),
            child: ChatBubble(
              backGroundColor: CustomColors.BG_Grey,
              clipper: ChatBubbleClipper6(
                type: BubbleType.receiverBubble,
              ),
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
                      mainAxisAlignment: MainAxisAlignment.end,
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
          )
        ],
      ),
    );
  }
}
