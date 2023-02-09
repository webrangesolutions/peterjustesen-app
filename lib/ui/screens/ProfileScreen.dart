import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/AddressDetailsScreen.dart';
import 'package:peterjustesen/ui/screens/LoginScreen.dart';
import 'package:peterjustesen/ui/screens/MyOrderScreen.dart';
import 'package:peterjustesen/ui/screens/NotificationsScreen.dart';
import 'package:peterjustesen/ui/screens/OrderDoneScreen.dart';
import 'package:peterjustesen/ui/screens/ReviewsScreen.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/bloc/cart_bloc.dart';
import '../../core/bloc/main_bloc/main_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        appBar: PeterAppBarOne(title: "Profile"),
        // bottomNavigationBar: BlocProvider.value(
        //   value: BlocProvider.of<PeterMainBloc>(context),
        //   child: PeterBottomNavigationBar(),
        // ),
        body: ListView(children: [
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 45.w,
                backgroundImage: AssetImage("assets/images/profile.png"),
              ),
              SizedBox(
                width: 10.w,
              ),
              VStack([
                Text(
                  FirebaseAuth.instance.currentUser!.displayName!,
                  style: GoogleFonts.montserrat(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.email!,
                  style: GoogleFonts.montserrat(fontSize: 16.sp, fontWeight: FontWeight.normal),
                ),
              ]),
            ],
          ).p24(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Orders
              ListTile(
                leading: SvgPicture.asset(
                  "assets/images/orders.svg",
                  width: 24.w,
                  height: 24.h,
                ),
                title: Text(
                  "Orders",
                  style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15.sp,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrderScreen(),
                    ),
                  );
                },
              ),
              Divider(
                color: Color(0xFFE2E2E2),
                thickness: 1,
              ),
              ListTile(
                leading: SvgPicture.asset(
                  "assets/images/details.svg",
                  width: 24.w,
                  height: 24.h,
                ),
                title: Text(
                  "My Details",
                  style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15.sp,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewsScreen(),
                    ),
                  );
                },
              ),
              Divider(
                color: Color(0xFFE2E2E2),
                thickness: 1,
              ),
              // Delivery Address
              ListTile(
                leading: SvgPicture.asset(
                  "assets/images/address.svg",
                  width: 24.w,
                  height: 24.h,
                ),
                title: Text(
                  "Delivery Address",
                  style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15.sp,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressDetailsScreen(),
                    ),
                  );
                },
              ),
              Divider(
                color: Color(0xFFE2E2E2),
                thickness: 1,
              ),
              // Notifications
              ListTile(
                leading: SvgPicture.asset(
                  "assets/images/bell.svg",
                  width: 24.w,
                  height: 24.h,
                ),
                title: Text(
                  "Notifications",
                  style: GoogleFonts.montserrat(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 15.sp,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(),
                    ),
                  );
                },
              ),
              Divider(
                color: Color(0xFFE2E2E2),
                thickness: 1,
              ),
              30.heightBox,
              callToActionButton(
                  width: .8.sw,
                  text: "Logout",
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  }),
            ],
          ),
        ]));
  }
}
