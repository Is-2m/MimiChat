import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mimichat/services/AuthService.dart';
import 'package:mimichat/utils/CustomColors.dart';
import 'package:mimichat/utils/Navigation.dart';
import 'package:mimichat/views/pages/auth/LoginPage.dart';
import 'package:mimichat/views/pages/home/HomePage.dart';
import 'package:mimichat/views/widgets/AuthCustomButton.dart';
import 'package:mimichat/views/widgets/AuthInputField.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  bool isChecked = false;

  void _signUp(
      BuildContext ctx, String username, String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      await AuthService.register(username, email, password).then((val) {
        if (val != null) {
          Navigation.pushReplacement(
              ctx,
              Homepage(
                selectedIndex: 2,
              ));
        } else {
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text("An error occured"),
            backgroundColor: Colors.redAccent,
          ));
        }
      });
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text("Please fill all fields"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('images/logo.svg',
                        width: 30,
                        height: 30,
                        colorFilter: ColorFilter.mode(
                            CustomColors.purpple, BlendMode.srcIn),
                        semanticsLabel: 'MimiChat Logo'),
                    // Icon(
                    //   Icons.chat_bubble_rounded,
                    //   size: 30,
                    //   color: CustomColors.purpple,
                    // ),
                    SizedBox(width: 10),
                    Text('MimiChat', style: TextStyle(fontSize: 30))
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Get your MimiChat account now.",
                  style: TextStyle(color: Color(0xFF8B8FA7)),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Username",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          AuthInputField(
                            hintText: "Username",
                            type: TextInputType.text,
                            onChanged: (val) {},
                            onSubmitted: (val) => _signUp(
                                context,
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text),
                            controller: _usernameController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          AuthInputField(
                            hintText: "Email",
                            type: TextInputType.emailAddress,
                            onChanged: (val) {},
                            onSubmitted: (val) => _signUp(
                                context,
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text),
                            controller: _emailController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          AuthInputField(
                            hintText: "password",
                            type: TextInputType.visiblePassword,
                            onChanged: (val) {},
                            onSubmitted: (val) => _signUp(
                                context,
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text),
                            controller: _passwordController,
                            isPassword: true,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  value: isChecked,
                                  onChanged: (val) {
                                    setState(() {
                                      isChecked = val!;
                                    });
                                  },
                                  fillColor: WidgetStateProperty.resolveWith(
                                      (states) => CustomColors.BG_Grey),
                                  side: WidgetStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                      width: 0.3,
                                      color: Colors.grey
                                          .shade300, // color: Colors.transparent,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              Text(
                                "Remember me",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AuthCustomButton(
                              color: CustomColors.purpple,
                              label: "Sign up",
                              onPressed: () => _signUp(
                                  context,
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account ?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigation.pushReplacement(context, LoginPage());
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            color: CustomColors.purpple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ])),
        ),
      ),
    );
  }
}
