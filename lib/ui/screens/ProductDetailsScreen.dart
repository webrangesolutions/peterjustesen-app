import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/bloc/cart_bloc.dart';
import 'package:peterjustesen/core/bloc/main_bloc/main_bloc.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/CartScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/models/InCartProduct.dart';

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class variationCubit extends Cubit<int> {
  variationCubit() : super(0);

  void changeVariation(int index) {
    emit(index);
  }

  void resetVariation() {
    emit(0);
  }
}

class itemCountCubit extends Cubit<int> {
  itemCountCubit() : super(1);

  void incrementItemCount() {
    emit(state + 1);
  }

  void decrementItemCount() {
    if (state > 1) {
      emit(state - 1);
    }
  }
}

class ProductDetailsScreen extends StatefulWidget {
  final String id;
  final String thumbnail;
  final String title;
  final String price;
  final List variants;
  final List colors;
  final String category;
  final String description;
  final List images;

  const ProductDetailsScreen(
      {super.key,
      required this.id,
      required this.thumbnail,
      required this.title,
      required this.price,
      required this.variants,
      required this.colors,
      required this.category,
      required this.description,
      required this.images});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int itemCount = 1;
  int selectedVariant = 0;
  List<dynamic> variantsData = [];
  List<String> variantsDataVerify = [];

