import 'package:flutter/material.dart';
import 'package:mimichat/utils/CustomColors.dart';

class PersonProfile extends StatefulWidget {
  final VoidCallback onPressed;
  const PersonProfile({required this.onPressed});

  @override
  State<PersonProfile> createState() => _PersonProfileState();
}

class _PersonProfileState extends State<PersonProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: Colors.grey[300]!,
            width: 3,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    widget.onPressed();
                  },
                  icon: Icon(Icons.close),
                ),
              )),
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
                    backgroundImage: AssetImage('images/avatar-2.jpg'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    "Full Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      "@username",
                      style: TextStyle(color: Colors.grey[400]),
                    )),
                Container(
                  // width: ,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.greenAccent,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      Text(
                        "Friend",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
