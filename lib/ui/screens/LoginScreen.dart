import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/bloc/main_bloc/main_bloc.dart';
import 'package:peterjustesen/ui/screens/ForgotPasswordScreen.dart';
import 'package:peterjustesen/ui/screens/HomeScreen.dart';
import 'package:peterjustesen/ui/screens/SignupScreen.dart';
import 'package:peterjustesen/ui/screens/Tabs/MainScreen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
  });

    @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
            height: 1.sh,
            width: 1.sw,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
                opacity: 1,
              ),
            ),
            child: Container(
              color: Colors.white.withOpacity(0.87),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )),
        Positioned(
          top: 74.h,
          left: 24.w,
          child: Image.asset(
            "assets/images/PJ_logo_white 1.png",
            fit: BoxFit.cover,
            color: Colors.black,
            width: 178.w,
            height: 47.h,
          ),
        ),
        Positioned(
          top: 182,
          right: 13,
          child: SizedBox(
              width: .9.sw,
              height: 500.h,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Welcome back",
                      style: GoogleFonts.montserrat(fontSize: 28.sp, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login to your minifurus account",
                      style: GoogleFonts.montserrat(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 29.h,
                  ),
                  Container(
                    width: 340.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Email Address",
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    width: 340.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Password",
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.montserrat(fontSize: 14.sp, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ).onInkTap(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                  }),
                  SizedBox(
                    height: 37.h,
                  ),
                  callToActionButton(
                      width: 1.sw,
                      text: "Login",
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter email");
                          return;
                        }
                        if (_passwordController.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please enter password");
                          return;
                        }
                        FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((value) {
                          Fluttertoast.showToast(msg: "Login Successful");
                          BlocProvider.of<PeterMainBloc>(context).add(HomePageClicked());
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainScreen()),
                          );
                        }).catchError((e) {
                          Fluttertoast.showToast(msg: e.toString());
                        });
                      }),
                  SizedBox(
                    height: 19.h,
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: GoogleFonts.montserrat(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Create account Here",
                              style: GoogleFonts.montserrat(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  // Continue as a guest
                  Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Continue as a guest",
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        )
      ]),
    );
  }
}
