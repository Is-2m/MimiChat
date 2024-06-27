import 'package:flutter/material.dart';
import 'package:mimichat/models/Friendship.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/services/FriendshipService.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:mimichat/views/widgets/ContactItem.dart';

class Contactspage extends StatefulWidget {
  const Contactspage({super.key});

  @override
  State<Contactspage> createState() => _ContactspageState();
}

class _ContactspageState extends State<Contactspage> {
  TextEditingController _searchController = TextEditingController();
  Future<List<Friendship>>? _contacts;
  // void _search(String name) {
  //   setState(() {
  //     _searchResults = UserService.searchUsersByName(name);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _contacts = FriendshipService.getFriendshipsByUserId(
        AppStateManager.currentUser!.id);
  }

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
                  'Search For Friends',
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
                  // _search(val);
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
                child: FutureBuilder<List<Friendship>>(
                    future: _contacts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Friendship frndshp = snapshot.data![index];
                              return ContactItem(friendship: frndshp);
                            });
                      } else {
                        return Center(
                          child: Text("No contacts found"),
                        );
                      }
                    })),
          ],
        ));
  }
}
