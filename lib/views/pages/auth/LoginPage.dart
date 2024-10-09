import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mimichat/services/AuthService.dart';
import 'package:mimichat/utils/CustomColors.dart';
import 'package:mimichat/utils/Navigation.dart';
import 'package:mimichat/views/pages/auth/RegisterPage.dart';
import 'package:mimichat/views/pages/home/HomePage.dart';
import 'package:mimichat/views/widgets/AuthCustomButton.dart';
import 'package:mimichat/views/widgets/AuthInputField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;
  void _SignIn(BuildContext ctx, String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      AuthService.login(email, password).then((value) {
        if (value != null) {
          Navigation.pushReplacement(ctx, Homepage());
        } else {
          print("Invalid email or password");
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text("Invalid email or password"),
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
  void initState() {
    _emailController.text = "public.test.user@example.com";
    _passwordController.text = "1234567890";
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/images/logo.svg',
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
                  "Sign in",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Sign in to continue to MimiChat.",
                  style: TextStyle(color: Color(0xFF8B8FA7)),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: size.width *
                          (size.width > 1000
                              ? 0.4
                              : size.width > 800
                                  ? 0.6
                                  : 0.85),
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
                            onSubmitted: (val) => _SignIn(
                                context,
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
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors.purpple,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          AuthInputField(
                            hintText: "password",
                            type: TextInputType.visiblePassword,
                            onChanged: (val) {},
                            onSubmitted: (val) => _SignIn(
                                context,
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
                              label: "Sign in",
                              onPressed: () => _SignIn(
                                  context,
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
                      "Don't have an account?",
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
                          Navigation.pushReplacement(context, Registerpage());
                        },
                        child: Text(
                          "Sign up",
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
