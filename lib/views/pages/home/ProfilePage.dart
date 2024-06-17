import 'package:flutter/material.dart';
import 'package:mimichat/utils/CustomColors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFF5F7FB),
        height: double.infinity,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    iconColor: Colors.grey[500],
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(fontSize: 16),
                        ),
                        value: 1,
                      ),
                    ],
                    onSelected: (value) {
                      print(value);
                    },
                  )
                ],
              ),
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: CustomColors.BG_Grey,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/avatar-1.jpg'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        "Full Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text(
                          "@username",
                          style: TextStyle(color: Colors.grey[400]),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(),
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
                              text:
                                  "If several languages coalesce, the grammar of the resulting language is more simple and regular than that of the individual.")),
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
                                "About",
                                style: TextStyle(color: Color(0xFF312d62)),
                              ),
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
                              subtitle: Text("Soufiane ISAM"),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              title: Text(
                                "Username",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text("@Is2m"),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              title: Text(
                                "Email",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text("isam@example.com"),
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
