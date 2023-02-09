import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peterjustesen/core/bloc/main_bloc/main_bloc.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/ui/screens/CartScreen.dart';
import 'package:peterjustesen/ui/screens/CategoriesScreen.dart';
import 'package:peterjustesen/ui/screens/FavoritesScreen.dart';
import 'package:peterjustesen/ui/screens/ProfileScreen.dart';
import 'package:peterjustesen/ui/screens/SingleCategoryScreen.dart';

import '../../../core/services/netwrokConnectivity.dart';
import '../HomeScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // String selectedState = tabsList[0];
  final tabsList = ["Home", "Cart", "Favourite", "Profile", "All Categories", "Chair", "ChairView"];

  final tabs = [
    const HomeScreen(),
    const CategoriesScreen(),
    const CategoriesScreen(),
    const CategoriesScreen(),
    const CategoriesScreen(),
    const SingleCategoryScreen(
      category: "Chair",
      title: "Chair",
    ),
  ];

  int _index = 0;

  final pages = [
    HomeScreen(),
    CartScreen(),
    FavoritesScreen(category: 'favorites', title: 'favorites'),
    ProfileScreen(),
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

  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeterMainBloc, PeterState>(
      builder: (context, state) {
        String selectedTab = state.selectedTab;
        bool isNavbarHidden = state.isNavBarHidden;

        return Scaffold(
          // !BODY
          body: WillPopScope(
             child: pages[tabsList.indexOf(selectedTab)],
            // child: pages[_index],
            onWillPop: () async {
              return false;
            },
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   backgroundColor: Colors.white,
          //   type: BottomNavigationBarType.fixed,
          //   selectedItemColor: primaryColor,
          //   unselectedItemColor: Colors.grey,
          //   onTap: (val){
          //     setState(() {
          //       _index = val;
          //       print(_index);
          //     });
          //   },
          //   items: [
          //     BottomNavigationBarItem(icon: Image.asset(tabsContent[0]['img']!), label: tabsContent[0]['title']!),
          //     BottomNavigationBarItem(icon: Image.asset(tabsContent[1]['img']!), label: tabsContent[1]['title']!),
          //     BottomNavigationBarItem(icon: Image.asset(tabsContent[2]['img']!), label: tabsContent[2]['title']!),
          //     BottomNavigationBarItem(icon: Image.asset(tabsContent[3]['img']!), label: tabsContent[3]['title']!),
          //   ],
          // ),
          // !BOTTOM NAVIGATION BAR
          bottomNavigationBar: isNavbarHidden
              ? Container()
              : Container(
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<PeterMainBloc>(context).add(TabChanged(tabName: tabsList[0]));
                          },
                          child: navItem(selectedTab, tabsContent[0]['title'], tabsContent[0]['img']),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<PeterMainBloc>(context).add(TabChanged(tabName: tabsList[1]));
                          },
                          child: navItem(selectedTab, tabsContent[1]['title'], tabsContent[1]['img']),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<PeterMainBloc>(context).add(TabChanged(tabName: tabsList[2]));
                          },
                          child: navItem(selectedTab, tabsContent[2]['title'], tabsContent[2]['img']),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<PeterMainBloc>(context).add(TabChanged(tabName: tabsList[3]));
                          },
                          child: navItem(selectedTab, tabsContent[3]['title'], tabsContent[3]['img']),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget navItem(selectedTab, title, img) {

    print([img, title]);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        title == selectedTab ? SvgPicture.asset(img, height: 24, width: 24, color: primaryColor) : SvgPicture.asset(img, height: 24, width: 24, color: Colors.grey),
        const SizedBox(height: 2),
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            color: title == selectedTab ? primaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(5.r),
          ),
        )
        // : Container(),
        ,
        const SizedBox(height: 2),
        if (selectedTab == tabsContent.indexOf({'title': title, 'img': img}))
          Text(
            title,
            style: GoogleFonts.poppins(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
        else
          Text( 
            title,
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
