import 'package:flutter/material.dart';
import 'package:mimichat/dao/MessageWebSocket.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/services/ChatService.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:mimichat/views/widgets/ChatListItem.dart';

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
                  print("Salamo 3alaykom, $val");
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
            Expanded(
              child: FutureBuilder<List<Chat>>(
                  future: ChatService.getChats(currentUser.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Chat> chats = snapshot.data!;
                      // inspect(chats);
                      return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          MessageWebSocket msw = MessageWebSocket();
                          // msw.subscribeToPrivateChat(chats[index].id);

                          return ChatListItem(
                            chat: chats[index],
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
