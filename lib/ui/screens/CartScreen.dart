import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/bloc/cart_bloc.dart';
import 'package:peterjustesen/core/bloc/main_bloc/main_bloc.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/CheckoutScreen.dart';
import 'package:peterjustesen/ui/screens/HomeScreen.dart';
import 'package:peterjustesen/ui/widgets/AddToCartCard.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:velocity_x/velocity_x.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var total = 37;

  var subscription;

  bool cartLoading = false;

  // var subscription =
  //     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
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
    EasyLoading.dismiss();

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
                  TextButton(
                      onPressed: () {
                        print('work');
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'))
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PeterAppBarOne(title: "Cart"),
      body: cartLoading == false ?
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:
        VStack([
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                List<dynamic> items = [];
                if(snapshot.hasData){
                  items = snapshot.data!.data()!["cart"].length > 0 ? snapshot.data!.data()!["cart"] : [];
                  items.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
                }

                return !snapshot.hasData
                    ? Container()
                    : snapshot.data!.data()!["cart"].length > 0
                        ? VStack(items
                            .map<Widget>((c) => Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('products')
                                                    .doc(c['uid'])
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container(
                                                        height: 87.h,
                                                        width: 87.w,
                                                        child: Center(
                                                            child:
                                                                CupertinoActivityIndicator()));
                                                  } else {
                                                    return Flexible(
                                                      child: Image(
                                                        image: NetworkImage(
                                                            '${snapshot.data!['thumbnail'][0]}'),
                                                        height: 87.h,
                                                        width: 87.w,
                                                      ),
                                                    );
                                                  }
                                                }),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('${c['title']}',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                          0xff000000),
                                                    )),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('products')
                                                        .doc(c['uid'])
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Text(
                                                          'Loading...',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: const Color(
                                                                0xff999999),
                                                          ),
                                                        );
                                                      } else {
                                                        return Text(
                                                          '${snapshot.data!['description']}',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: const Color(
                                                                0xff999999),
                                                          ),
                                                        );
                                                      }
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              var cart = FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .get()
                                                  .then((value) => value.data()!["cart"]);
                                              cart
                                                  .then((cartValue) => FirebaseFirestore
                                                  .instance
                                                  .collection("users")
                                                  .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                                  .update({
                                                "cart": cartValue
                                                    .where(
                                                        (e) => e["id"] != c['id'])
                                                    .toList(),
                                              }))
                                                  .then((value) => FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                                  .get()
                                                  .then((value) {
                                                var totalAmount = num.parse(value
                                                    .data()!["total_amount"]
                                                    .toString());
                                                var price = num.parse(c['price']
                                                    .replaceAll(',', '.'));
                                                var quantity = num.parse(
                                                    c['amount'].toString());
                                                var newTotalAmount =
                                                    totalAmount - (price * quantity);
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                    .update({
                                                  "total_amount":
                                                  newTotalAmount.toString(),
                                                });
                                              }));
                                            },
                                            child: SvgPicture.asset(
                                              "assets/images/cross.svg",
                                            ).p(12),
                                          ),
                                          SizedBox(height: 5.h,),
                                          Text(
                                            "EUR ${c['price']}",
                                            style: custom_montserratTextTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color:
                                                        const Color(0xff000000),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.sp),
                                          ).pOnly(right: 10.w),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          HStack(
                                            alignment:
                                                MainAxisAlignment.spaceBetween,
                                            [
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    cartLoading = true;
                                                  });

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .get()
                                                      .then((doc) async {
                                                    if (c['amount'] > 1) {
                                                      var x;

                                                      setState(() {
                                                        x = c;
                                                      });

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update({
                                                        'cart': FieldValue
                                                            .arrayRemove([c])
                                                      });

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update({
                                                        'total_amount': doc.get(
                                                                'total_amount') -
                                                            num.parse(x['price']
                                                                .replaceAll(
                                                                    ',', '.')),
                                                        'cart': FieldValue
                                                            .arrayUnion([
                                                          {
                                                            'id': x['id'],
                                                            'amount':
                                                                x['amount'] - 1,
                                                            'price': x['price'],
                                                            'title': x['title'],
                                                            'timestamp':
                                                                x['timestamp'],
                                                            'uid': x['uid'],
                                                            'variant':
                                                                x['variant']
                                                          }
                                                        ])
                                                      });

                                                      setState(() {
                                                        cartLoading = false;
                                                      });

                                                    } else {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update({
                                                        'cart': FieldValue
                                                            .arrayRemove([c])
                                                      });

                                                      setState(() {
                                                        cartLoading = false;
                                                      });
                                                    }
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/images/minus.svg",
                                                  color: Colors.black,
                                                  height: 22.h,
                                                  width: 22.w,
                                                ),
                                              ),
                                              8.widthBox,
                                              Text(
                                                "${c['amount']}",
                                                style: custom_poppinsTextTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                              8.widthBox,
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    cartLoading = true;
                                                  });

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .get()
                                                      .then((doc) async {
                                                    var x;

                                                    setState(() {
                                                      x = c;
                                                    });

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .update({
                                                      'cart': FieldValue
                                                          .arrayRemove([x])
                                                    });

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .update({
                                                      'total_amount': doc.get(
                                                              'total_amount') +
                                                          num.parse(x['price']
                                                              .replaceAll(
                                                                  ',', '.')),
                                                      'cart': FieldValue
                                                          .arrayUnion([
                                                        {
                                                          'id': x['id'],
                                                          'amount':
                                                              x['amount'] + 1,
                                                          'price': x['price'],
                                                          'title': x['title'],
                                                          'timestamp':
                                                              x['timestamp'],
                                                          'uid': x['uid'],
                                                          'variant':
                                                              x['variant']
                                                        }
                                                      ])
                                                    });
                                                  });

                                                  setState(() {
                                                    cartLoading = false;
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  "assets/images/plus.svg",
                                                  color: Colors.black,
                                                  height: 22.h,
                                                  width: 22.w,
                                                ),
                                              ),
                                            ],
                                          ).px(12)
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                            .toList())
                        : Container();
              }),
          Center(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Container()
                          : HStack(alignment: MainAxisAlignment.center, [
                              RichText(
                                text: TextSpan(
                                  text: 'Total: ',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff999999),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          'EUR ${double.parse(snapshot.data!["total_amount"].toString()).toStringAsFixed(2).toString()}',
                                      // text: "hello",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ).px(8),
                              12.widthBox,
                              callToActionButton(
                                  width: 164.w,
                                  text: "Checkout",
                                  onPressed: () {
                                    num.parse(snapshot.data!["total_amount"]
                                                .toString()) !=
                                            0
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckoutScreen(
                                                      total: num.parse(snapshot
                                                          .data!["total_amount"]
                                                          .toString()),
                                                    )),
                                          )
                                        : Fluttertoast.showToast(
                                            msg: "Cart is empty");
                                  }),
                            ]).wFull(context);
                    }),
              ),
            ),
          )
        ]),
      ).pOnly(top: 20).scrollVertical() : Container(
          height: 300.h,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircularProgressIndicator(),
            SizedBox(height: 30,),
            Text('Loading...', style:
            GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight:
              FontWeight.w700,
              color: const Color(
                  0xff000000),
            ))
          ])),
      // bottomNavigationBar: const PeterBottomNavigationBar()
    );
  }

  fetchProduct(uid, opt) async {
    var msg = {};

    await FirebaseFirestore.instance
        .collection('products')
        .doc(uid)
        .get()
        .then((value) {
      if (opt == 'title') {
        msg.addAll({'success': true, 'title': value.get('title')});
      } else if (opt == 'img') {
        msg.addAll({'success': true, 'img': value.get('thumbnail')[0]});
      } else if (opt == 'price') {
        msg.addAll({'success': true, 'price': value.get('price')});
      } else {
        msg.addAll({'success': true, 'description': value.get('description')});
      }
    }).catchError((e) {
      msg.addAll({'success': false});
    });

    return msg;
  }
}

