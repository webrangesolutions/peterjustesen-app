import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peterjustesen/core/bloc/cart_bloc.dart';
import 'package:peterjustesen/core/bloc/main_bloc/main_bloc.dart';
import 'package:peterjustesen/ui/screens/ProductDetailsScreen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/constants/constants.dart';

class ProductTile extends StatefulWidget {
  final String id;
  final String thumbnail;
  final String title;
  final String price;
  final double rating;
  bool isFavourite;
  final int index;
  final String category;
  final String description;
  final List images;
  final List variants;
  final List colors;

  ProductTile({
    Key? key,
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.price,
    this.index = 0,
    this.rating = 0.0,
    this.isFavourite = false,
    required this.category,
    required this.description,
    required this.images,
    required this.variants,
    required this.colors,
  }) : super(key: key);

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: BlocProvider.of<CartBloc>(context),
              child: ProductDetailsScreen(
                id: widget.id,
                thumbnail: widget.thumbnail,
                title: widget.title,
                price: widget.price,
                variants: widget.variants,
                category: widget.category,
                description: widget.description,
                images: widget.images,
                colors: widget.colors,
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(13.5, 0, 0, 0),
        child: VxBox(
          child: VStack(alignment: MainAxisAlignment.center, [
            Flexible(
              child: ZStack([
                Hero(
                  tag: "product${widget.id}",
                  child: Container(
                      height: 150.h,
                      width: 150.w,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(),
                      child: Image(
                        image: NetworkImage(widget.thumbnail),
                      )),
                ),
                Positioned(
                  top: 0,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () {
                      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                        if (value.data()!["favorites"].contains(widget.id)) {
                          widget.isFavourite = false;
                          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                            "favorites": FieldValue.arrayRemove([widget.id]),
                          });
                          setState(() {});
                        } else {
                          widget.isFavourite = true;
                          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                            "favorites": FieldValue.arrayUnion([widget.id]),
                          });
                          setState(() {});
                        }
                      });
                    },
                    child: widget.isFavourite
                        ? SvgPicture.asset(
                            "assets/bottomIcons/favourite_filled.svg",
                            height: 18.11.h,
                            width: 20.18.w,
                          )
                        : SvgPicture.asset(
                            "assets/bottomIcons/favourite.svg",
                            height: 18.11.h,
                            width: 20.18.w,
                          ),
                  ),
                ),
              ]),
            ),
            "${widget.title}".text.size(16.sp).fontFamily("Montserrat").bold.color(primaryColor).make(),
            "${widget.price}".text.size(15.sp).fontFamily("Montserrat").semiBold.make(),
          ]),
        ).size(162.w, 196.h).margin(EdgeInsets.only(left: 0, top: 36.h, right: 0, bottom: 0)).make().py12(),
      ),
    );
  }
}
