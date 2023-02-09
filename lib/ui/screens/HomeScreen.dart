import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/CategoriesScreen.dart';
import 'package:peterjustesen/ui/screens/SingleCategoryScreen.dart';
import 'package:peterjustesen/ui/widgets/ProductTile.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/bloc/cart_bloc.dart';
import '../../core/bloc/main_bloc/main_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //  add a pull to refresh?
  var categoriesList = <Widget>[];
  var productList = <Widget>[];

  bool isConnect = true;
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

    getCategories();
    getProducts();
  }

  getCategories() {
    FirebaseFirestore.instance.collection("category").get().then((value) {
      value.docs.forEach((element) {
        categoriesList.add(CategoryCard(
          id: element.id,
          title: element["name"],
          image: 'assets/images/${element["name"]}.svg',
          iconColor: Colors.black,
          bgColor: Color(0xffF0F0F0),
        ));
      });
      setState(() {});
    });
  }

  getProducts() {
    FirebaseFirestore.instance
        .collection("products")
        .limit(2)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          productList.add(BlocProvider.value(
            value: BlocProvider.of<CartBloc>(context),
            child: ProductTile(
              id: element.id,
              category: element["category"],
              description: element["description"],
              thumbnail: element["thumbnail"][0],
              images: element["images"],
              variants: element["variants"],
              colors: element['colors'],
              title: element["title"],
              price: element["price"],
              index: 99,
              isFavourite: value.data()!["favorites"].contains(
                        element.id,
                      )
                  ? true
                  : false,
            ),
          ));
        });
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .88,
        child: SingleChildScrollView(
          child: VStack([
            HomeHeader(),
            Flexible(
                child: Transform.scale(
                    scale: 1.05,
                    child: VxBox(
                            child: VStack([
                      HStack([
                        CategoryCard(
                          id: "Latest",
                          title: 'Latest',
                          image: 'assets/images/Latest.svg',
                          iconColor: Colors.white,
                          bgColor: primaryColor,
                          hasLeftPadding: false,
                        ),
                        ...categoriesList,
                        HStack([
                          "See All".text.fontFamily("Poppins").make(),
                          8.widthBox,
                          SvgPicture.asset("assets/images/arrow.svg"),
                        ]).pOnly(bottom: 17.h, left: 5.w).onTap(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CategoriesScreen()),
                          );
                        }),
                      ]).pLTRB(30, 18, 30, 34).scrollHorizontal(),
                      SizedBox(
                        height: 30.h,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30.w),
                          child: HStack(
                              alignment: MainAxisAlignment.spaceBetween,
                              [
                                "Latest Products"
                                    .text
                                    .size(20.sp)
                                    .letterSpacing(.5)
                                    .fontWeight(FontWeight.w700)
                                    .fontFamily("Montserrat")
                                    .make()
                                    .constrainedBox(
                                        BoxConstraints(minHeight: 24.h)),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: HStack([
                                    "See All".text.fontFamily("Poppins").make(),
                                    8.widthBox.onTap(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CategoriesScreen()),
                                      );
                                    }),
                                    SvgPicture.asset("assets/images/arrow.svg"),
                                  ]).onTap(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoriesScreen(),
                                      ),
                                    );
                                  }),
                                )
                              ]),
                        ),
                      ),

                      // product tiles
                      HStack([
                        15.widthBox,
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("products")
                              .limit(2)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return snapshot.hasData &&
                                    snapshot.data!.docs.length > 0
                                ? SizedBox(
                                    height: 1.sh * 0.4,
                                    width: MediaQuery.of(context).size.width *
                                        0.87,
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.7,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .snapshots(),
                                            builder: (context, user) {
                                              return user.hasData &&
                                                      user.data != null
                                                  ? ProductTile(
                                                      id: snapshot
                                                          .data!.docs[index].id,
                                                      category: snapshot
                                                              .data!.docs[index]
                                                          ["category"],
                                                      description: snapshot
                                                              .data!.docs[index]
                                                          ["description"],
                                                      thumbnail: snapshot
                                                              .data!.docs[index]
                                                          ["thumbnail"][0],
                                                      images: snapshot
                                                              .data!.docs[index]
                                                          ["images"],
                                                      variants: snapshot
                                                              .data!.docs[index]
                                                          ["variants"],
                                                      colors: snapshot
                                                              .data!.docs[index]
                                                          ['colors'],
                                                      title: snapshot.data!
                                                          .docs[index]["title"],
                                                      price: snapshot.data!
                                                          .docs[index]["price"],
                                                      isFavourite: user.data![
                                                                  "favorites"]
                                                              .contains(
                                                        snapshot.data!
                                                            .docs[index].id,
                                                      )
                                                          ? true
                                                          : false,
                                                      index: index,
                                                    )
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                            });
                                      },
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      ]).px4().scrollVertical(),
                      SizedBox(
                        height: 129.h,
                      ),
                      Vr_Card(),
                      SizedBox(
                        height: 20.h,
                      ),
                    ]))
                        .color(Colors.white)
                        .topRounded(value: 42)
                        .makeCentered()))
          ]),
        ),
      ),
      // bottomNavigationBar: PeterBottomNavigationBar(),
    );
  }
}

