import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/SingleCategoryScreen.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/bloc/cart_bloc.dart';
import '../../core/bloc/main_bloc/main_bloc.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // list of categories icons
  List<Category> categories = [];

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

  void initState() {
    super.initState();
    getCategories();

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

  getCategories() async {
    FirebaseFirestore.instance.collection("category").get().then((value) {
      categories = value.docs.map<Category>((e) => Category(id: e.id, title: e['name'], image: 'assets/images/${e['name']}.svg')).toList();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: const PeterAppBar(
        title: "All Categories",
        sortingShown: true,
      ),
      // bottomNavigationBar: BlocProvider.value(
      //   value: BlocProvider.of<PeterMainBloc>(context),
      //   child: PeterBottomNavigationBar(),
      // ),
      body: Center(
          child: Container(
        height: 605.h,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 30,
          children: [
            // latest products
            CategoryTile(
              title: 'Latest',
              image: 'assets/images/Latest.svg',
              id: 'Latest',
            ).onTap(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleCategoryScreen(
                            category: 'Latest',
                            title: 'Latest',
                          )));
            }),
            ...List.generate(
              categories.length,
              (index) => CategoryTile(
                id: categories[index].id,
                title: categories[index].title,
                image: categories[index].image,
              ).onTap(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleCategoryScreen(
                              category: categories[index].id,
                              title: categories[index].title,
                            )));
              }),
            ),
          ],
        ),
      )),
    );
  }
}

class CategoryTile extends StatelessWidget {
  String title;
  String image;
  String id;

  CategoryTile({Key? key, required this.title, required this.image, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack(crossAlignment: CrossAxisAlignment.center, [
      Container(
        height: 132.h,
        width: 132.w,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffbfc7f2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SvgPicture.asset(
          image,
          color: primaryColor,
        ).p12(),
      ),
      Text(
        title,
        textAlign: TextAlign.center,
        style: custom_montserratTextTheme.headline5?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
        ),
      ),
    ]);
  }
}

class Category {
  final String id;
  final String image;
  final String title;

  Category({required this.id, required this.image, required this.title});
}
