import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/bloc/main_bloc/main_bloc.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/PaymentScreen.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/bloc/cart_bloc.dart';

class AddEditAddressDetailsScreen extends StatefulWidget {
  final String id;
  const AddEditAddressDetailsScreen({super.key, required this.id});
  @override
  State<AddEditAddressDetailsScreen> createState() => _AddEditAddressDetailsScreenState();
}

class _AddEditAddressDetailsScreenState extends State<AddEditAddressDetailsScreen> {
  TextEditingController _nameController = TextEditingController(text: "");
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _phoneController = TextEditingController(text: "");
  TextEditingController _addressController = TextEditingController(text: "");

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
    Future.delayed(Duration.zero, () async {
      EasyLoading.show(status: "Loading...");
      if (widget.id != "") {
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("address").doc(widget.id).get().then((value) {
          _nameController.text = value.get("name");
          _emailController.text = value.get("email");
          _phoneController.text = value.get("phone");
          _addressController.text = value.get("address");
        });
      }
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PeterAppBar(title: "Add New Address"),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: VStack([
            7.heightBox,
            Text(
              "Delivery Details",
              style: custom_montserratTextTheme.headline1!.copyWith(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15.sp),
            ).pOnly(bottom: 16),
            13.heightBox,
            // text fields for full name, email, phone number, address
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
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
                  border: InputBorder.none,
                  hintText: "Full Name",
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            13.heightBox,
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
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
                  border: InputBorder.none,
                  hintText: "Email",
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            13.heightBox,
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
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
                  border: InputBorder.none,
                  hintText: "Phone Number",
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            13.heightBox,
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
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
                  border: InputBorder.none,
                  hintText: "Address",
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            22.heightBox,
            callToActionButton(
                width: 300.w,
                text: "Save Address",
                onPressed: () {
                  if (_nameController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter name");
                    return;
                  }
                  if (_emailController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please fill email");
                    return;
                  }
                  if (_phoneController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please fill phone number");
                    return;
                  }
                  if (_addressController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please fill address");
                    return;
                  }
                  if (widget.id != "") {
                    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("address").doc(widget.id).update({
                      "name": _nameController.text,
                      "email": _emailController.text,
                      "phone": _phoneController.text,
                      "address": _addressController.text,
                    });
                    Navigator.pop(context);
                    return;
                  } else {
                    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("address").add({
                      "name": _nameController.text,
                      "email": _emailController.text,
                      "phone": _phoneController.text,
                      "address": _addressController.text,
                    });
                    Navigator.pop(context);
                    return;
                  }
                })
          ]).p(28).scrollVertical(),
        ),
      ),
      // bottomNavigationBar: PeterBottomNavigationBar(),
    );
  }
}