/////
// last cart

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});
//
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   var total = 37;
//
//   var subscription;
//
//   // var subscription =
//   //     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//   //   if (result == ConnectivityResult.none) {
//   //     Fluttertoast.showToast(msg: "No Internet Connection");
//   //   }
//   // });
//
//   @override
//   dispose() {
//     super.dispose();
//
//     subscription.cancel();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     EasyLoading.dismiss();
//
//     subscription = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       if (result == ConnectivityResult.none) {
//         showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Network Issue'),
//                 content:
//                 Text('Internet connection is not avialble! try later.'),
//                 actions: [
//                   TextButton(onPressed: () {
//                     print('work');
//                     Navigator.pop(context);
//                   }, child: Text('Cancel'))
//                 ],
//               );
//             });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const PeterAppBarOne(title: "Cart"),
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: VStack([
//           StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection("users")
//                   .doc(FirebaseAuth.instance.currentUser!.uid)
//                   .snapshots(),
//               builder: (context, snapshot) {
//
//                 return !snapshot.hasData
//                     ? Container()
//                     : snapshot.data!.data()!["cart"].length > 0
//                     ? ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: snapshot.data!.data()!["cart"].length,
//                   itemBuilder: (context, index) {
//                     List<dynamic> items =
//                     snapshot.data!.data()!["cart"];
//                     items.sort((a, b) =>
//                         b['timestamp'].compareTo(a['timestamp']));
//                     var x = items[index];
//
//                     return items.length < 1
//                         ? 70
//                         .heightBox
//                         .pOnly(top: 20)
//                         .box
//                         .roundedSM
//                         .color(const Color(0xFF212C62))
//                         .make()
//                         .p20()
//                         .shimmer(
//                       primaryColor: const Color(0xFF212C62),
//                       secondaryColor:
//                       Color.fromARGB(255, 93, 105, 161),
//                     )
//                         : x["amount"] > 0 ? AddToCartCard(
//                       id: x["id"],
//                       productId: x["uid"],
//                       quantity: x["amount"],
//                       variant: x["variant"],
//                       index: index,
//                       title: x["title"],
//                       image: '',
//                       price: x["price"],
//                       isCheckout: true,
//                       hasSubTitle: true,
//                       subTitle: "",
//                       context: context,
//                     ) : Container();
//                   },
//                 )
//                     : Container();
//               }),
//           Center(
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection("users")
//                         .doc(FirebaseAuth.instance.currentUser!.uid)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       return snapshot.connectionState ==
//                           ConnectionState.waiting
//                           ? Container()
//                           : HStack(alignment: MainAxisAlignment.center, [
//                         RichText(
//                           text: TextSpan(
//                             text: 'Total: ',
//                             style: GoogleFonts.montserrat(
//                               fontSize: 14.sp,
//                               fontWeight: FontWeight.w400,
//                               color: const Color(0xff999999),
//                             ),
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text: 'EUR ${double.parse(snapshot.data!["total_amount"].toString()).toStringAsFixed(2).toString()}',
//                                 // text: "hello",
//                                 style: GoogleFonts.montserrat(
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.w700,
//                                   color: const Color(0xff000000),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ).px(8),
//                         12.widthBox,
//                         callToActionButton(
//                             width: 164.w,
//                             text: "Checkout",
//                             onPressed: () {
//                               num.parse(snapshot.data!["total_amount"]
//                                   .toString()) !=
//                                   0
//                                   ? Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         CheckoutScreen(
//                                           total: num.parse(snapshot
//                                               .data![
//                                           "total_amount"]
//                                               .toString()),
//                                         )),
//                               )
//                                   : Fluttertoast.showToast(
//                                   msg: "Cart is empty");
//                             }),
//                       ]).wFull(context);
//                     }),
//               ),
//             ),
//           )
//         ]),
//       ).pOnly(top: 20).scrollVertical(),
//       // bottomNavigationBar: const PeterBottomNavigationBar()
//     );
//   }
// }
