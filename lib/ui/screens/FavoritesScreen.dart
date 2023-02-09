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

class FavoritesScreen extends StatefulWidget {
  final String category;
  final String title;
  final bool search;

  const FavoritesScreen({
    super.key,
    required this.category,
    required this.title,
    this.search = false,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Product> products = [];

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
      appBar: PeterAppBarOne(title: 'Favourite', sortingShown: true),
      // bottomNavigationBar: PeterBottomNavigationBar(),
      body: Center(
        child: FutureBuilder(
            future:
                // get all products in favorites array of user doc
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get()
                    .then((value) => value.data()!['favorites'])
                    .then((value) => FirebaseFirestore.instance
                        .collection("products")
                        .where(FieldPath.documentId, whereIn: value)
                        .get()),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return const Text("No favorites");
              }
              return snapshot.hasData && snapshot.data != null
                  ? GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1 / 1.2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      children:
                          List.generate(snapshot.data!.docs.length, ((index) {
                        return ProductTile(
                          id: snapshot.data!.docs[index].id,
                          title: snapshot.data!.docs[index]['title'],
                          price: snapshot.data!.docs[index]['price'],
                          thumbnail: snapshot.data!.docs[index]['thumbnail'][0],
                          category: snapshot.data!.docs[index]['category'],
                          description: snapshot.data!.docs[index]
                              ['description'],
                          images: snapshot.data!.docs[index]['images'],
                          variants: snapshot.data!.docs[index]['variants'],
                          colors: snapshot.data!.docs[index]['colors'],
                          index: index,
                          isFavourite: true,
                        );
                      })),
                    )
                  : Container();
            }),
      ),
    );
  }
}
