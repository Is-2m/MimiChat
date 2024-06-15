import 'package:flutter/material.dart';
import 'package:mimichat/Utils/CustomColors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.amber,
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.chat_bubble_rounded,
                size: 30,
                color: CustomColors.deepPurpple,
              ),
              SizedBox(width: 10),
              Text('MimiChat', style: TextStyle(fontSize: 30))
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Sign in",
            style: TextStyle(),
          )
        ])),
      ),
    );
  }
}
