import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CallPage extends StatefulWidget {
  String url;
  CallPage({
    super.key,
    required this.url,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    // if
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
