import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/ui/screens/LoginScreen.dart';
import 'package:peterjustesen/ui/screens/PasswordResetScreen.dart';
import 'package:peterjustesen/ui/screens/Tabs/MainScreen.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../core/constants/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

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
              height: 600.h,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Forgot Password",
                      style: GoogleFonts.montserrat(fontSize: 28.sp, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login to your Peter Justesen account",
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
                    height: 36.h,
                  ),
                  callToActionButton(
                      width: 1.sw,
                      text: "Send to Email",
                      onPressed: () {
                        print(_emailController.text);
                        FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text).then((value) {
                          Fluttertoast.showToast(
                              msg: "Email sent",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0.sp);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PasswordResetScreen()),
                          );
                        });
                      }),
                ],
              )),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.asset(
            "assets/images/lock.svg",
            fit: BoxFit.cover,
            color: const Color(0xffE68314),
            width: 182.w,
            height: 182.h,
          ),
        ),
      ]),
    );
  }
}
