import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/providers/ChatsProvider.dart';
import 'package:mimichat/providers/SelectedChatProvider.dart';
import 'package:mimichat/services/ImageService.dart';
import 'package:mimichat/services/UserService.dart';
import 'package:mimichat/views/widgets/SearchPersonItem.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  Future<List<User>>? _searchResults;
  void _search(String name) {
    setState(() {
      _searchResults = UserService.searchUsersByName(name);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SelectedChatProvider selChaProvider =
        Provider.of<SelectedChatProvider>(context, listen: false);
    return Container(
        color: Color(0xFFF5F7FB),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Search For Contacts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onSubmitted: (val) {
                  _search(val);
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFFE6EBF5),
                  hintText: "Search for chats",
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
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
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Fvorites",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Consumer<ChatsProvider>(builder: (context, chatProvider, _) {
              return chatProvider.lstChats.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: chatProvider.lstChats.length,
                        itemBuilder: (context, index) {
                          User otherUser =
                              chatProvider.lstChats[index].getOtherUser();
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                selChaProvider.selectChat(
                                    chatProvider.lstChats[index].id);
                              },
                              child: Container(
                                height: 90,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          width: 100,
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE6EBF5),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                          child: Text(
                                            otherUser.firstName!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height: 75,
                                      alignment: Alignment.topCenter,
                                      child: Transform.scale(
                                        scale: 0.8,
                                        child: FutureBuilder<Uint8List?>(
                                          future: ImageService.getImage(
                                              otherUser.profilePicture!),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Container(
                                                padding: EdgeInsets.all(2),
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  child: Icon(Icons.person),
                                                ),
                                              );
                                            } else if (snapshot.hasData) {
                                              return CircleAvatar(
                                                radius: 50,
                                                backgroundImage:
                                                    MemoryImage(snapshot.data!),
                                              );
                                              // return Image.memory(snapshot.data!);
                                            } else {
                                              return Container(
                                                padding: EdgeInsets.all(2),
                                                child: CircleAvatar(
                                                  radius: 50,
                                                  child: Icon(Icons.person),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
            }),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Search Results",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
            Expanded(
                child: FutureBuilder<List<User>>(
                    future: _searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              User user = snapshot.data![index];
                              return SearchPersonItem(user: user);
                            });
                      } else {
                        return Center(
                          child: Text("No users found"),
                        );
                      }
                    })),
          ],
        ));
  }
}
