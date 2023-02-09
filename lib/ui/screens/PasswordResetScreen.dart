import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/ui/screens/LoginScreen.dart';
import 'package:peterjustesen/ui/screens/Tabs/MainScreen.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/constants/constants.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
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
          top: 182.h,
          right: 13.w,
          child: SizedBox(
              width: .9.sw,
              height: 600.h,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      "assets/images/email_reset.svg",
                      width: 219.w,
                      height: 219.h,
                    ),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  SizedBox(
                    width: 204.w,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Please check your email to reset password",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff284F49)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 36.h,
                  ),
                  callToActionButton(
                      width: 1.sw,
                      text: "Back to Login",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      }),
                ],
              )),
        )
      ]),
    );
  }
}
