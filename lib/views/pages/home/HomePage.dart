import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/providers/CallProvider.dart';
import 'package:mimichat/providers/SelectedChatProvider.dart';
import 'package:mimichat/services/AuthService.dart';
import 'package:mimichat/services/ChatService.dart';
import 'package:mimichat/sockets/WebSocketsHandler.dart';
import 'package:mimichat/sockets/WsStompMessages.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:mimichat/utils/CustomColors.dart';
import 'package:mimichat/utils/Navigation.dart';
import 'package:mimichat/views/pages/auth/LoginPage.dart';
import 'package:mimichat/views/pages/home/ChatListPage.dart';
import 'package:mimichat/views/pages/home/ContactsPage.dart';
import 'package:mimichat/views/pages/home/ConversationPage.dart';
import 'package:mimichat/views/pages/home/ProfilePage.dart';
import 'package:mimichat/views/pages/home/ContactsPage.dart';
import 'package:mimichat/views/widgets/IncomingCall.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  int? selectedIndex = 0;
  Homepage({this.selectedIndex});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  Chat? currentChat;
  late SelectedChatProvider selectedChatProvider;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
    _pages = [
      ChatListPage(),
      ContactsPage(),
      ProfilePage(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedChatProvider =
        Provider.of<SelectedChatProvider>(context, listen: false);
    ChatService.getChats(userId: AppStateManager.currentUser!.id, ctx: context);

    WsStompMessage.newSubscribe(
      userID: AppStateManager.currentUser!.id,
      onDataReceived: (body) {
        WebSocketsHandler.wsHandler(context, body);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              // Sidebar Navigation
              Container(
                width: 80,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: SvgPicture.asset('assets/images/logo.svg',
                                width: 40,
                                height: 40,
                                colorFilter: ColorFilter.mode(
                                    CustomColors.purpple, BlendMode.srcIn),
                                semanticsLabel: 'MimiChat Logo'),
                          ),
                          SizedBox(height: 20),
                          Container(
                            color: _selectedIndex == 0
                                ? CustomColors.BG_Grey
                                : Colors.white,
                            padding: EdgeInsets.all(10),
                            child: IconButton(
                              tooltip: "Chats",
                              padding: EdgeInsets.all(10),
                              icon: Icon(
                                Icons.chat_bubble_outline,
                                color: _selectedIndex == 0
                                    ? CustomColors.purpple
                                    : Colors.grey[500],
                                size: 25,
                              ),
                              onPressed: () => _onItemTapped(0),
                            ),
                          ),
                          Container(
                            color: _selectedIndex == 1
                                ? CustomColors.BG_Grey
                                : Colors.white,
                            padding: EdgeInsets.all(10),
                            child: IconButton(
                              tooltip: "Contacts",
                              padding: EdgeInsets.all(10),
                              icon: Icon(
                                Icons.contacts_outlined,
                                color: _selectedIndex == 1
                                    ? CustomColors.purpple
                                    : Colors.grey[500],
                                size: 25,
                              ),
                              onPressed: () => _onItemTapped(1),
                            ),
                          ),
                          // Container(
                          //   color: _selectedIndex == 2
                          //       ? CustomColors.BG_Grey
                          //       : Colors.white,
                          //   padding: EdgeInsets.all(10),
                          //   child: IconButton(
                          //     tooltip: "Search",
                          //     padding: EdgeInsets.all(10),
                          //     icon: Icon(
                          //       Icons.search_outlined,
                          //       color: _selectedIndex == 2
                          //           ? CustomColors.purpple
                          //           : Colors.grey[500],
                          //       size: 30,
                          //     ),
                          //     onPressed: () => _onItemTapped(2),
                          //   ),
                          // ),
                          Container(
                            color: _selectedIndex == 2
                                ? CustomColors.BG_Grey
                                : Colors.white,
                            padding: EdgeInsets.all(10),
                            child: IconButton(
                              tooltip: "Profile",
                              padding: EdgeInsets.all(10),
                              icon: Icon(
                                Icons.person_outline,
                                color: _selectedIndex == 2
                                    ? CustomColors.purpple
                                    : Colors.grey[500],
                                size: 30,
                              ),
                              onPressed: () => _onItemTapped(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: IconButton(
                        padding: EdgeInsets.all(10),
                        tooltip: "Logout",
                        icon: Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.redAccent,
                          size: 30,
                        ),
                        onPressed: () async {
                          await AuthService.logout(AppStateManager.currentUser!)
                              .then((val) {
                            Navigation.pushReplacement(context, LoginPage());
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<SelectedChatProvider>(
                builder: (context, selectedChatProvider, child) {
                  return _buildSelectedPage(
                      width,
                      selectedChatProvider.selectedChat,
                      _pages[_selectedIndex]);
                },
              ),
              Consumer<SelectedChatProvider>(
                builder: (context, selectedChatProvider, child) {
                  return _buildConversationPAge(
                      width, selectedChatProvider.selectedChat);
                },
              ),
            ],
          ),
          Positioned(
            left: 90,
            top: 20,
            child:
                Consumer<CallProvider>(builder: (context, callProvider, child) {
              return callProvider.incomingCall == null
                  ? SizedBox.shrink()
                  : IncomingCall(call: callProvider.incomingCall!);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPage(double width, String? chatID, Widget org) {
    Widget wid = Container();

    if (chatID == null) {
      if (width > 700) {
        wid = Expanded(
          child: org,
          flex: width < 1100 ? 3 : 2,
        );
      } else {
        wid = Expanded(child: org);
      }
    } else {
      if (width > 700) {
        wid = Expanded(
          child: org,
          flex: 2,
        );
      }
    }
    return wid;
  }

  Widget _buildConversationPAge(double width, String? chatID) {
    Widget wid = Container();
    if (chatID == null) {
      if (width > 700) {
        wid = Expanded(
          child: Container(
            color: Color(0xFFF7F7FF), // Placeholder for additional content
            child: Center(
                child: SvgPicture.asset(
              'assets/images/logo.svg',
              width: 100,
              height: 100,
              colorFilter: ColorFilter.mode(
                  CustomColors.purpple.withOpacity(0.5), BlendMode.srcIn),
            )),
          ),
          flex: 5,
        );
      }
    } else {
      if (width > 700) {
        wid = Expanded(
          child: ConversationPage(),
          flex: 5,
        );
      } else {
        wid = Expanded(child: ConversationPage());
      }
    }
    return wid;
  }
}
