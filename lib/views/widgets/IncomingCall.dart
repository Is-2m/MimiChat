import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mimichat/models/CallHistory.dart';
import 'package:mimichat/providers/CallProvider.dart';
import 'package:mimichat/services/CallService.dart';
import 'package:mimichat/services/ImageService.dart';
import 'package:provider/provider.dart';

class IncomingCall extends StatelessWidget {
  final CallHistory call;
  bool camera = false;
  String callUrl = "";
  IncomingCall({super.key, required this.call, this.camera = false}) {
    callUrl = CallService.getCallURL(
        call.roomId, call.receiver.id, call.receiver.username, camera);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(20),
      width: width > 500 ? 350 : width * 0.7,
      height: 300,
      decoration: BoxDecoration(
        color: Color(0xFF363f48),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: width > 500 ? 1 : 0.7,
                child: FutureBuilder<Uint8List?>(
                  future: ImageService.getImage(call.caller.profilePicture!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Material(
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(snapshot.data!),
                            ),
                          ),
                        ),
                      );
                      // return Image.memory(snapshot.data!);
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Material(
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage("images/user-placeholder.jpg"),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: width > 500 ? 10 : 5),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${call.caller.fullName}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "is now calling",
                      style: TextStyle(color: Color(0xFFdbd7d7)),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Provider.of<CallProvider>(context, listen: false)
                      .incomingCall = null;
                  CallService.updateCall(call);
                  CallService.makeCall(callUrl);
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF00c3a5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Accept",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Provider.of<CallProvider>(context, listen: false)
                      .incomingCall = null;
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFe74c3c),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
