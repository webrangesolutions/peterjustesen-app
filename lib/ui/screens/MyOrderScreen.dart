import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peterjustesen/ui/screens/OrderdoneScreen.dart';
import 'package:peterjustesen/ui/screens/PaymentScreen.dart';
import 'package:peterjustesen/ui/widgets/AddToCartCard.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/bloc/cart_bloc.dart';
import '../../core/bloc/main_bloc/main_bloc.dart';
import '../../core/constants/constants.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  var ordersList = <Widget>[];
  var subscription;

  // var su


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
      appBar: PeterAppBar(title: "My Orders"),
      // bottomNavigationBar: PeterBottomNavigationBar(),
      body: Center(
        child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("orders").where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData && snapshot.data! != null) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ListView(
                          children: [
                            ...snapshot.data!.docs.map((e) => Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text(
                                          //   "Order ID: ${snapshot.data!.docs[index].id}",
                                          //   style: TextStyle(
                                          //     fontSize: 10.sp,
                                          //     fontWeight: FontWeight.w600,
                                          //   ),
                                          // ),
                                          Text(
                                            "Order Date: ${e['updated_at'].toDate().toString().substring(0, 10)}",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      itemCount: e['items'].length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        return FutureBuilder(
                                          future: FirebaseFirestore.instance.collection("products").doc(e['items'][i]['uid']).get().then((value) => value),
                                          builder: (context, productSnapshot) {
                                            return productSnapshot.hasData && productSnapshot.data != null
                                                ? AddToCartCard(
                                                    quantity: e['items'][i]['amount'],
                                                    title: e['items'][i]['title'],
                                                    isOrder: true,
                                                    price: productSnapshot.data!['price'],
                                                    image: productSnapshot.data!['thumbnail'][0],
                                                    context: context,
                                                    id: e['items'][i]['id'],
                                                    productId: e['items'][i]['uid'],
                                                    index: i,
                                                    variant: e['items'][i]['variant'],
                                                    subTitle: productSnapshot.data!['description'],
                                                  )
                                                : Container();
                                          },
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 13),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total: ${e['total']}",
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "Status: ${e['status']}",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("No Orders"),
                      );
                    }
                  }).scrollVertical(),
            )),
      ),
    );
  }
}
