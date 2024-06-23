import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:mimichat/views/pages/auth/LoginPage.dart';
import 'package:mimichat/views/pages/home/HomePage.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  var user = AppStateManager.currentUser;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    AppStateManager.getCurrentUser().then((value) {
      setState(() {
        // print("CurrentUSer $value");
        user = value;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : user == null
            ? LoginPage()
            : Homepage();
  }
}
