import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/ui/screens/LoginScreen.dart';
import 'package:peterjustesen/ui/screens/ProfileScreen.dart';
import 'package:peterjustesen/ui/screens/Tabs/MainScreen.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/bloc/cart_bloc.dart';
import '../../core/bloc/main_bloc/main_bloc.dart';
import '../../core/constants/constants.dart';

class OrderDoneScreen extends StatefulWidget {
  const OrderDoneScreen({super.key});

  @override
  State<OrderDoneScreen> createState() => _OrderDoneScreenState();
}

class _OrderDoneScreenState extends State<OrderDoneScreen> {
  var subscription;

  // var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //   if (result == ConnectivityResult.none) {
  //     Fluttertoast.showToast(msg: "No Internet Connection");
  //   }
  // });

    @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Network Issue'),
                content:
                Text('Internet connection is not avialble! try later.'),
                actions: [
                  TextButton(onPressed: () {
                    print('work');
                    Navigator.pop(context);
                  }, child: Text('Cancel'))
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BlocProvider.value(
      //   value: BlocProvider.of<PeterMainBloc>(context),
      //   child: PeterBottomNavigationBar(),
      // ),
      body: ListView(children: [
        Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.white.withOpacity(0.87),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            right: 17.w,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  children: [
                    Transform(
                      transform: Matrix4.translationValues(-15.w, 0.0, 0.0),
                      child: SvgPicture.asset(
                        "assets/images/tick.svg",
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
                          "Your Order has been accepted",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36.h,
                    ),
                    SizedBox(
                      width: 274.w,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Your item is being processed! A confirmation email will be sent to you!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 36.h,
                    ),
                    callToActionButton(
                        width: 1.sw,
                        text: "My Order",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          );
                        }),
                  ],
                )),
          )
        ]),
      ]),
    );
  }
}
