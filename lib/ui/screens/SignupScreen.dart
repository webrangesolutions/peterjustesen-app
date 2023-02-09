import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/services/notificationsApi.dart';
import 'package:peterjustesen/ui/screens/HomeScreen.dart';
import 'package:peterjustesen/ui/screens/LoginScreen.dart';
import 'package:peterjustesen/ui/screens/Tabs/MainScreen.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../../core/constants/constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool? _isChecked = false;
  bool _obscureText = true;

  var subscription =
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
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
                      "Create Account",
                      style: GoogleFonts.montserrat(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Enter your details for a new account",
                      style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Full Name",
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.h, horizontal: 10.w),
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Email Address",
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.h, horizontal: 10.w),
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
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 1),
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
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                    alignment: Alignment.centerLeft,
                    child: Row(children: [
                      RoundCheckBox(
                        isChecked: _isChecked,
                        size: 20,
                        border: Border.all(color: Colors.black, width: 1),
                        onTap: (selected) {
                          setState(() {
                            _isChecked = selected;
                          });
                        },
                        checkedColor: primaryColor,
                        checkedWidget: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                        animationDuration: Duration(milliseconds: 50),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'I accept the ',
                          style: GoogleFonts.montserrat(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Terms of Service',
                                style: GoogleFonts.montserrat(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w400,
                                    color: primaryColor)),
                            TextSpan(
                                text: ' & ',
                                style: GoogleFonts.montserrat(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black)),
                            TextSpan(
                                text: 'Privacy Policy',
                                style: GoogleFonts.montserrat(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w400,
                                    color: primaryColor)),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  callToActionButton(
                      width: 1.sw,
                      text: "Create Account",
                      onPressed: () {
                        if (_nameController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please enter your name",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (_emailController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please enter your email",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (_passwordController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please enter your password",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (_passwordController.text.length < 6) {
                          Fluttertoast.showToast(
                              msg: "Password must be at least 6 characters",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (_isChecked == false) {
                          Fluttertoast.showToast(
                              msg: "Please accept the terms and conditions",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) {
                            NotificationsApi.getToken().then((token) {
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(value.user!.uid)
                                  .set({
                                "displayName": _nameController.text,
                                "email": _emailController.text,
                                "created_on": DateTime.now(),
                                "disabled": false,
                                "gender": "",
                                "phoneNumber": "",
                                "photoURL":
                                    "https://firebasestorage.googleapis.com/v0/b/peterjustesen-37e4f.appspot.com/o/profile_images%2Fprofile_image_user_04LpU7uprrZySaOnZDZ2X7E2Lqq1?alt=media&token=57d7f6b6-7f15-4dd8-9c3e-b2b914bfebb1",
                                "uid": value.user!.uid,
                                "updated": DateTime.now(),
                                "saved": [],
                                "favorites": [],
                                'token': token,
                                "cart": [],
                                "total_amount" : 0
                              });
                            });
                          }).then((value) {
                            FirebaseAuth.instance.currentUser!
                                .updateDisplayName(_nameController.text)
                                .then((value) {
                              Fluttertoast.showToast(
                                  msg: "Account created",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()),
                              );
                            });
                          }).catchError((error) {
                            Fluttertoast.showToast(
                                msg: error.toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          });
                        }
                      }),
                  SizedBox(
                    height: 19.h,
                  ),
                  // Already have an account? Login Here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: Text(
                          "Login Here",
                          style: GoogleFonts.montserrat(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ),
                    ],
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
                            fontSize: 12.sp,
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
