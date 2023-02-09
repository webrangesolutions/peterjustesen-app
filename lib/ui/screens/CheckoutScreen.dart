import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/PaymentScreen.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/bloc/cart_bloc.dart';
import '../../core/bloc/main_bloc/main_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  final num total;

  CheckoutScreen({super.key, required this.total});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var shipping = 37.37;
  var state = "Lagos N5000";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  bool saveAddress = false;

  var subscription;

  // var subscription =
  //     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //   if (result == ConnectivityResult.none) {
  //     Fluttertoast.showToast(msg: "No Internet Connection");
  //   }
  // });

  @override
  void initState() {
    getData();
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

  getData() async {
    int i = 0;
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('address')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["email"]);
        if (i == 0) {
          _nameController.text = doc["name"];
          _emailController.text = doc["email"];
          _phoneController.text = doc["phone"];
          _addressController.text = doc["address"];
          i++;
        }
        i++;
      });
    });
    // var data = await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection('address').doc("").get();
    // _nameController.text = data["name"];
    // _emailController.text = data["email"];
    // _phoneController.text = data["phone"];
    // _addressController.text = data["address"];
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PeterAppBar(title: "Checkout"),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(23, 23, 23, 0),
            child: VStack([
              Text(
                "Select delivery state",
                style: custom_montserratTextTheme.headline1!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp),
              ).pOnly(bottom: 16),
              DropdownButtonFormField(
                icon: SvgPicture.asset(
                  "assets/images/dropdownarrow.svg",
                  height: 11.h,
                  width: 11.w,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.r),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.r),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                style: custom_montserratTextTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 13.sp),
                items: [
                  DropdownMenuItem(
                    child: Text("Lagos N5000"),
                    value: "Lagos N5000",
                  ),
                  DropdownMenuItem(
                    child: Text("Abuja N6000"),
                    value: "Abuja N6000",
                  ),
                  DropdownMenuItem(
                    child: Text("Port Harcourt N7000"),
                    value: "Port Harcourt N7000",
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    state = value.toString();
                  });
                },
                value: "Lagos N5000",
              ),
              27.heightBox,
              Text(
                "Delivery Details",
                style: custom_montserratTextTheme.headline1!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp),
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
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

              18.heightBox,
              HStack([
                RoundCheckBox(
                  size: 16,
                  border: Border.all(color: Colors.black, width: 1),
                  onTap: (selected) {
                    saveAddress = selected!;
                  },
                  checkedColor: primaryColor,
                  checkedWidget: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15,
                  ),
                  animationDuration: Duration(milliseconds: 50),
                ),
                10.widthBox,
                Text(
                  "Save Address",
                  style: custom_montserratTextTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                ),
              ]),
              21.heightBox,
              Container(
                width: 340.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: VStack([
                  HStack(
                    [
                      Text(
                        "Subtotal",
                        style: custom_montserratTextTheme.headline1!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                      Spacer(),
                      Text(
                        "EUR ${widget.total}",
                        style: custom_montserratTextTheme.headline1!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                    ],
                  ),
                  13.heightBox,
                  HStack(
                    [
                      Text(
                        "Shipping",
                        style: custom_montserratTextTheme.headline1!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                      Spacer(),
                      Text(
                        "EUR $shipping",
                        style: custom_montserratTextTheme.headline1!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                    ],
                  ),
                  26.heightBox,
                  HStack(
                    [
                      Text(
                        "Total",
                        style: custom_montserratTextTheme.headline1!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                      Spacer(),
                      Text(
                        "EUR ${widget.total}",
                        style: custom_montserratTextTheme.headline1!.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp),
                      ),
                    ],
                  ),
                  22.heightBox,
                  callToActionButton(
                      width: 300.w,
                      text: "Pay Now",
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
                          Fluttertoast.showToast(
                              msg: "Please fill phone number");
                          return;
                        }
                        if (_addressController.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please fill address");
                          return;
                        }
                        if (saveAddress) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("address")
                              .add({
                            "name": _nameController.text,
                            "email": _emailController.text,
                            "phone": _phoneController.text,
                            "address": _addressController.text,
                            "state": state,
                          });
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      address: _addressController.text,
                                      total: widget.total,
                                    )));
                      })
                ]).p(28),
              ).box.rounded.outerShadow.make(),
              40.heightBox,
            ]).scrollVertical(),
          ),
        ),
      ),
      // bottomNavigationBar: PeterBottomNavigationBar(),
    );
  }
}
