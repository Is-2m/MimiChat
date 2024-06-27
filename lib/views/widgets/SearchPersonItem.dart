import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/services/ImageService.dart';

class SearchPersonItem extends StatefulWidget {
  final User user;
  SearchPersonItem({super.key, required this.user});

  @override
  State<SearchPersonItem> createState() => _SearchPersonItemState();
}

class _SearchPersonItemState extends State<SearchPersonItem> {
  Future<Uint8List?>? _imageFuture;
  @override
  void initState() {
    super.initState();

    _imageFuture = ImageService.getImage(widget.user.profilePicture!);
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
          onTap: () {},
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
              child: FutureBuilder<Uint8List?>(
                future: _imageFuture,
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
