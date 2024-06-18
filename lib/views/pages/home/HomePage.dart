import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mimichat/models/Chat.dart';
import 'package:mimichat/providers/ChatProvider.dart';
import 'package:mimichat/services/AuthService.dart';
import 'package:mimichat/utils/CustomColors.dart';
import 'package:mimichat/utils/Navigation.dart';
import 'package:mimichat/views/pages/auth/LoginPage.dart';
import 'package:mimichat/views/pages/home/ChatListPage.dart';
import 'package:mimichat/views/pages/home/ContactsPage.dart';
import 'package:mimichat/views/pages/home/ConversationPage.dart';
import 'package:mimichat/views/pages/home/ProfilePage.dart';
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
      Contactspage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 80,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SvgPicture.asset('images/logo.svg',
                      width: 40,
                      height: 40,
                      colorFilter: ColorFilter.mode(
                          CustomColors.purpple, BlendMode.srcIn),
                      semanticsLabel: 'MimiChat Logo'),
                  // Icon(
                  //   Icons.chat_bubble_rounded,
                  //   size: 30,
                  //   color: CustomColors.purpple,
                  // ),
                ),
                SizedBox(height: 20),
                Container(
                  color:
                      _selectedIndex == 0 ? CustomColors.BG_Grey : Colors.white,
                  padding: EdgeInsets.all(10),
                  child: IconButton(
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
                  color:
                      _selectedIndex == 1 ? CustomColors.BG_Grey : Colors.white,
                  padding: EdgeInsets.all(10),
                  child: IconButton(
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
                Container(
                  color:
                      _selectedIndex == 2 ? CustomColors.BG_Grey : Colors.white,
                  padding: EdgeInsets.all(10),
                  child: IconButton(
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
                Spacer(),
                Container(
                  child: IconButton(
                    padding: EdgeInsets.all(10),
                    icon: Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    onPressed: () async {
                      await AuthService.logout().then((val) {
                        Navigation.pushReplacement(context, LoginPage());
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            flex: 2,
            child: _pages[_selectedIndex],
          ),
          Expanded(
            flex: 5,
            child: chatProvider.showChat
                ? ConversationPage()
                : Container(
                    color:
                        Color(0xFFF7F7FF), // Placeholder for additional content
                    child: Center(
                        child: SvgPicture.asset(
                      'images/logo.svg',
                      width: 100,
                      height: 100,
                      colorFilter: ColorFilter.mode(
                          CustomColors.purpple.withOpacity(0.5),
                          BlendMode.srcIn),
                    )),
                  ),
          ),
        ],
      ),
    );
  }
}
