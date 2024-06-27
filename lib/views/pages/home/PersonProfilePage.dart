import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mimichat/models/User.dart';
import 'package:mimichat/services/ImageService.dart';
import 'package:mimichat/services/UserService.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:mimichat/utils/CustomColors.dart';
import 'package:mimichat/views/pages/home/AddInfoPopup.dart';

class PersonProfilePage extends StatefulWidget {
  User user;
  PersonProfilePage({super.key, required this.user});

  @override
  State<PersonProfilePage> createState() => _PersonProfilePageState();
}

class _PersonProfilePageState extends State<PersonProfilePage> {
  @override
  Widget build(BuildContext context) {
    var user = widget.user;

    String dateOfBirth = "";
    if (user.birthDate!.isNotEmpty) {
      dateOfBirth =
          DateTime.fromMillisecondsSinceEpoch(int.parse(user.birthDate!))
              .toString()
              .split(" ")[0];
    }

    return Container(
        color: Color(0xFFF5F7FB),
        height: double.infinity,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<Uint8List?>(
                      future: ImageService.getImage(user.profilePicture!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
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
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        "${user.fullName}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text(
                          "@${user.username}",
                          style: TextStyle(color: Colors.grey[400]),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text.rich(
                          textAlign: TextAlign.justify,
                          TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                              text: "${user.bio!.isEmpty ? "-" : user.bio}")),
                    ),
                    Container(
                      color: Colors.white,
                      child: Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          expandedAlignment: Alignment.centerLeft,
                          title: Row(
                            children: [
                              Icon(
                                Icons.person_4_outlined,
                                color: Color(0xFF312d62),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Personal Info",
                                style: TextStyle(color: Color(0xFF312d62)),
                              ),
                              Spacer(),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: Material(
                                  elevation: 1,
                                  child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AddInfoPopup();
                                              });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          decoration: BoxDecoration(
                                            color: CustomColors.purpple
                                                .withOpacity(0.6),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                          children: [
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              title: Text(
                                "Full Name",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text("${user.fullName}"),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              title: Text(
                                "Username",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                  "@${user.username != "null" ? user.username : "-"}"),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              title: Text(
                                "Email",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text("${user.email}"),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              title: Text(
                                "Phone Number",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                  "${user.phone!.isEmpty ? "-" : user.phone}"),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              title: Text(
                                "Date of Birth",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text("${dateOfBirth}"),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
