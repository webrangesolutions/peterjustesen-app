import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peterjustesen/core/models/Product.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';

import '../../core/bloc/cart_bloc.dart';
import '../../core/bloc/main_bloc/main_bloc.dart';
import '../widgets/PeterBottomNavigationBar.dart';
import '../widgets/ProductTile.dart';

class SingleCategoryScreen extends StatefulWidget {
  final String category;
  final String title;
  final bool search;

  const SingleCategoryScreen({
    super.key,
    required this.category,
    required this.title,
    this.search = false,
  });

  @override
  State<SingleCategoryScreen> createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen> {
  List<Product> products = [];
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
    var searchInputToLower = widget.category.toLowerCase();
    var searchInputToUpper = widget.category.toUpperCase();
    // print title and category
    print(widget.title);
    print(widget.category);

    return Scaffold(
      appBar: PeterAppBar(title: widget.title, sortingShown: true),
      // bottomNavigationBar: PeterBottomNavigationBar(),
      body: Center(
        child: StreamBuilder(
            stream: widget.search
                ? FirebaseFirestore.instance.collection("products").snapshots()
                : widget.category == "Latest"
                    ? FirebaseFirestore.instance.collection("products").orderBy("created_on", descending: true).snapshots()
                    : FirebaseFirestore.instance.collection("products").where("category", isEqualTo: widget.category).snapshots(),
            builder: (context, snapshot) {
              snapshot.hasData && snapshot.data!.docs.length > 0 ? print(snapshot.data!.docs[0]['title']) : print("No data");
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              return snapshot.hasData && snapshot.data!.docs.length > 0
                  ? widget.search
                      ? ListView(
                          children: List.generate(
                            snapshot.data!.docs.length,
                            (index) => snapshot.data!.docs[index]['title'].toLowerCase().contains(searchInputToLower) ||
                                    snapshot.data!.docs[index]['title'].toUpperCase().contains(searchInputToUpper)
                                ? ProductTile(
                                    id: snapshot.data!.docs[index].id,
                                    title: snapshot.data!.docs[index]['title'],
                                    price: snapshot.data!.docs[index]['price'],
                                    images: snapshot.data!.docs[index]['images'],
                                    description: snapshot.data!.docs[index]['description'],
                                    thumbnail: snapshot.data!.docs[index]['thumbnail'][0],
                                    variants: snapshot.data!.docs[index]['variants'],
                                    colors: snapshot.data!.docs[index]['colors'],
                                    index: index,
                                    category: snapshot.data!.docs[index]['category'],
                                    isFavourite: false,
                                  )
                                : Container(),
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1 / 1.2,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          children: widget.category == "Favorites"
                              ? List.generate(
                                  products.length,
                                  (index) => ProductTile(
                                        id: products[index].id,
                                        title: products[index].title,
                                        price: products[index].price,
                                        images: products[index].images,
                                        description: products[index].description,
                                        thumbnail: products[index].thumbnail,
                                        variants: products[index].variants,
                                    colors: snapshot.data!.docs[index]['colors'],
                                        index: index,
                                        category: products[index].category,
                                        isFavourite: true,
                                      ))
                              : [
                                  ...List.generate(
                                      snapshot.data!.docs.length,
                                      (index) => ProductTile(
                                            id: snapshot.data!.docs[index].id,
                                            title: snapshot.data!.docs[index]['title'],
                                            price: snapshot.data!.docs[index]['price'],
                                            images: snapshot.data!.docs[index]['images'],
                                            description: snapshot.data!.docs[index]['description'],
                                            thumbnail: snapshot.data!.docs[index]['thumbnail'][0],
                                            variants: snapshot.data!.docs[index]['variants'],
                                    colors: snapshot.data!.docs[index]['colors'],
                                            index: index,
                                            category: snapshot.data!.docs[index]['category'],
                                            isFavourite: false,
                                          )

                                      // : const Center(child: CircularProgressIndicator());
                                      ),
                                ],
                        )
                  : const Center(child: Text("No products found"));
            }),
      ),
    );
  }
}
