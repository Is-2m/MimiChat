import 'package:flutter/material.dart';

class AuthCustomButton extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPressed;
  AuthCustomButton(
      {required this.color, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: color, width: 3)),
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