  var subscription;

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
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => variationCubit(),
          ),
          BlocProvider(
            create: (context) => itemCountCubit(),
          ),
        ],
        child: BlocBuilder<itemCountCubit, int>(builder: (ctx, state) {
          var count = ctx.read<itemCountCubit>().state;
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(shrinkWrap: true, children: [
              ZStack([
                Transform.scale(
                  scale: 1.1,
                  child: Image.asset(
                    "assets/images/hero_bg.png",
                    height: 275.h,
                    width: 375.w,
                  ),
                ),
                Positioned(
                  top: 36.h,
                  left: 20.w,
                  child: SizedBox(
                    height: 32.h,
                    width: 32.w,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Transform.scale(
                        scaleX: -1,
                        child: SvgPicture.asset(
                          color: Colors.white,
                          "assets/images/arrow.svg",
                        ),
                      ),
                    )
                        .box
                        .roundedSM
                        .color(Color.fromARGB(193, 37, 37, 37))
                        .make()
                        .onTap(() {
                      Navigator.pop(context);
                    }),
                  ),
                ),
                // Positioned image
                Positioned(
                  top: 26.h,
                  right: 65.w,
                  child: SizedBox(
                    height: 250.h,
                    width: 250.w,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: NetworkImage(widget.thumbnail),
                        )),
                  ),
                ),
              ]),
              24.heightBox,
              HStack(alignment: MainAxisAlignment.spaceBetween, [
                Text(
                  widget.title,
                  style: custom_montserratTextTheme.headline5!.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get()
                        .then((value) {
                      if (value.data()!['favorites'].contains(widget.id)) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          "favorites": FieldValue.arrayRemove([widget.id])
                        }, SetOptions(merge: true)).then((value) {
                          Fluttertoast.showToast(msg: "Removed from favorites");
                        });
                      } else {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          "favorites": FieldValue.arrayUnion([widget.id])
                        }).then((value) {
                          Fluttertoast.showToast(msg: "Saved to favorites");
                        });
                      }
                    });
                  },
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData && snapshot.data != null
                            ? SizedBox(
                                height: 32.h,
                                width: 32.w,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    color: Colors.black,
                                    snapshot.data!['favorites']
                                            .contains(widget.id)
                                        ? "assets/images/bookmark_filled.svg"
                                        : "assets/images/bookmark.svg",
                                  ),
                                )
                                    .box
                                    .roundedFull
                                    .color(Color(0xFFE0E0E0))
                                    .make())
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  color: Colors.black,
                                  "assets/images/bookmark.svg",
                                ),
                              ).box.roundedFull.color(Color(0xFFE0E0E0)).make();
                      }),
                ),
              ]).px(20).wFull(context),
              18.heightBox,
              HStack(alignment: MainAxisAlignment.spaceBetween, [
                Text(
                  "EUR ${widget.price}",
                  style: custom_montserratTextTheme.headline5!.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                HStack(
                  alignment: MainAxisAlignment.spaceBetween,
                  [
                    GestureDetector(
                      onTap: () {
                        ctx.read<itemCountCubit>().decrementItemCount();
                      },
                      child: SvgPicture.asset(
                        "assets/images/minus.svg",
                        height: 22.h,
                        width: 22.w,
                      ),
                    ),
                    18.widthBox,
                    Text(
                      count.toString(),
                      style: custom_poppinsTextTheme.bodySmall!.copyWith(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                    18.widthBox,
                    GestureDetector(
                      onTap: () {
                        ctx.read<itemCountCubit>().incrementItemCount();
                      },
                      child: SvgPicture.asset(
                        "assets/images/plus.svg",
                        height: 22.h,
                        width: 22.w,
                      ),
                    ),
                    5.widthBox,
                  ],
                ),
              ]).px(20).wFull(context),
              24.heightBox,
              Container(
                  child: HStack(alignment: MainAxisAlignment.start, [
                ...widget.colors
                    .map<Widget>((e) => Row(
                          children: [
                            ColorCircleVariant(
                              context: ctx,
                              index: widget.colors.indexOf(e),
                              color: fromHex("#" +
                                  widget.colors[widget.colors.indexOf(e)]),
                            ),
                            8.heightBox,
                          ],
                        ))
                    .toList()
              ])).px(20).wFull(context),
              20.heightBox,
              Container(
                  child: VStack(alignment: MainAxisAlignment.start, [
                ...widget.variants
                    .map<Widget>((e) => Column(
                          children: [
                            HStack(alignment: MainAxisAlignment.start, [
                              ...e['values']
                                  .map<Widget>((ee) => Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                variantsData.clear();
                                                variantsData.add({'variantType': e['variantType'], 'variantValue': ee});
                                              });
                                              print(variantsData);
                                            },
                                            child: Text(
                                              ee.toString(),
                                              style: custom_montserratTextTheme
                                                  .headline5!
                                                  .copyWith(
                                                      color: variantsData.length > 0 && variantsData.where((v) => v['variantValue'] == ee).length > 0 ? Colors.black : Colors.grey.shade500,
                                                      fontSize: variantsData.length > 0 && variantsData.where((v) => v['variantValue'] == ee).length > 0 ? 14 : 12,
                                                      fontWeight: variantsData.length > 0 && variantsData.where((v) => v['variantValue'] == ee).length > 0  ?
                                                          FontWeight.w700 : FontWeight.w500),
                                            ),
                                          ),
                                          8.widthBox,
                                        ],
                                      ))
                                  .toList()
                            ]),
                            8.heightBox,
                          ],
                        ))
                    .toList()
              ])).px(20).wFull(context),
              20.heightBox,
              HStack(alignment: MainAxisAlignment.start, [
                Text(
                  "Description",
                  style: custom_montserratTextTheme.headline5!.copyWith(
                      color: primaryColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700),
                )
                    .px(20)
                    .centered()
                    .box
                    .color(Color(0xFFbfc7f2))
                    .roundedSM
                    .size(120.w, 37.h)
                    .make()
                    .px(20),
                2.widthBox,
                Text(
                  "Text Reviews",
                  style: custom_montserratTextTheme.headline5!.copyWith(
                      color: const Color(0xFFAAAAAA),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400),
                ).px(20),
              ]),
              VxBox(
                child: Text(
                  widget.description,
                  maxLines: 3,
                  style: custom_montserratTextTheme.headline5!.copyWith(
                      height: 2.h,
                      color: const Color(0xFFAAAAAA),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ).size(327.w, 120.h).make().p(20),
              20.heightBox,
              VxBox(
                child: SizedBox(
                  width: 235.w,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      // BlocProvider.of<CartBloc>(context).add(AddToCartEvent(
                      //   id: widget.id,
                      //   variant: widget.variants[ctx.read<variationCubit>().state],
                      //   amount: ctx.read<itemCountCubit>().state,
                      // ));
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "cart": FieldValue.arrayUnion([
                          {
                            "id": const Uuid().v4(),
                            'uid': widget.id,
                            "variant": variantsData,
                            "amount": ctx.read<itemCountCubit>().state,
                            "price": widget.price,
                            "title": widget.title,
                            'timestamp': DateTime.now().microsecondsSinceEpoch
                          }
                        ])
                      }).then((value) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get()
                            .then((user) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "total_amount": num.parse(
                                    user.data()!['total_amount'].toString()) +
                                (num.parse(widget.price.replaceAll(',', '.')) *
                                    ctx.read<itemCountCubit>().state)
                          });
                          Fluttertoast.showToast(msg: "Added to cart");
                        });
                      });

                      BlocProvider.of<PeterMainBloc>(context)
                          .add(TabChanged(tabName: "Cart"));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                                  value: BlocProvider.of<CartBloc>(context),
                                  child: CartScreen(),
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SvgPicture.asset("assets/images/creditcard.svg"),
                          Text(
                            "Add to Cart",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                  ),
                ).centered(),
              )
                  .size(MediaQuery.of(context).size.width.toDouble(), 90.h)
                  .border(
                      color: Color(0xFFE8E8E8),
                      width: 1,
                      style: BorderStyle.solid)
                  .make()
            ]),
          );
        }),
      ),
    );
  }

  isFavorite(id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      return value.data()!["saved"].contains(id);
    });
  }
}

class ColorCircleVariant extends StatefulWidget {
  final Color color;
  final int index;
  final BuildContext context;

  const ColorCircleVariant({
    Key? key,
    required this.color,
    required this.index,
    required this.context,
  }) : super(key: key);

  @override
  State<ColorCircleVariant> createState() => _ColorCircleVariantState();
}

class _ColorCircleVariantState extends State<ColorCircleVariant> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<variationCubit, int>(
      builder: (context, state) {
        final selectedVariant = context.read<variationCubit>().state;
        return GestureDetector(
          onTap: () {
            context.read<variationCubit>().changeVariation(widget.index);
          },
          child: Padding(
            padding: widget.index == 0
                ? const EdgeInsets.only(left: 0)
                : const EdgeInsets.only(left: 8),
            child: Container(
              height: 24.h,
              width: 24.w,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedVariant == widget.index
                      ? Color(0xFFCBCBCB)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