class CategoryCard extends StatefulWidget {
  final String title;
  final String image;
  final Color iconColor;
  final Color bgColor;
  bool hasLeftPadding;
  final String id;

  CategoryCard({
    Key? key,
    required this.title,
    required this.image,
    required this.iconColor,
    required this.bgColor,
    this.hasLeftPadding = true,
    required this.id,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  double leftPadding = 12.5.w;

  @override
  initState() {
    super.initState();
    leftPadding = widget.hasLeftPadding ? 12.5.w : 0.0.w;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SingleCategoryScreen(
                    category: widget.id,
                    title: widget.title,
                  )),
        );
      },
      child: VStack(
        crossAlignment: CrossAxisAlignment.center,
        [
          VxBox(
            child: SvgPicture.asset(
              widget.image,
              color: widget.title == "Latest" ? Colors.white : widget.iconColor,
            ).p(8),
          )
              .color(widget.title == "Latest" ? primaryColor : widget.bgColor)
              .withRounded(value: 12)
              .size(44.w, 44.h)
              .make()
              .pLTRB(leftPadding, 0, 12.5.w, 0),
          10.heightBox,
          widget.title.text
              .color(Colors.black)
              .size(8.sp)
              .normal
              .letterSpacing(.5)
              .fontFamily(
                "Montserrat",
              )
              .make()
              // when first widget you want to remove the left padding and also
              // move the text back a little bit back by giving right padding to adjust since they are
              // not aligned and are in a column
              .pOnly(right: widget.hasLeftPadding ? 0.w : 12.w),
        ],
      ),
    );
  }
}

class Vr_Card extends StatelessWidget {
  const Vr_Card({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VxBox(
            child: HStack(alignment: MainAxisAlignment.spaceBetween, [
      SizedBox(
        width: 180.w,
        child: VStack([
          // h1

          SizedBox(
            width: 260.w,
            height: 28.h,
            child: Text(
              'Virtual Reality Showroom',
              maxLines: 1,
              style: custom_montserratTextTheme.displayLarge
                  ?.copyWith(color: const Color(0xFFE68314), fontSize: 12.sp),
            ),
          ),
          // text
          SizedBox(
              width: 148.w,
              height: 27.h,
              child: VStack([
                Text(
                    "Allows you to view our showrooms containing our latest furniture collections",
                    style: custom_montserratTextTheme.bodyText2?.copyWith(
                        color: const Color(0xFFE68314), fontSize: 6.sp)),
              ])),

          Text("Coming Soon",
              style: custom_montserratTextTheme.bodyText2
                  ?.copyWith(color: Colors.black, fontSize: 10.sp)),
        ]).pLTRB(4.w, 0, 0, 0),
      ),
      //vr goggles img
      Image.asset(
        'assets/images/vr_goggles.png',
        fit: BoxFit.cover,
        width: 130.w,
        height: 83.h,
      ),
    ]).px8())
        .color(const Color(0xFFEFE5D5))
        .height(110.h)
        .width(336.w)
        .roundedSM
        .make()
        .pSymmetric(
          h: 24.h,
          v: 20.h,
        );
    // .pLTRB(24.w, 12.h, 11.w, 4.h);
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ColorFiltered(
        colorFilter:
            ColorFilter.mode(primaryColor.withOpacity(0.9), BlendMode.srcOver),
        // bg image
        child: Container(
          width: 1.sw,
          height: 271.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/header_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      SizedBox(
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // logo
            Container(
              margin: EdgeInsets.only(top: 50.h),
              child: Image.asset(
                'assets/images/PJ_logo_white 1.png',
                width: 296.w,
                height: 77.h,
                fit: BoxFit.cover,
              ),
            ),
            // search field
            const HomeSearchField(),
          ],
        ),
      ),
    ]);
  }
}

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .79.sw,
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // search icon
          Icon(
            Icons.search,
            color: Colors.black,
            size: 20.sp,
          ).box.margin(EdgeInsets.only(left: 6.w)).make().p12(),
          // search field
          Expanded(
            child: SizedBox(
              height: 40.h,
              width: 1.sw,
              child: TextField(
                maxLines: 1,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  // search
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SingleCategoryScreen(
                                category: value,
                                title: "Search results",
                                search: true,
                              )));
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8.0),
                  border: InputBorder.none,
                  hintText: 'Search Item',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ).centered(),
    ).box.make().py24();
  }
}
