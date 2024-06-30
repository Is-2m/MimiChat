import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mimichat/models/Friendship.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/services/ImageService.dart';
import 'package:mimichat/utils/AppStateManager.dart';

class ContactItem extends StatefulWidget {
  Friendship friendship;
  ContactItem({super.key, required this.friendship});

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  late User otherUser;
  // Future<Uint8List?>? _imageFuture;
  @override
  void initState() {
    super.initState();
    otherUser =
        widget.friendship.sender.isSamePersonAs(AppStateManager.currentUser!)
            ? widget.friendship.receiver
            : widget.friendship.sender;
    // _imageFuture = ImageService.getImage(otherUser.profilePicture!);
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
              child: Text(otherUser.fullName,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          subtitle: Container(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              otherUser.bio!,
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
                    otherUser.profilePicture!,
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
              //         child: Icon(Icons.person),
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
