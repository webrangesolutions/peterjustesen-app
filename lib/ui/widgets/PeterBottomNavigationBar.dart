import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/bloc/cart_bloc.dart';
import 'package:peterjustesen/core/bloc/main_bloc/main_bloc.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/CartScreen.dart';
import 'package:peterjustesen/ui/screens/CategoriesScreen.dart';
import 'package:peterjustesen/ui/screens/FavoritesScreen.dart';
import 'package:peterjustesen/ui/screens/ProfileScreen.dart';
import 'package:peterjustesen/ui/screens/SingleCategoryScreen.dart';
import 'package:peterjustesen/ui/screens/HomeScreen.dart';
import 'package:peterjustesen/ui/screens/Tabs/MainScreen.dart';

class PeterBottomNavigationBar extends StatefulWidget {
  const PeterBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  State<PeterBottomNavigationBar> createState() => _PeterBottomNavigationBarState();
}

class _PeterBottomNavigationBarState extends State<PeterBottomNavigationBar> {
  final tabsList = [
    "Home",
    "Cart",
    "Favourite",
    "Profile",
  ];

  final tabs = [
    const HomeScreen(),
    const CartScreen(),
    const FavoritesScreen(category: "favorites", title: "favorite"),
    const CategoriesScreen(),
  ];

  final tabsContent = [
    {
      'title': 'Home',
      'img': 'assets/bottomIcons/home.svg',
    },
    {
      'title': 'Cart',
      'img': 'assets/bottomIcons/cart.svg',
    },
    {
      'title': 'Favourite',
      'img': 'assets/bottomIcons/heart.svg',
    },
    {
      'title': 'Profile',
      'img': 'assets/bottomIcons/profile.svg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeterMainBloc, PeterState>(
      builder: (context, state) {
        String selectedTab = state.selectedTab;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // a line on top
            border: Border(
              top: BorderSide(
                color: Colors.black.withOpacity(0.2),
                width: 1.w,
              ),
            ),
          ),
          height: 90.h,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<PeterMainBloc>(context).add(TabChanged(tabName: tabsList[0]));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider.value(value: BlocProvider.of<CartBloc>(context), child: HomeScreen())));
                  },
                  child: navItem(tabsList[0], tabsContent[0]['img'], selectedTab, tabsList, tabsContent),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<PeterMainBloc>(context).add(TabChanged(tabName: tabsList[1]));
                    EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.black, dismissOnTap: false);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                  child: navItem(tabsList[1], tabsContent[1]['img'], selectedTab, tabsList, tabsContent),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<PeterMainBloc>(context).add(TabChanged(tabName: tabsList[2]));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                                value: BlocProvider.of<CartBloc>(context),
                                child: FavoritesScreen(
                                  category: "favorites",
                                  title: "Favorites",
                                ))));
                  },
                  child: navItem(tabsList[2], tabsContent[2]['img'], selectedTab, tabsList, tabsContent),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<PeterMainBloc>(context).add(TabChanged(tabName: tabsList[3]));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BlocProvider.value(value: BlocProvider.of<CartBloc>(context), child: ProfileScreen())));
                  },
                  child: navItem(tabsList[3], tabsContent[3]['img'], selectedTab, tabsList, tabsContent),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget navItem(title, img, selectedState, tabsList, tabsContent) {
  return Padding(
    padding: EdgeInsets.all(20.w),
    // how to make it responsive
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (title == selectedState)
          Flexible(child: SvgPicture.asset(img, height: 24, width: 24, color: primaryColor))
        else
          Flexible(child: SvgPicture.asset(img, height: 24, width: 24, color: Colors.grey)),
        SizedBox(height: 1.w),
        title == selectedState
            ? Container(
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: title == selectedState ? primaryColor : Colors.grey,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              )
            : Container(),
        const SizedBox(height: 2),
        if (selectedState == title)
          Flexible(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Flexible(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    ),
  );
}
