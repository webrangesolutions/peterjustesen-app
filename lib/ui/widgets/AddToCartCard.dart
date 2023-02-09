import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/bloc/cart_bloc.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/core/models/InCartProduct.dart';
import 'package:peterjustesen/ui/screens/CheckoutScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

class AddToCartCard extends StatefulWidget {
  String title;
  String image;
  String price;
  int quantity;
  List variant;
  bool isCheckout;
  bool? hasSubTitle;
  String? subTitle;
  late BuildContext context;
  String id;
  String productId;
  int index;
  bool isOrder;

  AddToCartCard({
    super.key,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
    required this.variant,
    required this.id,
    required this.productId,
    required this.index,
    required this.context,
    this.subTitle = "",
    this.isCheckout = false,
    this.hasSubTitle = false,
    this.isOrder = false,
  });

  @override
  State<AddToCartCard> createState() => _AddToCartCardState();
}

class _AddToCartCardState extends State<AddToCartCard> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context),
      child: VStack([
        Card(
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: VStack(
            [
              widget.isCheckout
                  ? HStack(alignment: MainAxisAlignment.end, [
                      !widget.isOrder
                          ? GestureDetector(
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
                                                  (e) => e["id"] != widget.id)
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
                                          var price = num.parse(widget.price
                                              .replaceAll(',', '.'));
                                          var quantity = num.parse(
                                              widget.quantity.toString());
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
                            )
                          : Container(),
                    ]).wFull(context)
                  : Container(),
              Row(
                children: [
                  FutureBuilder(
                      future: fetchProduct(widget.productId, 'img'),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Flexible(
                            child: Image(
                              image: NetworkImage('${snapshot.data['img']}'),
                              height: 87.h,
                              width: 87.w,
                            ),
                          );
                        } else {
                          return Center(child: CupertinoActivityIndicator());
                        }
                      }),
                  // Flexible(
                  //   child: Image(
                  //     image: NetworkImage(widget.image),
                  //     height: 87.h,
                  //     width: 87.w,
                  //   ),
                  // ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // GestureDetector(
                      //   onTap: (){
                      //     fetchProduct(widget.productId, 'title');
                      //   },
                      //   child: Text(
                      //     '${widget.title}',
                      //     style: GoogleFonts.montserrat(
                      //       fontSize: 14.sp,
                      //       fontWeight: FontWeight.w700,
                      //       color: const Color(0xff000000),
                      //     ),
                      //   ),
                      // ),

                      FutureBuilder(
                          future: fetchProduct(widget.productId, 'title'),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                '${snapshot.data['title']}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff000000),
                                ),
                              );
                            } else {
                              return Text(
                                'Loading...',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff000000),
                                ),
                              );
                            }
                          }),

                      8.heightBox,
                      FutureBuilder(
                          future: fetchProduct(widget.productId, 'description'),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                '${snapshot.data['description']}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff999999),
                                ),
                              );
                            } else {
                              return Text(
                                'Loading...',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff000000),
                                ),
                              );
                            }
                          }),
                      // widget.hasSubTitle == null
                      //     ? Text(
                      //         widget.variant.toString(),
                      //         style: GoogleFonts.montserrat(
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.w400,
                      //           color: const Color(0xff999999),
                      //         ),
                      //       )
                      //     : Text(
                      //         widget.subTitle!,
                      //         style: GoogleFonts.montserrat(
                      //           fontSize: 12.sp,
                      //           fontWeight: FontWeight.w400,
                      //           color: const Color(0xff999999),
                      //         ),
                      //       ),
                    ],
                  ),
                  Spacer(),
                  VStack(crossAlignment: CrossAxisAlignment.end, [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? CircularProgressIndicator().centered()
                              : Text(
                                  "EUR ${widget.price.isNotEmpty ? widget.price : '0.0'}",
                                  style: custom_montserratTextTheme.bodySmall!
                                      .copyWith(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp),
                                ).pOnly(right: 10.w);
                        }),
                    8.heightBox,
                    widget.isCheckout
                        ? HStack(
                            alignment: MainAxisAlignment.spaceBetween,
                            [
                              GestureDetector(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .get()
                                      .then((doc) {
                                    doc.get('cart').forEach((c) async {
                                      if (c['id'] == widget.id) {
                                        if (c['amount'] > 1) {
                                          var x;

                                          setState(() {
                                            x = c;
                                          });

                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            'cart': FieldValue.arrayRemove([c])
                                          });

                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            'total_amount':
                                                doc.get('total_amount') -
                                                    num.parse(x['price']
                                                        .replaceAll(',', '.')),
                                            'cart': FieldValue.arrayUnion([
                                              {
                                                'id': x['id'],
                                                'amount': x['amount'] - 1,
                                                'price': x['price'],
                                                'title': x['title'],
                                                'timestamp': x['timestamp'],
                                                'uid': x['uid'],
                                                'variant': x['variant']
                                              }
                                            ])
                                          });
                                        }else{
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                              .update({
                                            'cart': FieldValue.arrayRemove([c])
                                          });
                                        }
                                      }
                                    });
                                  });
                                },
                                child: SvgPicture.asset(
                                  "assets/images/minus.svg",
                                  color: Colors.black,
                                  height: 22.h,
                                  width: 22.w,
                                ),
                              ),
                              18.widthBox,
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return snapshot.connectionState ==
                                            ConnectionState.waiting
                                        ? CircularProgressIndicator().centered()
                                        : Text(
                                            "${snapshot.data!["cart"].where((c) => c['uid'] == widget.productId).length > 0 ? snapshot.data!["cart"].where((c) => c['uid'] == widget.productId).first['amount'] : '0.0'}",
                                            style: custom_poppinsTextTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w700),
                                          );
                                  }),
                              18.widthBox,
                              GestureDetector(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .get()
                                      .then((doc) {
                                    doc.get('cart').forEach((c) async {
                                      if (c['id'] == widget.id) {
                                        var x;

                                        setState(() {
                                          x = c;
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          'cart': FieldValue.arrayRemove([x])
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          'total_amount':
                                              doc.get('total_amount') +
                                                  num.parse(x['price']
                                                      .replaceAll(',', '.')),
                                          'cart': FieldValue.arrayUnion([
                                            {
                                              'id': x['id'],
                                              'amount': x['amount'] + 1,
                                              'price': x['price'],
                                              'title': x['title'],
                                              'timestamp': x['timestamp'],
                                              'uid': x['uid'],
                                              'variant': x['variant']
                                            }
                                          ])
                                        });
                                      }
                                    });
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
                        : Container(),
                  ]),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }

  fetchProduct(uid, opt) async {
    var msg = {};
    print([widget.productId, widget.title]);

    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
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
