import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthInputField extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool isPassword;
  final TextInputType type;
  final TextEditingController controller ;
  bool showPassword = false;

  AuthInputField({
    this.isPassword = false,
    required this.hintText,
    required this.type,
    required this.onChanged,
    required this.onSubmitted,
    required this.controller,
  }) {
    showPassword = isPassword;
  }
  @override
  _AuthInputFieldState createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.showPassword,
      keyboardType: widget.type,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xfffcfcfd),
        hintText: widget.hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        hintStyle: TextStyle(fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
                color: Color(0xffe6ebf5), style: BorderStyle.solid, width: 0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
                color: Color(0xffe6ebf5), style: BorderStyle.solid, width: 0)),
        suffixIcon: !widget.isPassword
            ? null
            : IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  widget.showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    widget.showPassword = !widget.showPassword;
                  });
                },
              ),
      ),
    );
  }
}
