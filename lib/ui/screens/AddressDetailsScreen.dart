import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/AddEditAddressDetailsScreen.dart';
import 'package:peterjustesen/ui/screens/PaymentScreen.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/bloc/cart_bloc.dart';
import '../../core/bloc/main_bloc/main_bloc.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  // var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //   if (result == ConnectivityResult.none) {
  //     Fluttertoast.showToast(msg: "No Internet Connection");
  //   }
  // });
  var subscription;

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
      appBar: const PeterAppBar(title: "Delivery Address"),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          // 7.heightBox,
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("address").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.length > 0) {
                  return SizedBox(
                    height: 167.h * snapshot.data!.docs.length,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return AddressCard(
                            name: snapshot.data!.docs[index]["name"],
                            address: snapshot.data!.docs[index]["address"],
                            phone: snapshot.data!.docs[index]["phone"],
                            email: snapshot.data!.docs[index]["email"],
                            id: snapshot.data!.docs[index].id,
                          ).box.size(329.w, 147.h).make().pOnly(bottom: 16);
                        }),
                  );
                } else {
                  return const Text("No data");
                }
                return const Text("No data");
              }),
          6.heightBox,
          callToActionButton(
              width: 340.w,
              text: "Add new address",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditAddressDetailsScreen(
                              id: "",
                            )));
              })
        ]).p(28).scrollVertical(),
      ),
      // bottomNavigationBar: BlocProvider.value(
      //   value: BlocProvider.of<PeterMainBloc>(context),
      //   child: BlocProvider.value(
      //     value: BlocProvider.of<CartBloc>(context),
      //     child: PeterBottomNavigationBar(),
      //   ),
      // ),
    );
  }
}

class AddressCard extends StatelessWidget {
  String name;
  String address;
  String phone;
  String email;
  String id;

  AddressCard({
    Key? key,
    required this.address,
    required this.email,
    required this.id,
    required this.name,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: VStack([
          HStack(alignment: MainAxisAlignment.spaceBetween, [
            "$name".text.size(20).semiBold.make(),
            Icon(FontAwesomeIcons.edit).onInkTap(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEditAddressDetailsScreen(
                          id: id,
                        )),
              );
            }),
          ]).wFull(context),
          10.heightBox,
          Text(
            "$address",
            style: custom_montserratTextTheme.titleSmall!.copyWith(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 14.sp),
          ),
          10.heightBox,
          Flexible(
            child: Text(
              "$phone",
              style: custom_montserratTextTheme.titleSmall!.copyWith(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 14.sp),
            ),
          ),
        ]),
      ),
    );
  }
}
