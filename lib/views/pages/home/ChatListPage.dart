import 'package:flutter/material.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/providers/ChatsProvider.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:mimichat/views/widgets/ChatListItem.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  ChatListPage();

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  TextEditingController _searchController = TextEditingController();
  User currentUser = AppStateManager.currentUser!;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("ChatListPage.build");
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
                  'Chats',
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
                  // print("Salamo 3alaykom, $val");
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
            Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recent",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
            Expanded(child:
                Consumer<ChatsProvider>(builder: (context, chatProvider, _) {
              return chatProvider.lstChats.isEmpty
                  ? Center(
                      child: Text("No chats found"),
                    )
                  : ListView.builder(
                      itemCount: chatProvider.lstChats.length,
                      itemBuilder: (context, index) {
                        Chat chat = chatProvider.lstChats[index];
                        return chat.messages.length == 0
                            ? Container()
                            : ChatListItem(
                                chat: chat,
                              );
                      },
                    );
            })),
          ],
        ));
  }
}
